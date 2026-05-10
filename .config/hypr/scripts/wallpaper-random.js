#!/usr/bin/env node
/**
 * Set a random wallpaper from the user's wallpapers directory.
 * Picks a random image and applies it with swww transition, then
 * syncs to rofi and refreshes wallust + waybar.
 */
import { execSync, spawn } from 'child_process';
import { join } from 'path';
import { readdirSync } from 'fs';
import { getFocusedMonitor } from './utils/hypr.js';
import { scriptsDir, wallpapersDir } from './utils/paths.js';

const SWWW_PARAMS = '--transition-fps 60 --transition-type random --transition-duration 1 --transition-bezier .43,1.19,1,.4';

const IMAGE_EXTENSIONS = ['.jpg', '.jpeg', '.png', '.gif'];

function collectWallpapers(dir) {
    const pics = [];
    function walk(d) {
        try {
            for (const entry of readdirSync(d, { withFileTypes: true })) {
                const full = join(d, entry.name);
                if (entry.isDirectory()) walk(full);
                else if (IMAGE_EXTENSIONS.some(ext => entry.name.toLowerCase().endsWith(ext))) {
                    pics.push(full);
                }
            }
        } catch {}
    }
    walk(dir);
    return pics;
}

function setWallpaper(monitor, wallpaper) {
    execSync('swww query || swww-daemon --format xrgb', { stdio: 'ignore' });
    spawn('swww', ['img', '-o', monitor, wallpaper, ...SWWW_PARAMS.split(' ')], { detached: true, stdio: 'ignore' });
}

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

async function main() {
    const pics = collectWallpapers(wallpapersDir);
    if (!pics.length) {
        console.error('No wallpapers found in', wallpapersDir);
        return;
    }

    const randomPic = pics[Math.floor(Math.random() * pics.length)];
    const monitor = getFocusedMonitor();

    setWallpaper(monitor, randomPic);

    execSync(`${scriptsDir}/wallust-swww.js`);
    await sleep(1000);
    execSync(`${scriptsDir}/Refresh.sh`);
}

main().catch(console.error);
