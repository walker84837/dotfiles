#!/usr/bin/env node
import { execSync, spawn } from 'child_process';
import { join } from 'path';
import { readFileSync, writeFileSync, copyFileSync } from 'fs';
import { getFocusedMonitor } from './utils/hypr.js';
import { refresh } from './utils/script.js';
import {
    scriptsDir,
    swayncImages,
    wallpaperEffectsCurrent,
    wallpaperEffectsModified,
    rofiWallpaperEffectConfig,
} from './utils/paths.js';

const SWWW_PARAMS = '--transition-fps 60 --transition-type wipe --transition-duration 2';

const effects = new Map([
    ['Black & White', 'magick $1 -colorspace gray -sigmoidal-contrast 10,40% $2'],
    ['Blurred', 'magick $1 -blur 0x5 $2'],
    ['Solarize', 'magick $1 -solarize 80% $2'],
    ['Sepia Tone', 'magick $1 -sepia-tone 65% $2'],
    ['Negate', 'magick $1 -negate $2'],
    ['Charcoal', 'magick $1 -charcoal 0x5 $2'],
    ['Edge Detect', 'magick $1 -edge 1 $2'],
    ['Emboss', 'magick $1 -emboss 0x5 $2'],
    ['Sharpen', 'magick $1 -sharpen 0x5 $2'],
    ['Oil Paint', 'magick $1 -paint 4 $2'],
    ['Vignette', 'magick $1 -vignette 0x5 $2'],
    ['Posterize', 'magick $1 -posterize 4 $2'],
    ['Polaroid', 'magick $1 -polaroid 0 $2'],
]);

async function applyEffect(cmd) {
    return new Promise((resolve, reject) => {
        const shellCmd = cmd.replace('$1', wallpaperEffectsCurrent).replace('$2', wallpaperEffectsModified);
        const child = spawn('bash', ['-c', shellCmd]);
        child.on('close', (code) => (code === 0 ? resolve() : reject(new Error(`magick exit ${code}`))));
    });
}

function rofiMenu(prompt, options) {
    const input = options.join('\n');
    return execSync(`echo -e "${input}" | rofi -i -dmenu -config ${rofiWallpaperEffectConfig} -p "${prompt}"`, { encoding: 'utf8', shell: '/bin/bash' }).trim();
}

async function noEffects(monitor) {
    spawn('swww', ['img', '-o', monitor, wallpaperEffectsCurrent, ...SWWW_PARAMS.split(' ')], { detached: true, stdio: 'ignore' });
    await new Promise(r => setTimeout(r, 2100));

    spawn('wallust', ['run', wallpaperEffectsCurrent, '-s'], { detached: true, stdio: 'ignore' });
    await new Promise(r => setTimeout(r, 100));

    await refresh();

    execSync(`notify-send -u low -i "${join(swayncImages, 'bell.png')}" "No wallpaper effects"`, { stdio: 'ignore' });
    copyFileSync(wallpaperEffectsCurrent, wallpaperEffectsModified);
}

async function main() {
    try {
        execSync('pkill rofi', { stdio: 'ignore' });
        process.exit(0);
    } catch {}

    const options = ['No Effects', ...effects.keys()];
    const choice = rofiMenu('Wallpaper Effect', options);

    if (!choice) process.exit(0);

    const monitor = getFocusedMonitor();

    if (choice === 'No Effects') {
        await noEffects(monitor);
        return;
    }

    const cmd = effects.get(choice);
    if (!cmd) {
        console.error('Effect not recognized:', choice);
        return;
    }

    execSync(`notify-send -u normal -i "${join(swayncImages, 'bell.png')}" "Applying ${choice} effects"`, { stdio: 'ignore' });
    await applyEffect(cmd);
    await new Promise(r => setTimeout(r, 1000));

    spawn('swww', ['img', '-o', monitor, wallpaperEffectsModified, ...SWWW_PARAMS.split(' ')], { detached: true, stdio: 'ignore' });
    await new Promise(r => setTimeout(r, 2100));
    spawn('wallust', ['run', wallpaperEffectsModified, '-s'], { detached: true, stdio: 'ignore' });
    await new Promise(r => setTimeout(r, 100));
    await refresh();
    execSync(`notify-send -u low -i "${join(swayncImages, 'bell.png')}" "${choice} effects applied"`, { stdio: 'ignore' });
}

main().catch(console.error);
