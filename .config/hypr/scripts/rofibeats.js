#!/usr/bin/env node
import { execSync, spawn } from 'child_process';
import { join } from 'path';
import { readdirSync } from 'fs';
import { musicDir, swayncIcons, rofiBeatsConfig, rofiBeatsMenuConfig } from './utils/paths.js';

const onlineMusic = new Map([
    ['Lofi Girl Radio ☕️🎶', 'https://play.streamafrica.net/lofiradio'],
    ['FM - Easy Rock 96.3 📻🎶', 'https://radio-stations-philippines.com/easy-rock'],
    ['FM - WRock - CEBU 96.3 📻🎶', 'https://onlineradio.ph/126-96-3-wrock.html'],
    ['YT - Wish 107.5 YT Pinoy HipHop 🎻🎶', 'https://youtube.com/playlist?list=PLkrzfEDjeYJnmgMYwCKid4XIFqUKBVWEs&si=vahW_noh4UDJ5d37'],
    ['YT - Top Youtube Music 2023 ☕️🎶', 'https://youtube.com/playlist?list=PLDIoUOhQQPlXr63I_vwF9GD8sAKh77dWU&si=y7qNeEVFNgA-XxKy'],
    ['YT - Wish 107.5 YT Wishclusives ☕️🎶', 'https://youtube.com/playlist?list=PLkrzfEDjeYJn5B22H9HOWP3Kxxs-DkPSM&si=d_Ld2OKhGvpH48WO'],
    ['Chillhop Radio ☕️🎶', 'http://stream.zeno.fm/fyn8eh3h5f8uv'],
    ['FM - Fresh Philippines ☕️🎶', 'https://onlineradio.ph/553-fresh-fm.html'],
    ['YT - Relaxing Music ☕️🎶', 'https://youtube.com/playlist?list=PLMIbmfP_9vb8BCxRoraJpoo4q1yMFg4CE'],
    ['YT - Youtube Remix 📻🎶', 'https://youtube.com/playlist?list=PLeqTkIUlrZXlSNn3tcXAa-zbo95j0iN-0'],
    ['YT - Korean Drama OST 📻🎶', 'https://youtube.com/playlist?list=PLUge_o9AIFp4HuA-A3e3ZqENh63LuRRlQ'],
    ['YT - AfroBeatz 2024 🎧', 'https://www.youtube.com/watch?v=7uB-Eh9XVZQ'],
]);

function notify(title, body = '') {
    const icon = join(swayncIcons, 'music.png');
    execSync(`notify-send -u normal -i "${icon}" "${title}" "${body}"`, { stdio: 'ignore' });
}

function stopNotification() {
    const icon = join(swayncIcons, 'music.png');
    execSync(`notify-send -u low -i "${icon}" "Music stopped"`, { stdio: 'ignore' });
}

function collectLocalMusic() {
    const extensions = ['.mp3', '.flac', '.wav', '.ogg', '.mp4'];
    const localMusic = [];
    const filenames = [];

    function walk(dir) {
        try {
            for (const entry of readdirSync(dir, { withFileTypes: true })) {
                const full = join(dir, entry.name);
                if (entry.isDirectory()) walk(full);
                else if (extensions.some(ext => entry.name.toLowerCase().endsWith(ext))) {
                    localMusic.push(full);
                    filenames.push(entry.name);
                }
            }
        } catch {}
    }

    walk(musicDir);
    return { localMusic, filenames };
}

function rofiMenu(prompt, options) {
    const input = options.join('\n');
    return execSync(`echo -e "${input}" | rofi -i -dmenu -config "${rofiBeatsMenuConfig}" -p "${prompt}"`, { encoding: 'utf8', shell: '/bin/bash' }).trim();
}

function rofiMusicMenu(prompt) {
    return rofiMenu(prompt, ['Play from Online Stations', 'Play from Music Folder', 'Shuffle Play from Music Folder']);
}

function playOnlineMusic() {
    const choice = rofiMenu('Online Music', [...onlineMusic.keys()]);
    if (!choice) process.exit(1);

    const link = onlineMusic.get(choice);
    notify('Playing:', choice);
    spawn('mpv', ['--shuffle', '--vid=no', link], { detached: true, stdio: 'ignore' });
}

function playLocalMusic() {
    const { localMusic, filenames } = collectLocalMusic();
    if (!filenames.length) {
        notify('No music found', musicDir);
        return;
    }

    const choice = rofiMenu('Local Music', filenames);
    if (!choice) process.exit(1);

    const idx = filenames.indexOf(choice);
    if (idx === -1) return;

    notify('Playing:', choice);
    spawn('mpv', ['--playlist-start', String(idx), '--loop-playlist', '--vid=no', ...localMusic], { detached: true, stdio: 'ignore' });
}

function shuffleLocalMusic() {
    notify('Shuffle local music', '');
    spawn('mpv', ['--shuffle', '--loop-playlist', '--vid=no', musicDir], { detached: true, stdio: 'ignore' });
}

function main() {
    try {
        execSync('pkill mpv');
        stopNotification();
    } catch {
        const choice = rofiMusicMenu('Select music source');
        switch (choice) {
            case 'Play from Music Folder': playLocalMusic(); break;
            case 'Play from Online Stations': playOnlineMusic(); break;
            case 'Shuffle Play from Music Folder': shuffleLocalMusic(); break;
        }
    }
}

main();
