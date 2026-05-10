import { execSync } from 'child_process';
import { readdirSync } from 'fs';
import { join, basename, extname } from 'path';

/**
 * Show a rofi dmenu and return the user's selected choice, or null if cancelled.
 * @param {string} prompt - The rofi prompt string.
 * @param {string[]} options - Array of option strings to display.
 * @param {string} [rofiConfig] - Optional path to rofi config file.
 * @returns {string|null}
 */
export function rofiMenu(prompt, options, rofiConfig = '') {
    const configArg = rofiConfig ? `-config "${rofiConfig}"` : '';
    const input = options.join('\n');
    try {
        return execSync(
            `echo -e "${input}" | rofi -i -dmenu ${configArg} -p "${prompt}"`,
            { encoding: 'utf8', shell: '/bin/bash' }
        ).trim();
    } catch {
        return null;
    }
}

/**
 * Kill any running rofi process.
 */
export function killRofi() {
    try {
        execSync('pkill rofi', { stdio: 'ignore' });
    } catch {}
}

/**
 * Build a list of options from filenames in a directory, stripping a given extension.
 * @param {string} dir - Directory to scan.
 * @param {string} [extension='.css'] - Extension to strip from filenames.
 * @param {RegExp} [filter] - Optional regex to filter filenames.
 * @returns {string[]}
 */
export function listDir(dir, extension = '.css', filter = null) {
    try {
        const files = readdirSync(dir, { withFileTypes: true })
            .filter(d => d.isFile())
            .map(d => d.name)
            .filter(n => n.endsWith(extension))
            .map(n => basename(n, extension))
            .sort();
        return filter ? files.filter(f => filter.test(f)) : files;
    } catch {
        return [];
    }
}

/**
 * Symlink a target file to a link path.
 * @param {string} target - Full path to target file.
 * @param {string} link - Full path where symlink should be created.
 */
export function symlink(target, link) {
    execSync(`ln -sf "${target}" "${link}"`);
}
