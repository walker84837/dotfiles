import { basename } from 'path';

/**
 * Parse null-separated output (from `find -print0`) into an array of filenames.
 * @param {string} output - Raw output from a null-separated command.
 * @returns {string[]} Array of filenames (basenames only).
 */
export function parseNullSeparated(output) {
  return output.split('\0').filter(Boolean).map(p => basename(p));
}

/**
 * Parse null-separated output into full paths (last path component only).
 * @param {string} output - Raw output from a null-separated command.
 * @returns {string[]} Array of full paths.
 */
export function parseNullSeparatedFull(output) {
  return output.split('\0').filter(Boolean);
}
