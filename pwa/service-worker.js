const CACHE = 'ruang-kerja-shell-v1';
const SHELL = ['/', '/index.html', '/manifest.json', '/icons/icon-192.png', '/icons/icon-512.png'];

self.addEventListener('install', event => {
  event.waitUntil(caches.open(CACHE).then(cache => cache.addAll(SHELL)));
  self.skipWaiting();
});
self.addEventListener('activate', event => event.waitUntil(self.clients.claim()));
self.addEventListener('fetch', event => {
  const url = new URL(event.request.url);
  // Realtime/database requests must always reach the network.
  if (url.hostname.endsWith('firebaseio.com') || url.hostname.endsWith('googleapis.com') ||
      url.hostname.endsWith('supabase.co') || event.request.method !== 'GET') return;
  if (url.origin === self.location.origin) {
    event.respondWith(caches.match(event.request).then(cached => cached || fetch(event.request)));
  }
});
