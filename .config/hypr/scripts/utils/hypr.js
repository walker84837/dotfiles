import { execSync } from 'child_process';

/**
 * Get the currently focused monitor name.
 * @returns {string}
 */
export function getFocusedMonitor() {
    const output = execSync('hyprctl monitors', { encoding: 'utf8' });
    let name;
    for (const line of output.split('\n')) {
        if (line.startsWith('Monitor')) name = line.split(' ')[1];
        if (line.includes('focused: yes')) return name;
    }
    return name;
}

/**
 * Get total number of monitors.
 * @returns {number}
 */
export function getMonitorCount() {
    const output = execSync('hyprctl monitors', { encoding: 'utf8' });
    return (output.match(/^Monitor/gm) || []).length;
}

/**
 * Execute multiple Hyprland keyword commands in a single hyprctl call.
 * @param {string[]} commands - Array of "keyword value" strings, e.g. ["animations:enabled 0", "decoration:blur:passes 0"]
 */
export function batchCommands(commands) {
    const batch = commands.map(cmd => `keyword ${cmd}`).join('; ');
    execSync(`hyprctl --batch "${batch}"`, { stdio: 'ignore' });
}
