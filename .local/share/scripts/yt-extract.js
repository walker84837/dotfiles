#!/usr/bin/env node
// yt-extract.js - tiny wrapper to download music with yt-dlp

import { spawnSync } from 'child_process';
import path from 'path';
import os from 'os';

const argv = process.argv.slice(2);

if (argv.length < 1 || argv[0] === '--help') {
    console.error('Usage: yt-extract.js <url> [format=flac] [outdir=~/Music/YouTube]]');
    process.exit(2);
}

const url = argv[0];
const format = argv[1] || 'flac';
const outdir = argv[2] ? argv[2].replace(/^~(?=$|\/)/, os.homedir()) : path.join(os.homedir(), 'Music', 'YouTube');

const outTemplate = path.join(outdir, '%(uploader)s - %(title)s.%(ext)s');

// Make sure outdir exists (avoid extra deps)
try {
    import('fs').then(fs => fs.mkdirSync(outdir, { recursive: true }));
} catch (e) { /* ignore */ }

const args = [
    '-x', // Extract audio
    '--audio-format', format, // Extract a specific format supported by yt-dlp
    '--audio-quality', '0', // Best quality
    '-o', outTemplate, // Use this template
    url
];

console.log(`Running \`yt-dlp ${args.join(' ')}\``);
const r = spawnSync('yt-dlp', args, { stdio: 'inherit', shell: false });

if (r.error) {
    console.error('Failed to run yt-dlp:', r.error.message);
    process.exit(1);
}
process.exit(r.status ?? 0);
