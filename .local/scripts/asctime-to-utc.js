#!/usr/bin/env node

function asctimeToUtcIso8601(input) {
    if (!input || typeof input !== 'string') {
        throw new Error('Input must be a non-empty string');
    }

    const date = new Date(input.trim());

    if (isNaN(date.getTime())) {
        throw new Error(`Could not parse date string: "${input}"`);
    }

    // Format as ISO 8601 with second precision (no milliseconds)
    return date.toISOString().replace(/\.\d+Z$/, 'Z');
}

// Main script logic
if (require.main === module) {
    // Join all command-line arguments (skip node and script path)
    const args = process.argv.slice(2);

    if (args.length === 0) {
        console.error('Usage: node asctime-to-utc.js "<asctime string>"');
        console.error('Example: node asctime-to-utc.js "Fri Dec 05 15:30:00 2025 +0000"');
        process.exit(1);
    }

    const input = args.join(' ');

    try {
        const result = asctimeToUtcIso8601(input);
        console.log(result);
    } catch (err) {
        console.error('Error:', err.message);
        process.exit(1);
    }
}

// Export for testing or modular use
module.exports = asctimeToUtcIso8601;
