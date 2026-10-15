"""
Tests for the release tools that talk to other sites: Tools/discord_post.py. Nothing is sent:
the network call is replaced.

    python Tools/test_release.py
"""

import contextlib
import io
import json
import os
import shutil
import sys
import tempfile
import unittest
from unittest import mock

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import discord_post  # noqa: E402

HOOK = "https://discord.com/api/webhooks/123456789012345678/abcDEF-ghi_JKL"


class DiscordPost(unittest.TestCase):
    def setUp(self):
        self.folder = tempfile.mkdtemp(prefix="release-test-")
        open(os.path.join(self.folder, "Aegis_Forever_Instance_Journal-v0.27.0.zip"), "wb").close()
        with open(os.path.join(self.folder, "notes.md"), "w", encoding="utf-8") as handle:
            handle.write("- **New: boss portraits.** @everyone look!\n")

    def tearDown(self):
        shutil.rmtree(self.folder, ignore_errors=True)

    def run_main(self, env, *flags):
        out = io.StringIO()
        with mock.patch.dict(os.environ, env, clear=True), mock.patch.object(sys, "argv", ["x", self.folder] + list(flags)), \
                contextlib.redirect_stdout(out):
            code = discord_post.main()
        return code, out.getvalue()

    def test_no_secret_posts_nothing(self):
        with mock.patch.object(discord_post, "post") as post:
            code, out = self.run_main({})
        self.assertEqual(code, 0)
        post.assert_not_called()
        self.assertIn("skipped", out)
        self.assertFalse(os.path.exists(os.path.join(self.folder, "discord.txt")))

    def test_posts_once_and_leaves_a_marker(self):
        with mock.patch.object(discord_post, "post", return_value="999") as post:
            code, out = self.run_main({"DISCORD_WEBHOOK_URL": HOOK})
        self.assertEqual(code, 0)
        webhook, body, thread_id = post.call_args[0]
        self.assertIsNone(thread_id)
        self.assertEqual(webhook, HOOK)
        embed = body["embeds"][0]
        self.assertEqual(embed["title"], "Aegis: Forever Instance Journal v0.27.0")
        self.assertTrue(embed["url"].endswith("Aegis_Forever_Instance_Journal/releases/tag/v0.27.0"))
        self.assertIn("New: boss portraits", embed["description"])
        self.assertEqual(body["allowed_mentions"], {"parse": []}, "an @everyone in the notes pings no one")
        self.assertNotIn("content", body)
        self.assertEqual(embed["thumbnail"], {"url": discord_post.LOGO_URL})
        self.assertEqual(body["avatar_url"], discord_post.LOGO_URL)
        self.assertTrue(discord_post.LOGO_URL.endswith("/Aegis_Forever_Instance_Journal/main/.github/discord-logo.png"))
        self.assertTrue(os.path.exists(os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
                                                    ".github", "discord-logo.png")), "the logo is in the repository")
        with open(os.path.join(self.folder, "discord.txt"), encoding="utf-8") as handle:
            self.assertIn("999", handle.read())
        self.assertNotIn(HOOK, out, "the address is never printed")

    def test_a_later_push_edits_the_versions_post(self):
        with open(os.path.join(self.folder, "discord.txt"), "w", encoding="utf-8") as handle:
            handle.write("Posted to Discord as message 1234567890123.\n")
        with mock.patch.object(discord_post, "post") as post:
            code, out = self.run_main({"DISCORD_WEBHOOK_URL": HOOK, "DISCORD_THREAD_ID": "555",
                                       "DISCORD_PING_ROLE_ID": "4242"}, "--edit")
        self.assertEqual(code, 0)
        webhook, body, thread_id, message_id = post.call_args[0]
        self.assertEqual((webhook, thread_id, message_id), (HOOK, "555", "1234567890123"))
        self.assertIn("New: boss portraits", body["embeds"][0]["description"])
        for key in ("username", "avatar_url", "content"):
            self.assertNotIn(key, body, "an edit keeps the poster and pings no one again")
        self.assertEqual(body["allowed_mentions"], {"parse": []})
        self.assertIn("Updated v0.27.0", out)
        self.assertNotIn(HOOK, out)

    def test_an_edit_needs_the_post(self):
        with mock.patch.object(discord_post, "post") as post:
            with self.assertRaises(SystemExit):
                self.run_main({"DISCORD_WEBHOOK_URL": HOOK}, "--edit")
        post.assert_not_called()

    def test_the_opening_message_is_rewritten_from_the_file(self):
        with mock.patch.object(discord_post, "post", return_value="555") as post, \
                mock.patch.object(sys, "argv", ["x", "--opening"]), \
                mock.patch.dict(os.environ, {"DISCORD_WEBHOOK_URL": HOOK, "DISCORD_THREAD_ID": "555"}, clear=True), \
                contextlib.redirect_stdout(io.StringIO()) as out:
            self.assertEqual(discord_post.main(), 0)
        webhook, body, thread_id, message_id = post.call_args[0]
        self.assertEqual((thread_id, message_id), ("555", "555"), "the opening message's id is the post's own")
        self.assertTrue(post.call_args[1]["soft"], "a refusal never stops the release")
        with open(discord_post.OPENING_FILE, encoding="utf-8") as handle:
            self.assertEqual(body["content"], handle.read().strip())
        self.assertLessEqual(len(body["content"]), discord_post.OPENING_MAX)
        self.assertEqual(body["allowed_mentions"], {"parse": []})
        self.assertIn("Updated the forum post's opening message", out.getvalue())

    def test_a_refused_opening_edit_lets_the_release_go_on(self):
        with mock.patch.object(discord_post, "post", return_value=None), \
                mock.patch.object(sys, "argv", ["x", "--opening"]), \
                mock.patch.dict(os.environ, {"DISCORD_WEBHOOK_URL": HOOK, "DISCORD_THREAD_ID": "555"}, clear=True), \
                contextlib.redirect_stdout(io.StringIO()) as out:
            self.assertEqual(discord_post.main(), 0)
        self.assertIn("only the webhook that made the post", out.getvalue())

    def test_a_post_that_moved_is_posted_afresh(self):
        with open(os.path.join(self.folder, "discord.txt"), "w", encoding="utf-8") as handle:
            handle.write("Posted to Discord as message 1234567890123.\n")
        with mock.patch.object(discord_post, "post", side_effect=[None, "2222222222222"]) as post:
            code, out = self.run_main({"DISCORD_WEBHOOK_URL": HOOK, "DISCORD_THREAD_ID": "555"}, "--edit")
        self.assertEqual(code, 0)
        self.assertEqual(post.call_count, 2)
        self.assertEqual(post.call_args_list[1][0][2], "555", "posted afresh in the current post")
        with open(os.path.join(self.folder, "discord.txt"), encoding="utf-8") as handle:
            self.assertIn("2222222222222", handle.read(), "the new message's id replaces the old")

    def test_a_new_forum_post_says_its_id(self):
        with mock.patch.object(discord_post, "post", return_value="7777777777777") as post, \
                mock.patch.object(sys, "argv", ["x", "--new-post"]), \
                mock.patch.dict(os.environ, {"DISCORD_WEBHOOK_URL": HOOK}, clear=True), \
                contextlib.redirect_stdout(io.StringIO()) as out:
            self.assertEqual(discord_post.main(), 0)
        webhook, body = post.call_args[0][:2]
        self.assertEqual(len(post.call_args[0]), 2, "a new post goes to the forum, not into a thread")
        self.assertEqual(body["thread_name"], "Aegis: Forever Instance Journal")
        with open(discord_post.OPENING_FILE, encoding="utf-8") as handle:
            self.assertEqual(body["content"], handle.read().strip())
        self.assertEqual(body["allowed_mentions"], {"parse": []})
        self.assertIn("DISCORD_THREAD_ID variable to 7777777777777", out.getvalue())
        self.assertNotIn(HOOK, out.getvalue())

    def test_into_the_addons_forum_post(self):
        with mock.patch.object(discord_post, "post", return_value="1") as post:
            self.run_main({"DISCORD_WEBHOOK_URL": HOOK, "DISCORD_THREAD_ID": "555"})
        self.assertEqual(post.call_args[0][2], "555")
        with self.assertRaises(SystemExit):
            self.run_main({"DISCORD_WEBHOOK_URL": HOOK, "DISCORD_THREAD_ID": "post 555"})

    def test_a_role_is_mentioned_only_when_named(self):
        body = discord_post.message("0.3.0", "notes", role_id="4242")
        self.assertEqual(body["content"], "<@&4242>")
        self.assertEqual(body["allowed_mentions"], {"parse": [], "roles": ["4242"]})

    def test_long_notes_are_cut_with_a_link(self):
        body = discord_post.message("0.3.0", "x" * 6000)
        text = body["embeds"][0]["description"]
        self.assertLessEqual(len(text), discord_post.DESCRIPTION_MAX)
        self.assertIn("Read the rest", text)

    def test_a_wrong_address_is_refused_without_showing_it(self):
        secret = "https://example.com/not-a-hook/secret-part"
        with mock.patch.object(discord_post, "post") as post:
            with self.assertRaises(SystemExit) as stop:
                self.run_main({"DISCORD_WEBHOOK_URL": secret})
        post.assert_not_called()
        self.assertNotIn("secret-part", str(stop.exception.code))

    def test_the_request_has_the_user_agent_discord_wants(self):
        seen = {}

        class Answer(io.BytesIO):
            def __enter__(self):
                return self

            def __exit__(self, *exc):
                return False

        def fake_urlopen(req, timeout):
            seen["url"], seen["agent"] = req.full_url, req.get_header("User-agent")
            seen["body"] = json.loads(req.data.decode("utf-8"))
            return Answer(b'{"id": "77"}')

        with mock.patch("urllib.request.urlopen", fake_urlopen):
            self.assertEqual(discord_post.post(HOOK, {"embeds": []}), "77")
        self.assertTrue(seen["url"].endswith("?wait=true"))
        with mock.patch("urllib.request.urlopen", fake_urlopen):
            discord_post.post(HOOK, {"embeds": []}, "555")
        self.assertTrue(seen["url"].endswith("?wait=true&thread_id=555"))
        self.assertTrue(seen["agent"].startswith("DiscordBot ("))

        def fake_patch(req, timeout):
            seen["url"], seen["method"] = req.full_url, req.get_method()
            return Answer(b'{"id": "88"}')

        with mock.patch("urllib.request.urlopen", fake_patch):
            discord_post.post(HOOK, {"embeds": []}, "555", "88")
        self.assertEqual(seen["method"], "PATCH")
        self.assertTrue(seen["url"].endswith("/messages/88?thread_id=555"), "an edit goes to the message, in its thread")


if __name__ == "__main__":
    unittest.main(verbosity=1)
