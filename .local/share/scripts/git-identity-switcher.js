#!/usr/bin/env node

import { spawnSync } from 'child_process';

const profiles = {};

/**
 * Runs a git config command to get, set, or unset a config value.
 * Operates on the **local** repo config by default (as `git config` does).
 *
 * @param {string} type - Config key suffix (e.g., 'name', 'email', 'signingkey')
 * @param {string | null} value - Value to set; if null, unset the key
 * @param {boolean} get - If true, return current value instead of setting/unsetting
 * @returns {string | null} - Current value if `get === true`, else null
 */
function runGitConfig(type, value, get) {
    const fullKey = `user.${type}`;
    let args;

    if (get) {
        args = ['config', fullKey];
    } else if (value == null) {
        args = ['config', '--unset', fullKey];
    } else {
        args = ['config', fullKey, value];
    }

    const result = spawnSync('git', args, {
        encoding: 'utf8',
        stdio: get ? ['ignore', 'pipe', 'pipe'] : ['ignore', 'ignore', 'pipe']
    });

    if (result.error) {
        if (result.error.code === 'ENOENT') {
            throw new Error('Git is not installed or not in PATH');
        }
        throw result.error;
    }

    if (result.status !== 0) {
        const stderr = (result.stderr || '').trim();
        // When getting a missing config, git exits with code 1 and no output, and that's fine
        if (get && result.status === 1 && !stderr) {
            return '';
        }
        throw new Error(stderr || `Git command failed with exit code ${result.status}`);
    }

    if (get) {
        return (result.stdout || '').trim();
    }

    return null;
}

function getCurrentConfig() {
    try {
        const email = runGitConfig('email', null, true);
        const name = runGitConfig('name', null, true);
        const signingkey = runGitConfig('signingkey', null, true);
        return { email, name, signingkey };
    } catch (error) {
        throw new Error('Not in a Git repository or Git config not accessible');
    }
}

function showCurrentIdentity() {
    try {
        const current = getCurrentConfig();
        console.log('Current Git Identity:');
        console.log(`  Name:    ${current.name || 'Not set (falls back to global)'}`);
        console.log(`  Email:   ${current.email || 'Not set (falls back to global)'}`);
        console.log(`  GPG Key: ${current.signingkey || 'Not set (falls back to global)'}`);
    } catch (error) {
        console.error('\nError reading current identity:');
        console.error(error.message);
        process.exit(1);
    }
}

function change_git_identity(profileName) {
    if (!profiles[profileName]) {
        console.error(`Profile "${profileName}" not found.`);
        console.error('Available profiles:', Object.keys(profiles).join(', '));
        process.exit(1);
    }

    const profile = profiles[profileName];

    try {
        runGitConfig('name', profile.username, false);
        runGitConfig('email', profile.email, false);
        runGitConfig('signingkey', profile.gpgKey, false);

        console.log(`\nSuccessfully switched to profile: ${profileName}`);
        console.log(`  Name:    ${profile.username}`);
        console.log(`  Email:   ${profile.email}`);
        console.log(`  GPG Key: ${profile.gpgKey}\n`);
    } catch (error) {
        console.error('\nError updating git config:');
        console.error(error.message);
        process.exit(1);
    }
}

function restoreGitIdentity() {
    try {
        // Unset local config keys
        runGitConfig('name', null, false);
        runGitConfig('email', null, false);
        runGitConfig('signingkey', null, false);

        console.log('\nLocal Git identity cleared (restored to global/default config).');
        showCurrentIdentity();
    } catch (error) {
        // Silently ignore "key does not exist" errors during unset
        if (error.message.includes('cannot unset non-existent key')) {
            console.log('\n No local Git identity was set to restore.');
            showCurrentIdentity();
        } else {
            console.error('\nError during restore:');
            console.error(error.message);
            process.exit(1);
        }
    }
}

function usage() {
    console.log('Usage:');
    console.log('  Show current identity:  node git-switch-profile.js --show');
    console.log('  List available profiles: node git-switch-profile.js --list');
    console.log('  Switch to a profile:    node git-switch-profile.js <profile-name>');
    console.log('  Restore (unset local):  node git-switch-profile.js --restore');
    console.log('\nAvailable profiles:', Object.keys(profiles).join(', '));
}

function main() {
    // Handle CLI arguments
    const cmd = process.argv[2];

    switch (cmd) {
        case '--show':
            showCurrentIdentity();
            break;
        case '--list':
            console.log('Available profiles:', Object.keys(profiles).join(', '));
            break;
        case '--restore':
            restoreGitIdentity();
            break;
        default:
            if (cmd && !cmd.startsWith('--')) {
                change_git_identity(cmd);
            } else {
                usage();
                process.exit(1);
            }
    }
}

main();
