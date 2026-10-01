#!/usr/bin/env node
"use strict";

function pad(n) {
    return String(n).padStart(2, "0");
}

// Parse: "Tue Apr 14 05:47:05 2026 +0200"
/**
 * Converts an asctime string into an UTC Unix timestamp.
 * @param {string} str The string to parse
 * @returns The corresponding Unix timestamp (in UTC)
 */
function parseAsctime(str) {
    const re = /^(?:\w{3})\s+(\w{3})\s+(\d{1,2})\s+(\d{2}):(\d{2}):(\d{2})\s+(\d{4})\s+([+-]\d{4})$/;
    const m = str.trim().match(re);
    if (!m) throw new Error("Invalid date format");

    const [, mon, day, hh, mm, ss, year, offset] = m;

    const months = {
        Jan: 0, Feb: 1, Mar: 2, Apr: 3, May: 4, Jun: 5,
        Jul: 6, Aug: 7, Sep: 8, Oct: 9, Nov: 10, Dec: 11,
    };

    const month = months[mon];
    if (month === undefined) throw new Error("Invalid month");

    const sign = offset[0] === "-" ? -1 : 1;
    const offHours = parseInt(offset.slice(1, 3), 10);
    const offMins = parseInt(offset.slice(3, 5), 10);
    const offsetMinutes = sign * (offHours * 60 + offMins);

    const utcMillis = Date.UTC(
        Number(year),
        month,
        Number(day),
        Number(hh),
        Number(mm),
        Number(ss)
    );

    return Math.floor((utcMillis - offsetMinutes * 60 * 1000) / 1000);
}

// Format Unix -> asctime in local TZ
function formatAsctime(unixSec) {
    const d = new Date(unixSec * 1000);

    const days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    const mons = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

    function pad(n) {
        return String(n).padStart(2, "0");
    }

    // Local components
    const year = d.getFullYear();
    const month = d.getMonth();
    const day = d.getDate();
    const hh = d.getHours();
    const mm = d.getMinutes();
    const ss = d.getSeconds();

    // Key part: compute timezone offset in minutes
    const offsetMin = -d.getTimezoneOffset();
    // getTimezoneOffset() = minutes behind UTC (so we invert it)

    const sign = offsetMin >= 0 ? "+" : "-";
    const abs = Math.abs(offsetMin);

    const offHH = pad(Math.floor(abs / 60));
    const offMM = pad(abs % 60);

    const offset = `${sign}${offHH}${offMM}`;

    return (
        `${days[d.getDay()]} ` +
        `${mons[month]} ` +
        `${pad(day)} ` +
        `${pad(hh)}:` +
        `${pad(mm)}:` +
        `${pad(ss)} ` +
        `${year} ` +
        `${offset}`
    );
}

function printHelp() {
    console.log(`
Usage:
  node timeconv.js asctime "<date string>"
  node timeconv.js unix <timestamp>

Examples:
  node timeconv.js asctime "Tue Apr 14 05:47:05 2026 +0200"
  node timeconv.js unix 1776131225
`);
}

const [, , cmd, input] = process.argv;

try {
    if (!cmd || !input) {
        printHelp();
        process.exit(1);
    }

    if (cmd === "asctime") {
        const unix = parseAsctime(input);
        console.log(unix);
    } else if (cmd === "unix") {
        const unix = Number(input);
        if (!Number.isFinite(unix)) throw new Error("Invalid unix timestamp");
        console.log(formatAsctime(unix));
    } else {
        printHelp();
        process.exit(1);
    }
} catch (err) {
    console.error("Error:", err.message);
    process.exit(1);
}
