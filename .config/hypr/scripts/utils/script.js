import { exec, spawn } from 'child_process';
import { scriptsDir } from './paths.js';

export function refresh() {
    return new Promise((resolve, reject) => {
        exec(`${scriptsDir}/Refresh.sh`, (err) => {
            if (err) reject(err);
            else resolve();
        });
    });
}

export function refreshNoWaybar() {
    return new Promise((resolve, reject) => {
        exec(`${scriptsDir}/RefreshNoWaybar.sh`, (err) => {
            if (err) reject(err);
            else resolve();
        });
    });
}

export function wallustAwww(wallpaper) {
    return new Promise((resolve, reject) => {
        const child = spawn(`${scriptsDir}/wallust-awww.js`, [], {
            env: { ...process.env, WALLPAPER: wallpaper },
        });
        child.on('close', (code) => (code === 0 ? resolve() : reject(new Error(`exit ${code}`))));
    });
}