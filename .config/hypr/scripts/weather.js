#!/usr/bin/env node
import { readFileSync, writeFileSync, statSync, mkdirSync } from 'fs';
import { join } from 'path';

const HOME = process.env.HOME;
const cacheDir = join(HOME, '.cache/rbn');
const cachefile = 'weather';

const city = 'Busan';

const weatherIcons = {
    'clear': '󰖙',
    'sunny': '󰖙',
    'partly cloudy': '󰖕',
    'cloudy': '',
    'overcast': '',
    'fog': '',
    'freezing fog': '',
    'mist': '󰼳',
    'rain': '󰼳',
    'light rain': '󰼳',
    'light rain shower': '󰼳',
    'patchy rain possible': '󰼳',
    'patchy light drizzle': '󰼳',
    'light drizzle': '󰼳',
    'patchy light rain': '󰼳',
    'moderate rain': '󰼳',
    'heavy rain': '',
    'torrential rain shower': '',
    'thundery outbreaks possible': '',
    'patchy snow possible': '󰼴',
    'light snow': '󰙿',
    'moderate snow': '󰙿',
    'heavy snow': '',
    'blizzard': '',
    'blowing snow': '󰙿',
    'sleet': '󰼴',
};

function getIcon(condition) {
    const c = condition.toLowerCase();
    for (const [key, icon] of Object.entries(weatherIcons)) {
        if (c.includes(key)) return icon;
    }
    return '󰖙';
}

function cacheAge(file) {
    return Math.floor((Date.now() / 1000) - statSync(file).mtimeMs);
}

try {
    mkdirSync(cacheDir, { recursive: true });
} catch { }

const cachePath = join(cacheDir, cachefile);

try {
    if (!statSync(cachePath).size || cacheAge(cachePath) > 1740) {
        const url = `https://wttr.in/${city}?format=j1`;
        const res = await fetch(url);
        const data = await res.json();

        const current = data.current_condition[0];
        const temp = current.temp_C + '°C';
        const condition = current.lang_en[0].value;
        const icon = getIcon(condition);

        const cached = `${icon}  ${temp}\n${condition}`;
        writeFileSync(cachePath, cached);

        const out = {
            text: `${icon}  ${temp}`,
            alt: condition,
            tooltip: `${condition}: ${temp}`,
        };
        console.log(JSON.stringify(out));
        writeFileSync(join(HOME, '.cache/.weather_cache'), cached);
    } else {
        const cached = readFileSync(cachePath, 'utf8').trim();
        const [iconTemp, ...rest] = cached.split('\n');
        const [_, temp] = iconTemp.split('  ');
        const condition = rest.join(' ');

        console.log(JSON.stringify({
            text: iconTemp,
            alt: condition,
            tooltip: `${condition}: ${temp}`,
        }));
    }
} catch (err) {
    console.error(err);
    process.exit(1);
}
