# Uji sinkronisasi backend yang sama

Semua salinan memakai konfigurasi Firebase `mariskaratnadewi` dan Supabase `ornfolrnaxozmiujzrcq` yang identik dengan HTML sumber. Jalankan pengujian berikut setelah APK dipasang dan PWA dideploy.

1. Di panel moderator, aktifkan maintenance lalu perbarui `system/config`. Pastikan APK dan website menampilkan maintenance. Nonaktifkan lagi.
2. Ubah announcement dan banner versi di panel; pastikan keduanya muncul tanpa memuat ulang penuh pada APK dan website.
3. Ubah tiap flag `tugas`, `ruang`, `catatan`, dan `foto_chat` menjadi `false` satu per satu. Pastikan tab/tombol terkait hilang di APK; kembalikan ke `true` sesudahnya.
4. Pada akun uji, set `banned`, `muted`, dan `expiresAt`; verifikasi perilaku yang sama di APK dan website. Set `forceLogoutAt` dan pastikan sesi APK keluar.
5. Dari APK, kirim pesan dan buat cerita/presence. Pastikan panel dan website melihatnya. Buat pesan dari website/panel dan pastikan APK menerimanya real-time.

Catat tanggal, akun uji, dan hasil setiap langkah. Pengujian ini tidak dapat dijalankan otomatis di sini karena tidak tersedia APK/emulator yang berjalan maupun akses ke panel moderator Anda.
