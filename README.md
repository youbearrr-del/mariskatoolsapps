# Ruang Kerja — Android (Capacitor) dan PWA

Proyek ini membungkus `www/index.html` tanpa mengubah konfigurasi Firebase atau Supabase. `panel_moderator.html` tidak disertakan. Konfigurasi yang dibundel telah diperiksa identik untuk `apiKey`, `projectId`, `appId`, `SB_URL`, dan `SB_KEY`.

## APK dari GitHub Actions

1. Buat repository GitHub, unggah seluruh folder ini, lalu push. Workflow berjalan pada setiap push atau dapat dijalankan dari tab **Actions**.
2. Buka workflow **Build Ruang Kerja APK**, pilih run yang selesai, lalu unduh artifact **ruang-kerja-apk**.
3. Salin `app-debug.apk` ke Android dan buka. Saat diminta, izinkan instalasi dari sumber tidak dikenal untuk aplikasi pengelola berkas/browser yang digunakan.

Workflow memasang Node 20, Temurin 17, Android SDK, menjalankan `npm ci`, `npx cap sync android`, dan `./gradlew assembleDebug`. Artifact debug tidak perlu keystore. Job `release-signed` hanya berjalan saat dipicu manual dan `KEYSTORE_BASE64` tersedia; ia membaca `KEYSTORE_PASSWORD`, `KEY_ALIAS`, dan `KEY_PASSWORD` dari GitHub Secrets. Jangan commit keystore ataupun password.

## Build ulang lokal

Pasang JDK 17 dan Android command-line tools, lalu instal `platform-tools`, `platforms;android-36`, serta build-tools yang sesuai. Set `JAVA_HOME` dan `ANDROID_HOME`, lalu jalankan:

```powershell
npm ci
npx cap sync android
cd android
.\gradlew.bat assembleDebug
```

APK berada di `android/app/build/outputs/apk/debug/app-debug.apk`. `versionCode` adalah `1`, `versionName` dan `APP_VERSION` HTML adalah `1.0.0`. Untuk menaikkan versi, ubah keduanya bersama-sama, tingkatkan `versionCode`, jalankan sync, lalu build ulang.

## PWA iPhone dan Android

Folder `pwa/` memuat manifest, ikon, dan service worker. Service worker hanya men-cache shell same-origin dan tidak mencegat request Firestore/Supabase. Deploy dengan Firebase CLI:

```powershell
npm install -g firebase-tools
firebase login
firebase use mariskaratnadewi
firebase deploy --only hosting
```

Di iPhone: buka URL hasil deploy dengan Safari, tekan **Bagikan**, lalu **Tambah ke Layar Utama**.

## Backend, Firebase, dan batasan WebView

Di Firebase Console, aktifkan Anonymous provider. Tambahkan `localhost` serta domain Firebase Hosting/domain website Anda ke **Authentication → Settings → Authorized domains**. Pastikan Firestore Rules terbaru Anda telah dideploy dan memberi panel moderator akses yang diperlukan untuk `system/config`; tanpa itu command panel tidak dapat dibaca aplikasi.

Login Google menggunakan popup/redirect dari HTML sumber. Google OAuth tidak didukung di Android WebView; login anonim dan alur non-popup tetap tersedia. Implementasi Google native perlu persetujuan dan setup terpisah: `@capacitor-firebase/authentication`, SHA-1 aplikasi, serta `google-services.json` dari Firebase Console. Ini belum diterapkan agar konfigurasi dan alur login tidak berubah diam-diam.

Kamera/mikrofon meminta izin runtime melalui WebView dan manifest menyatakan keduanya opsional. Pemilih `<input type=file>` ditangani Capacitor WebView untuk galeri/kamera. Tombol Back menutup dialog aplikasi yang terbuka sebelum kembali ke riwayat; silakan uji di perangkat.

## Mode bundle dan live

`capacitor.config.json` adalah default **bundle lokal**: kode/tampilan baru membutuhkan build APK lagi, tetapi semua data tetap realtime. Untuk mode **live**, salin `capacitor.live.config.json` ke `capacitor.config.json`, ganti placeholder URL dengan URL Hosting HTTPS, jalankan `npx cap sync android`, lalu build. Mode live memperbarui kode web tanpa APK baru tetapi membutuhkan internet dan membuat ketersediaan aplikasi bergantung pada hosting.

Untuk panel versi, samakan kolom versi dengan `APP_VERSION`/`versionName` saat merilis. Isi `updateUrl` dengan tautan unduh APK dan aktifkan `forceUpdate` hanya jika versi lama memang harus diblokir.

## Uji sinkronisasi

Ikuti [SYNC_TEST.md](SYNC_TEST.md) untuk maintenance, banner, feature flag, status akun, force logout, presence, pesan, dan cerita dua arah.
