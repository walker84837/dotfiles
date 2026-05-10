import { exec } from 'child_process';

export function send(title, body = '', opts = {}) {
    const {
        urgency = 'low',
        icon,
        expire = '',
        hint = [],
        appId = 'hyprland-scripts',
    } = opts;

    const args = ['-a', appId, '-u', urgency];
    if (expire) args.push('-t', expire);
    if (icon) args.push('-i', icon);
    hint.forEach(h => args.push('-h', h));
    args.push(title);
    if (body) args.push(body);

    exec(`notify-send ${args.map(a => `"${a}"`).join(' ')}`);
}

export function sendUrgent(title, body = '', icon = '') {
    send(title, body, { urgency: 'normal', icon });
}

export function sendLow(title, body = '', icon = '') {
    send(title, body, { urgency: 'low', icon });
}
