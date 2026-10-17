# CurseForge

The text for the journal's CurseForge project page. CurseForge's upload API sends only files,
so the description is pasted by hand: on the project, **Description → Edit**, switch the
editor to **Markdown**, and paste the block below over the old text. Its pictures are the
project's own gallery images, on CurseForge's server: a new one goes up to the gallery first, and
its address goes in the text. Uploads themselves are automatic: each new `## Version` merged to `main` goes to CurseForge once
(`.github/workflows/release.yml`, `Tools/curseforge_upload.py`).

## Project description

```markdown
## Aegis: Forever Instance Journal

![WoW: Forever, Interface 16001](https://img.shields.io/badge/WoW%3A%20Forever-Interface%2016001-c79c2e?style=flat-square&labelColor=555) [![Discord: join us](https://img.shields.io/badge/Discord-join%20us-5865F2?style=flat-square&logo=discord&logoColor=white)](https://discord.gg/Hr66t25vE7) [![GitHub: changelog](https://img.shields.io/badge/GitHub-changelog-24292f?style=flat-square&logo=github&logoColor=white)](https://github.com/Torchlite-bit/Aegis_Forever_Instance_Journal/blob/main/CHANGELOG.md)

**Retail's instance journal and dungeon maps, brought to WoW: Forever.** Press **Shift+J**.

*🚧 A work in progress: Forever's own dungeons, raids and reputations fill in as they open and as players record them.*

![The Dungeons tab](https://media.forgecdn.net/attachments/2059/698/screenshot-2026-10-15-142215-png.png)

### What's in it

- 📖 **35 dungeons and 3 raids coming soon**: bosses, loot, abilities, 3D models and quests
- 🗺️ **Dungeon maps** with boss pins; the bosses you've killed are crossed out
- 🧭 **World map**: every dungeon door, flight masters, boats and zeppelins, quest marks, **zone level ranges** coloured for your level, and **unexplored areas** on request
- 🛡️ **Reputation**: every faction's rewards by standing. Captured quartermasters give exact prices; the rest show the game's own list, marked unconfirmed
- 🎯 **Gear Finder**: the best upgrade for every slot in the dungeons near your level (or your pick of its top 3), and the dungeon with the most of them. Scored for your spec, with **stat weights you can change** or bring in from **Pawn**, on the journal's tab or the character panel's
- 🔍 **Search** across everything
- 🇷🇺 **In Russian** on a Russian game client, translated by **Staree4ok**
- 🌍 **In German, French and Chinese** (Simplified and Traditional) too, drafted and awaiting native speakers' corrections
- 🔴 **Record tab** and **Log Reader**: help fill in Forever's journal

![A boss's abilities](https://media.forgecdn.net/attachments/2059/704/screenshot-2026-10-15-142526-png.png)
![City of Dalaran's map, with the map legend](https://media.forgecdn.net/attachments/2059/700/screenshot-2026-10-15-142325-png.png)
![The Reputation tab](https://media.forgecdn.net/attachments/2059/707/screenshot-2026-10-15-142604-png.png)
![The Gear Finder](https://media.forgecdn.net/attachments/2062/932/screenshot-2026-10-16-090853-png.png)
![Stat weights on the character panel](https://media.forgecdn.net/attachments/2062/931/screenshot-2026-10-16-090815-png.png)
![Show unexplored areas, in the world map's filter menu](https://media.forgecdn.net/attachments/2059/729/screenshot-2026-10-15-143503-png.png)

### Help fill in the journal

- **Dungeons:** leave **Record automatically in dungeons** ticked and run one. Press **Copy** on the Record tab, paste it into the [Log Reader](https://torchlite-bit.github.io/Aegis_Forever_Instance_Journal/log-reader/) with your combat log to add the bosses' spells, and post the result in our [Discord](https://discord.gg/Hr66t25vE7). The page reads your log in your browser and never uploads it.
- **Quartermasters:** open their shop and press **Capture vendor** on the Reputation tab, then **Copy** and post it the same way.

Your name goes on the contributors list.

### Install

Put the `Aegis_Forever_Instance_Journal` folder in `_classic_beta_\Interface\AddOns`, then restart the game fully.

Forever's dungeon maps are by **Santiago Reyes**: his own reinterpretations, not official World of Warcraft art. Support his maps on [Patreon](https://www.patreon.com/c/SantiagoReyesMaps) or [Ko-fi](https://ko-fi.com/sr433_20).

💬 [Discord](https://discord.gg/Hr66t25vE7) · 💻 [Source](https://github.com/Torchlite-bit/Aegis_Forever_Instance_Journal) · 📜 [Changelog](https://github.com/Torchlite-bit/Aegis_Forever_Instance_Journal/blob/main/CHANGELOG.md) · 📄 [Credits](https://github.com/Torchlite-bit/Aegis_Forever_Instance_Journal/blob/main/CREDITS.md)

*Not made or endorsed by Blizzard Entertainment.*
```
