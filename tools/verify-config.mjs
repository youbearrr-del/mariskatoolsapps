import fs from 'node:fs';
const original = fs.readFileSync('www/index.html', 'utf8');
const native = fs.readFileSync('android/app/src/main/assets/public/index.html', 'utf8');
const pwa = fs.readFileSync('pwa/index.html', 'utf8');
const fields = ['apiKey', 'projectId', 'appId', 'SB_URL', 'SB_KEY'];
for (const field of fields) {
  const find = text => text.match(new RegExp(`${field}\\s*[:=]\\s*['\"]([^'\"]+)`))?.[1];
  if (!find(original) || find(original) !== find(native) || find(original) !== find(pwa)) throw new Error(`Configuration mismatch: ${field}`);
  console.log(`${field}: identical in source, Android bundle, and PWA`);
}
