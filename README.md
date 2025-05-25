# Advanced OBS Studio Automation Suite

> For an interactive guide with visuals: [view online](https://morsethecode.github.io/OBS-Scripts/guide.html))

---

## 📖 Index

- [Overview](#overview)
- [VDO.Ninja OBS Control Dock (Modified)](#vdoninja-obs-control-dock-modified)
  - [Key Features](#key-features-of-the-control-dock)
  - [Installation and Setup](#installation-and-setup-for-control-dock)
- [Advanced Scene Layouts Lua Script](#advanced-scene-layouts-lua-script)
  - [Key Features](#key-features-of-the-lua-script)
  - [Installation and Configuration](#installation-and-configuration-for-lua-script)
- [Integrated Workflow](#integrated-workflow)
  - [How They Integrate](#how-they-integrate)
  - [Example Workflow: Using the Highlight Feature](#example-workflow-using-the-highlight-feature)
- [Requirements](#requirements)
- [Credits & Original Resources](#credits--original-resources)

---

## Overview

This repository provides a suite of tools for advanced automation in OBS Studio, focusing on dynamic scene layouts and seamless integration with VDO.Ninja. It includes:

- A robust **Lua script** for dynamic scene management (Grid, Reaction, and Highlight layouts).
- A **modified VDO.Ninja OBS Control Dock** for streamlined source management and deep OBS integration.
- Multi-language support and an intuitive user interface.

---

## VDO.Ninja OBS Control Dock (Modified)

This is a customized version of the OBS Control Dock by **Steve Seguin** (creator of VDO.Ninja). It functions as a web-based interface for managing VDO.Ninja sources in OBS Studio via the OBS WebSocket plugin.

### Key Features of the Control Dock

- **VDO.Ninja Room Integration:** Connect to your VDO.Ninja room and manage participants.
- **Dynamic Source Management:** Automatically add, remove, and rename VDO.Ninja video sources in your chosen OBS scenes.
- **Screen Share Integration:** Dedicated features for handling and switching VDO.Ninja screen share sources in OBS.
- **Highlight Source Management:** Designate and control a "highlighted" VDO.Ninja source, perfect for dynamic layouts.
- **Stream Mapping:** Advanced rules for routing specific streams to scenes or layouts.

### Installation and Setup for Control Dock

1. **Access the Page:**
   - **Local Option:** Download `obs.html` and open it locally.
   - **Hosted Option:** Use [https://morsethecode.github.io/OBS-Scripts/obs](https://morsethecode.github.io/OBS-Scripts/obs).

2. **Add as an OBS Dock:**
   - In OBS: Go to **Docks → Custom Browser Docks...**.
   - Choose a Dock Name (e.g., "VDO.Ninja Control").
   - Enter the local file path or the hosted URL.
   - Click **Apply**, then **Close**.

3. **Configure the Dock:**
   - **OBS WebSocket:** Enter URL (default: `ws://localhost:4455`) and password. Click Connect.
   - **Prefixes:** Set Camera, Reaction, and Highlight prefixes (must match those in the Lua script).
   - **VDO.Ninja:** Enter your room name and password (if any), then connect.
   - **Target Scenes:** Select main, highlight, and screen share scenes as needed.

---

## Advanced Scene Layouts Lua Script

This Lua script adds dynamic scene management and layout automation to OBS Studio. It works best with sources named and managed by the Control Dock.

### Key Features of the Lua Script

- **Dynamic Grid Layout:** Organize multiple video sources in a customizable grid. Supports split-screen for two cameras.
- **Immersive Reaction Layout:** Place reaction cameras relative to a main content window. Choose side/symmetrical camera distribution and custom spacing.
- **Dynamic Highlight Layout:** Feature a specific source ("highlighted" participant) in the main area, with other cameras arranged around it.
- **Multi-Language Support:** UI in English, Portuguese, Spanish, Chinese, Russian, Japanese, and German.
- **Integrated UI:** All settings are available in the OBS script properties panel. Changes apply in real-time.

### Installation and Configuration for Lua Script

1. **Download the Script:** Get `Advanced Scene Layouts.lua` from this repo.
2. **Open OBS Studio:** Start OBS.
3. **Add the Script:**
   - Go to **Tools → Scripts**.
   - Click the **"+"** button and select the `.lua` file.
4. **Configure the Script:**
   - Select the script in the list to show properties.
   - Enable/disable layouts as needed.
   - Assign target scenes for each layout.
   - Set source name prefixes (must match the Control Dock).
   - Adjust spacing, margins, and offsets using sliders.

---

## Integrated Workflow

When used together, the Control Dock and Lua script create a highly automated streaming environment. The Dock manages VDO.Ninja connections and source naming, while the Lua script arranges scenes and applies dynamic layouts.

### How They Integrate

- The Control Dock adds new VDO.Ninja participants to OBS with a **Camera Prefix** (e.g., `VDO_guest1`).
- Using the Highlight feature, the Dock renames a participant's source to the **Highlight Prefix** (e.g., `VDO.Highlight_guest2`) and transitions to the highlight scene.
- The Lua script monitors source names and applies the correct layout based on prefixes.
- Consistent prefix configuration between the Dock and Lua script is essential for automation.

### Example Workflow: Using the Highlight Feature

1. **Configuration:**
   - Set `Camera Prefix` and `Highlight Prefix` in both the Control Dock and Lua script.
   - Assign the highlight scene in both tools.

2. **In Action:**
   - Guests join your VDO.Ninja room and are added to OBS as, e.g., `VDO_guest1`, `VDO_guest2`.
   - Click "Highlight" on a guest in the Control Dock. The source is renamed to `VDO.Highlight_guest2` and the scene transitions.
   - The Lua script detects the prefix and applies the highlight layout.
   - "Unhighlight" reverses the process and returns to grid layout.

---

## Requirements

- OBS Studio (version 27.0 or higher recommended)
- OBS WebSocket plugin (for Control Dock)
- Lua scripting support (included with OBS Studio)
- [VDO.Ninja](https://vdo.ninja/) for browser-based guest video

---

## Credits & Original Resources

- **Control Dock based on work by [Steve Seguin](https://github.com/steveseguin) ([original OBS Controller](https://vdo.ninja/obs)).**
- [OBS Studio](https://obsproject.com/)
- [VDO.Ninja](https://vdo.ninja/)
- [Interactive Guide (guide.html)](./guide.html) ([view online](https://morsethecode.github.io/OBS-Scripts/guide.html))

---

Feel free to explore, use, and adapt these tools to automate and optimize your OBS Studio + VDO.Ninja workflow!
