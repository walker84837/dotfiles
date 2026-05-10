#!/usr/bin/env node
/**
 * Sync wallpaper between swww cache and rofi/wallpaper-effects.
 * Reads the current wallpaper for the focused monitor from swww's cache,
 * symlinks it for rofi access and copies it for wallpaper effects use.
 */
import { readFileSync, writeFileSync, existsSync, copyFileSync } from 'fs';
import { join } from 'path';
import { execSync } from 'child_process';
import { getFocusedMonitor } from './utils/hypr.js';

const HOME = process.env.HOME;

const cacheDir = join(HOME, '.cache/swww');
const rofiWallpaper = join(HOME, '.config/rofi/.current_wallpaper');
const effectsCurrent = join(HOME, '.config/hypr/wallpaper_effects/.wallpaper_current');

function main() {
  try {
    execSync('swww query', { stdio: 'ignore' });
  } catch {
    console.log('swww not running, skipping');
    return;
  }

  const monitor = getFocusedMonitor();
  const cacheFile = join(cacheDir, monitor);

  if (!existsSync(cacheFile)) {
    console.log(`No cache file for monitor ${monitor}`);
    return;
  }

  const wallpaperPath = readFileSync(cacheFile, 'utf8').trim();

  try {
    execSync(`ln -sf "${wallpaperPath}" "${rofiWallpaper}"`);
    copyFileSync(wallpaperPath, effectsCurrent);
    execSync(`wallust run "${wallpaperPath}" -s`, { stdio: 'ignore' });
  } catch (err) {
    console.error('Failed to update wallpaper:', err.message);
  }
}

main();