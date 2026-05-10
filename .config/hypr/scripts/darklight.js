#!/usr/bin/env node
/**
 * Dark/Light theme switcher for Hyprland.
 * Coordinates theme changes across: wallust, dunst, kitty, Qt, GTK, rofi, waybar.
 */
import { readFileSync, writeFileSync, existsSync } from 'fs';
import { execSync } from 'child_process';
import { join, basename } from 'path';
import {
  HOME,
  scriptsDir,
  swayncImages,
  dunstrc,
  kittyConf,
  wallustConfig,
  wallustRofi,
  themeModeFile,
  darkWallpapers,
  lightWallpapers,
  qt5ctConf,
  qt6ctConf,
  qt5ctColorsDir,
  qt6ctColorsDir,
  themesDir,
  iconsDir,
  waybarStyleDir,
  waybarStyleLink,
} from './utils/paths.js';
import { parseNullSeparated, parseNullSeparatedFull } from './utils/fs.js';

/** @type {{ [key: string]: { palette: string, kvantum: string, qt5ct: string, qt6ct: string } }} */
const themeConfig = {
  Dark: { palette: 'dark16', kvantum: 'Catppuccin-Mocha', qt5ct: 'Catppuccin-Mocha', qt6ct: 'Catppuccin-Mocha' },
  Light: { palette: 'light16', kvantum: 'Catppuccin-Latte', qt5ct: 'Catppuccin-Latte', qt6ct: 'Catppuccin-Latte' },
};

// Dunst notification colors by theme
const dunstColors = {
  Dark: {
    lowBg: '#222222', lowFg: '#888888',
    normBg: '#285577', normFg: '#ffffff',
    critBg: '#900000', critFg: '#ffffff', critFrame: '#ff0000',
    frame: '#aaaaaa',
  },
  Light: {
    lowBg: '#f0f0f0', lowFg: '#555555',
    normBg: '#ffffff', normFg: '#222222',
    critBg: '#ff4444', critFg: '#ffffff', critFrame: '#cc0000',
    frame: '#888888',
  },
};

const kittyColors = {
  Dark: { fg: '#dddddd', bg: '#000000' },
  Light: { fg: '#000000', bg: '#dddddd' },
};

const rofiBackground = {
  Dark: 'rgba(0,0,0,0.7)',
  Light: 'rgba(255,255,255,0.9)',
};

// Line-based config regex patterns — matches the entire line after the property name
const lineConfig = {
  foreground: /^foreground .*/,
  background: /^background .*/,
  cursor: /^cursor .*/,
  palette: /^palette = .*/,
  colorSchemePath: /^color_scheme_path=.*/,
  iconTheme: /^icon_theme=.*/,
};

// Wallpaper directory glob pattern: *.jpg or *.png
const wallpaperExtensions = '\\( -iname "*.jpg" -o -iname "*.png" \\)';

/**
 * Read a file and return its contents as a string.
 * @param {string} file - Absolute path to file.
 * @returns {string}
 */
function read(file) {
  return readFileSync(file, 'utf8');
}

/**
 * Write content to a file (overwrites existing).
 * @param {string} file - Absolute path to file.
 * @param {string} content - New file content.
 */
function write(file, content) {
  writeFileSync(file, content);
}

/**
 * Replace the first match of a regex in a file with the given replacement string.
 * @param {string} file - Absolute path to file.
 * @param {RegExp} regex - Pattern to search for (first match only).
 * @param {string} replacement - Replacement string.
 */
function replaceInFile(file, regex, replacement) {
  write(file, read(file).replace(regex, replacement));
}

/**
 * Replace a specific line (0-indexed) in a file.
 * @param {string} file - Absolute path to file.
 * @param {number} lineIndex - Line number to replace.
 * @param {string} newLine - New line content.
 */
function replaceLine(file, lineIndex, newLine) {
  const lines = read(file).split('\n');
  lines[lineIndex] = newLine;
  write(file, lines.join('\n'));
}

/**
 * Get the currently saved theme mode ('Dark' or 'Light').
 * Defaults to 'Dark' if no file exists.
 * @returns {string}
 */
function getCurrentMode() {
  try {
    return read(themeModeFile).trim();
  } catch {
    return 'Dark';
  }
}

/**
 * Determine the next theme mode (toggles from current).
 * @returns {string}
 */
function getNextMode() {
  return getCurrentMode() === 'Light' ? 'Dark' : 'Light';
}

/**
 * Update wallust palette in wallust.toml config.
 * @param {string} mode - 'Dark' or 'Light'.
 */
function setWallustPalette(mode) {
  const palette = themeConfig[mode].palette;
  replaceInFile(wallustConfig, lineConfig.palette, `palette = "${palette}"`);
}

/**
 * Randomly select a waybar style CSS file matching the current theme
 * and symlink it to the active style.css path.
 * @param {string} mode - 'Dark' or 'Light'.
 */
function pickRandomWaybarStyle(mode) {
  const regex = new RegExp(`.*\\\\[${mode}\\\\].*\\.css$`);

  try {
    const output = execSync(`find "${waybarStyleDir}" -maxdepth 1 -type f -regex "${regex.source}"`, { encoding: 'utf8' });
    const files = output.trim().split('\n').filter(Boolean);
    if (files.length) {
      const chosen = files[Math.floor(Math.random() * files.length)];
      execSync(`ln -sf "${chosen}" "${waybarStyleLink}"`);
    }
  } catch {}
}

/**
 * Update dunst notification colors for all urgency levels.
 * Handles the INI-style dunstrc with [urgency_low], [urgency_normal],
 * [urgency_critical] sections and the [global] frame_color.
 * @param {string} mode - 'Dark' or 'Light'.
 */
function setDunstColors(mode) {
  const c = dunstColors[mode];

  // Maps each INI section to its editable keys and which color value to use.
  // Key = config key name, Value = which property on dunstColors[mode] to read.
  const sectionMap = {
    '[urgency_low]':      { background: 'lowBg',  foreground: 'lowFg' },
    '[urgency_normal]':   { background: 'normBg', foreground: 'normFg' },
    '[urgency_critical]': { background: 'critBg', foreground: 'critFg', frame_color: 'critFrame' },
    '[global]':           { frame_color: 'frame' },
  };

  const lines = read(dunstrc).split('\n');
  let currentSection = '';

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i].trim();

    // Track current INI section
    if (line.startsWith('[') && line.endsWith(']')) {
      currentSection = line;
      continue;
    }

    const keyMap = sectionMap[currentSection];
    if (!keyMap) continue;

    // Check each known key in this section — first match wins
    for (const [key, valueKey] of Object.entries(keyMap)) {
      if (line.startsWith(key)) {
        lines[i] = `    ${key} = "${c[valueKey]}"`;
        break;
      }
    }
  }

  write(dunstrc, lines.join('\n'));
}

/**
 * Update kitty terminal foreground, background, and cursor colors.
 * @param {string} mode - 'Dark' or 'Light'.
 */
function setKittyColors(mode) {
  const c = kittyColors[mode];
  replaceInFile(kittyConf, lineConfig.foreground, `foreground ${c.fg}`);
  replaceInFile(kittyConf, lineConfig.background, `background ${c.bg}`);
  replaceInFile(kittyConf, lineConfig.cursor, `cursor ${c.fg}`);
}

/**
 * Update Qt5ct and Qt6ct color scheme paths and set Kvantum theme.
 * @param {string} mode - 'Dark' or 'Light'.
 */
function setQtColors(mode) {
  const t = themeConfig[mode];
  const qt5ctPath = join(qt5ctColorsDir, `${t.qt5ct}.conf`);
  const qt6ctPath = join(qt6ctColorsDir, `${t.qt6ct}.conf`);

  replaceInFile(qt5ctConf, lineConfig.colorSchemePath, `color_scheme_path=${qt5ctPath}`);
  replaceInFile(qt6ctConf, lineConfig.colorSchemePath, `color_scheme_path=${qt6ctPath}`);
  execSync(`kvantummanager --set ${t.kvantum}`);
}

/**
 * Update rofi background color (line 24 in wallust template).
 * @param {string} mode - 'Dark' or 'Light'.
 */
function setRofiBackground(mode) {
  replaceLine(wallustRofi, 23, `background: ${rofiBackground[mode]};`);
}

/**
 * Randomly select and apply a GTK theme and icon theme matching the current mode.
 * Also updates Qt icon themes and configures flatpak overrides if applicable.
 * @param {string} mode - 'Dark' or 'Light'.
 */
function setGtkTheme(mode) {
  const keyword = mode === 'Dark' ? '*Dark*' : '*Light*';

  // GTK themes
  try {
    const themesOut = execSync(`find "${themesDir}" -maxdepth 1 -type d -iname "${keyword}" -print0`, { encoding: 'utf8' });
    const themeDirs = parseNullSeparated(themesOut);

    if (themeDirs.length) {
      const chosen = themeDirs[Math.floor(Math.random() * themeDirs.length)];
      execSync(`gsettings set org.gnome.desktop.interface gtk-theme "${chosen}"`);
      if (existsSync('/usr/bin/flatpak')) {
        execSync(`flatpak --user override --filesystem=${themesDir}`);
        execSync(`sleep 0.5 && flatpak --user override --env=GTK_THEME="${chosen}"`);
      }
    }
  } catch {}

  // Icon themes
  try {
    const iconsOut = execSync(`find "${iconsDir}" -maxdepth 1 -type d -iname "${keyword}" -print0`, { encoding: 'utf8' });
    const iconDirs = parseNullSeparated(iconsOut);

    if (iconDirs.length) {
      const chosen = iconDirs[Math.floor(Math.random() * iconDirs.length)];
      execSync(`gsettings set org.gnome.desktop.interface icon-theme "${chosen}"`);
      replaceInFile(qt5ctConf, lineConfig.iconTheme, `icon_theme=${chosen}`);
      replaceInFile(qt6ctConf, lineConfig.iconTheme, `icon_theme=${chosen}`);
      if (existsSync('/usr/bin/flatpak')) {
        execSync(`flatpak --user override --filesystem=${iconsDir}`);
        execSync(`sleep 0.5 && flatpak --user override --env=ICON_THEME="${chosen}"`);
      }
    }
  } catch {}
}

/**
 * Pick a random wallpaper image file from the directory matching the current mode.
 * @param {string} mode - 'Dark' or 'Light'.
 * @returns {string|null} Absolute path to image file, or null if none found.
 */
function pickRandomWallpaper(mode) {
  const dir = mode === 'Dark' ? darkWallpapers : lightWallpapers;
  try {
    const output = execSync(`find "${dir}" -type f ${wallpaperExtensions} -print0`, { encoding: 'utf8' });
    const files = parseNullSeparatedFull(output);
    return files.length ? files[Math.floor(Math.random() * files.length)] : null;
  } catch {
    return null;
  }
}

/**
 * Send a low-urgency notification with the bell icon.
 * @param {string} title - Notification title.
 * @param {string} [body=''] - Optional body text.
 */
function notify(title, body = '') {
  execSync(`notify-send -u low -i "${join(swayncImages, 'bell.png')}" "${title}" "${body}"`, { stdio: 'ignore' });
}

/** Sleep for a number of milliseconds.
 * @param {number} ms
 * @returns {Promise<void>}
 */
function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

/**
 * Main: toggle theme, apply all system changes, refresh wallpaper and waybar.
 */
async function main() {
  execSync('pkill swaybg || true');
  execSync('swww query || swww-daemon');

  const mode = getNextMode();

  setWallustPalette(mode);
  pickRandomWaybarStyle(mode);
  setDunstColors(mode);
  setKittyColors(mode);

  const wallpaper = pickRandomWallpaper(mode);
  if (wallpaper) {
    execSync(`swww img "${wallpaper}" --transition-bezier .43,1.19,1,.4 --transition-fps 60 --transition-type grow --transition-pos 0.925,0.977 --transition-duration 2`);
  }

  setQtColors(mode);
  setRofiBackground(mode);
  setGtkTheme(mode);

  write(themeModeFile, mode);
  notify(`Switching to ${mode} mode`);

  await sleep(500);
  execSync(`${scriptsDir}/wallust-swww.js`);
  await sleep(1000);
  execSync(`${scriptsDir}/Refresh.sh`);

  execSync(`notify-send -u normal -i "${join(swayncImages, 'bell.png')}" "Themes in ${mode} Mode"`, { stdio: 'ignore' });
}

main().catch(console.error);
