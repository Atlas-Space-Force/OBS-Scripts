# Advanced OBS Studio Automation Suite

This repository provides a powerful set of tools to dynamically manage and organize your scenes within OBS Studio, significantly enhancing automation and control for streamers and content creators. It features a robust Lua script for advanced scene management and a modified web-based OBS Control Dock for seamless VDO.Ninja integration.

---

## OBS Lua Script - Advanced Scene Layouts for OBS Studio: Grid, Reaction and Highlight

Overview:

This robust Lua script offers a powerful set of tools to dynamically manage and organize your scenes within OBS Studio. It integrates four core functionalities: Grid Layout, Reaction Layout and Highlight Layout, all with multi-language support.

### Key Features:

Dynamic Grid Layout:
* Organize multiple video sources into a customizable grid pattern. Ideal for multi-participant presentations, team gaming streams, or varied content displays.
* Flexible Settings: Adjust spacing, margins, and X/Y offsets to tailor the grid to your scene design.
* Split-Screen Mode: A special mode for exactly two cameras optimizes the view, perfect for interviews or paired reactions.

Immersive Reaction Layout:
* Create engaging reaction layouts with your cameras intelligently positioned relative to the main content (window capture).
* Camera Distribution: Choose between having all reaction cameras on a single side or symmetrically distributed on both sides of the screen.
* Custom Positioning: Control spacing and X/Y offsets for a perfect fit with your content window.
* Adjust Spacing: Change the spacing between cameras and the main content at will.
* Dedicated Prefixes: Define prefixes for your reaction camera sources (Reaction Prefix) and for the main content window capture (Reaction Window Prefix), ensuring the script identifies and positions elements correctly.

Dynamic Highlight Layout (NEW):
* This layout is designed to highlight a specific source while other reaction cameras are positioned relative to it.
* Same appeance as the Reaction Layout, but the highlighted camera is placed where the screen capture would be.
* Flexible Settings: Define prefixes for the lateral cameras (Highlight Camera Prefix) and for the main source (Highlight Main Source Prefix).
* Camera Distribution: Option to distribute highlight cameras on both sides of the screen.
* Fine Adjustments: Control spacing and X/Y offsets for optimal positioning.

Comprehensive Multi-Language Support:
* The script provides support for several languages for a more accessible and intuitive user experience.
* Available Languages: English, Portuguese, Spanish, Chinese (中文), Russian (Русский), Japanese (日本語), and German (Deutsch).

Integrated User Interface:
* All settings are easily accessible and adjustable via a dedicated user interface in the OBS script properties panel.
* Intuitive Controls: Enable/disable each feature independently and adjust parameters with sliders and checkboxes.
* Real-time Updates: Changes to settings are applied dynamically, allowing you to see the results instantly.
This script is a powerful solution for streamers, content creators, and anyone seeking greater control and automation over their scene organization in OBS Studio.

### Technical Details:

* Recommended Integration: This functionality works best with tools that offer automatic creation, deletion and dynamically renaming of sources with specific prefixes for highlighting, such as VDO.Ninja in conjunction with the modified OBS Controller page by Morse: [VDO.Ninja OBS Controller](https://morsethecode.github.io/vdo.ninja/obs). The original version of the controller can be found here, in case it interests you: [Original VDO.Ninja OBS Controller](https://vdo.ninja/obs)

* When no screen share link or highlighted user is found, the Screen Share and the Highlight layouts fall back to the Grid Layout, so it's recommended that you configured spacing, margins and choose between normal or split screen mode in the Grid Section, even if you don't plan to use it.
* The script is configured to treat your OBS and the sources as if they're 1920x1080, but you can always change the resolution in the script (line 301). Just remember to always give the browser sources the same base resolution defined in Settings > Video.
* Sources are cropped, scaled, and positioned dynamically to ensure they fit perfectly into the layout.
* Inactive sources are hidden from view but can be re-enabled at any time.

### Requirements:

* OBS Studio (version 27.0 or higher recommended).
* Lua scripting support (included with OBS Studio).
* [Click here](https://obsproject.com/forum/resources/advanced-scene-layouts-grid-reaction-and-highlight.2152/) to go to the OBS Forum page.

---

## VDO.Ninja OBS Control Dock (Modified)

This page provides a modified version of the OBS Control Dock originally developed by **Steve Seguin**, the creator of VDO.Ninja. This version aims to offer enhanced control and integration specifically for VDO.Ninja users managing their OBS Studio scenes.

**Original OBS Controller by Steve Seguin:**
You can find the original OBS Controller page and more information about Steve Seguin's work with VDO.Ninja here: [VDO.Ninja OBS Controller](https://vdo.ninja/obs)
**[Steve Seguin's GitHub](https://github.com/steveseguin)**

### How It Works

This modified VDO.Ninja OBS Control Dock allows for streamlined management of VDO.Ninja sources within your OBS Studio scenes. It leverages the OBS WebSocket plugin to communicate with OBS Studio, enabling dynamic actions directly from your browser.

The page is designed to work in conjunction with the `Advanced Scene Layouts: Grid, Reaction and Highlight` script. When used together, this controller can facilitate automated source naming and organization.

### Key Features (Includes Additions!)

* **VDO.Ninja Room Integration:** Connect to your VDO.Ninja room and manage participants.
* **Dynamic Source Creation/Removal:** Automatically add and remove VDO.Ninja video/audio sources in your specified OBS scenes.
* **Source Sizing and Positioning:** While the page itself provides some controls, it's particularly powerful when combined with OBS scripts that handle complex layouts.
* **🆕 Screen Share Integration:** Dedicated features for managing and switching VDO.Ninja screen share sources within your OBS scenes, providing more refined control over shared content. (This feature is an inclusion not present in the original OBS Controller by Steve Seguin).
* **🆕 Highlight Source Management:** Enhanced capabilities to designate and control a "highlighted" VDO.Ninja source, which is especially useful when paired with advanced OBS scripts that dynamically adjust layouts based on specific source prefixes. (This feature is an inclusion not present in the original OBS Controller by Steve Seguin).

### Integration with `Advanced Scene Layouts`

This modified OBS Controller is particularly effective when used with OBS Lua scripts that process source names for dynamic layouts. For instance, if you're using a script like the `Advanced Scene Layouts` (which includes Grid, Reaction, and Highlight Layouts), you can leverage this controller, as it automatically creates your VDO.Ninja sources with specific prefixes.

---

Feel free to explore and integrate this tool into your VDO.Ninja and OBS Studio workflow for a more automated and efficient streaming experience.
