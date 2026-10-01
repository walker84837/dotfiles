#!/usr/bin/env node
/**
 * Sync wallpaper between the awww cache and rofi/wallpaper-effects.
 * Reads the current wallpaper for the focused monitor from awww's cache,
 * symlinks it for rofi access and copies it for wallpaper effects use.
 *
 * awww versions its cache as ~/.cache/awww/<version>/<monitor>, so the
 * version directory is globbed rather than hardcoded; an awww upgrade
 * moves the cache without needing this script changed.
 */
import { readFileSync, existsSync, copyFileSync, readdirSync } from 'fs';
import { join } from 'path';
import { execSync } from 'child_process';
import { getFocusedMonitor } from './utils/hypr.js';

const HOME = process.env.HOME;

const cacheRoot = join(HOME, '.cache/awww');
const rofiWallpaper = join(HOME, '.config/rofi/.current_wallpaper');
const effectsCurrent = join(HOME, '.config/hypr/wallpaper_effects/.wallpaper_current');

/**
 * Resolve the per-monitor cache file inside awww's versioned cache dir.
 * awww nests files as <version>/<monitor>, so try each version dir and
 * return the first that holds a file for this monitor.
 * @param {string} monitor - Output name, e.g. 'DP-1'.
 * @returns {string | null} Absolute path to the cache file, or null.
 */
function findCacheFile(monitor) {
  if (!existsSync(cacheRoot)) return null;

  for (const version of readdirSync(cacheRoot)) {
    const candidate = join(cacheRoot, version, monitor);
    if (existsSync(candidate)) return candidate;
  }
  return null;
}

/**
 * Extract the wallpaper path from an awww cache file.
 * The file is NUL-separated metadata, not a bare path:
 *   \0crop:center \0Lanczos3 \0/path/to/wallpaper.jpg
 * The path is always the final field; earlier fields are crop/filter hints
 * and vary by how the image was set, so splitting on NUL and taking the last
 * entry is stable across those variations.
 * @param {string} cacheFile - Absolute path to the cache file.
 * @returns {string} The wallpaper path.
 */
function readWallpaperPath(cacheFile) {
  const fields = readFileSync(cacheFile, 'utf8').split('\0');
  return fields[fields.length - 1].trim();
}

function main() {
  try {
    execSync('awww query', { stdio: 'ignore' });
  } catch {
    console.log('awww not running, skipping');
    return;
  }

  const monitor = getFocusedMonitor();
  const cacheFile = findCacheFile(monitor);

  if (!cacheFile) {
    console.log(`No cache file for monitor ${monitor}`);
    return;
  }

  const wallpaperPath = readWallpaperPath(cacheFile);

  try {
    execSync(`ln -sf "${wallpaperPath}" "${rofiWallpaper}"`);
    copyFileSync(wallpaperPath, effectsCurrent);
    execSync(`wallust run "${wallpaperPath}" -s`, { stdio: 'ignore' });
  } catch (err) {
    console.error('Failed to update wallpaper:', err.message);
  }
}

main();
