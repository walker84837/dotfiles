#!/usr/bin/env node
/**
 * Automatically cycle through wallpapers in a given directory.
 * Usage: wallpaper-autochange.js <directory>
 *
 * Selects a random image, applies it via swww, refreshes wallust,
 * then waits INTERVAL seconds before the next change.
 */
import { execSync, spawn } from 'child_process';
import { readdirSync } from 'fs';
import { getFocusedMonitor } from './utils/hypr.js';
import { scriptsDir } from './utils/paths.js';

const INTERVAL = 1000 * 60 * 30; // 30 minutes
const IMAGE_EXTENSIONS = ['.jpg', '.jpeg', '.png'];

function collectImages(dir) {
    const images = [];
    function walk(d) {
        try {
            for (const entry of readdirSync(d, { withFileTypes: true })) {
                const full = join(d, entry.name);
                if (entry.isDirectory()) walk(full);
                else if (IMAGE_EXTENSIONS.some(ext => entry.name.toLowerCase().endsWith(ext))) {
                    images.push(full);
                }
            }
        } catch {}
    }
    walk(dir);
    return images;
}

function setWallpaper(monitor, wallpaper) {
    const env = { ...process.env };
    env.SWWW_TRANSITION_FPS = '60';
    env.SWWW_TRANSITION_TYPE = 'simple';
    spawn('swww', ['img', '-o', monitor, wallpaper], { detached: true, stdio: 'ignore', env });
}

function refresh() {
    execSync(`${scriptsDir}/RefreshNoWaybar.sh`, { stdio: 'ignore' });
}

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

async function main() {
    const dir = process.argv[2];

    if (!dir) {
        console.error('Usage: wallpaper-autochange.js <directory>');
        process.exit(1);
    }

    let images = collectImages(dir);

    while (true) {
        if (!images.length) {
            console.error('No images found in', dir);
            process.exit(1);
        }

        // Shuffle using Fisher-Yates
        for (let i = images.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [images[i], images[j]] = [images[j], images[i]];
        }

        const monitor = getFocusedMonitor();

        for (const img of images) {
            setWallpaper(monitor, img);
            refresh();
            await sleep(INTERVAL);
        }
    }
}

main().catch(console.error);
