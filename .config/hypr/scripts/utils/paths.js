import { join } from 'path';
import { homedir } from 'os';

export const HOME = homedir();

// Core paths
export const scriptsDir = join(HOME, '.config/hypr/scripts');
export const configDir = join(HOME, '.config/hypr');

// External config paths
export const swayncImages = join(HOME, '.config/swaync/images');
export const swayncIcons = join(HOME, '.config/swaync/icons');
export const rofiDir = join(HOME, '.config/rofi');
export const waybarDir = join(HOME, '.config/waybar');
export const waybarStyleDir = join(HOME, '.config/waybar/style');
export const waybarStyleLink = join(HOME, '.config/waybar/style.css');
export const dunstDir = join(HOME, '.config/dunst');
export const dunstrc = join(HOME, '.config/dunst/dunstrc');
export const kittyConf = join(HOME, '.config/kitty/kitty.conf');
export const wallustDir = join(HOME, '.config/wallust');
export const wallustConfig = join(HOME, '.config/wallust/wallust.toml');
export const wallustRofi = join(HOME, '.config/wallust/templates/colors-rofi.rasi');
export const qt5ctConf = join(HOME, '.config/qt5ct/qt5ct.conf');
export const qt6ctConf = join(HOME, '.config/qt6ct/qt6ct.conf');
export const qt5ctColorsDir = join(HOME, '.config/qt5ct/colors');
export const qt6ctColorsDir = join(HOME, '.config/qt6ct/colors');
export const themesDir = join(HOME, '.themes');
export const iconsDir = join(HOME, '.icons');

// Wallpaper paths
export const wallpaperEffectsDir = join(HOME, '.config/hypr/wallpaper_effects');
export const wallpaperEffectsCurrent = join(wallpaperEffectsDir, '.wallpaper_current');
export const wallpaperEffectsModified = join(wallpaperEffectsDir, '.wallpaper_modified');
export const wallpaperCacheDir = join(HOME, '.cache/swww');
export const rofiCurrentWallpaper = join(HOME, '.config/rofi/.current_wallpaper');

// Music and media
export const musicDir = join(HOME, 'Music');

// Rofi configs
export const rofiBeatsConfig = join(HOME, '.config/rofi/config-rofi-Beats.rasi');
export const rofiBeatsMenuConfig = join(HOME, '.config/rofi/config-rofi-Beats-menu.rasi');
export const rofiWallpaperEffectConfig = join(HOME, '.config/rofi/config-wallpaper-effect.rasi');

// Theme mode file
export const themeModeFile = join(HOME, '.cache/.theme_mode');

// Wallpaper directories
export const wallpapersDir = join(HOME, 'Pictures/wallpapers');
export const darkWallpapers = join(HOME, 'Pictures/wallpapers/Dynamic-Wallpapers/Dark');
export const lightWallpapers = join(HOME, 'Pictures/wallpapers/Dynamic-Wallpapers/Light');