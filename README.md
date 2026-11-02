# open.mp (Windows) di Linux via Wine

Docker image + egg Pterodactyl untuk menjalankan `omp-server.exe` di host Linux memakai Wine.

## Isi repo

```
docker/Dockerfile          image (debian bookworm + wine)
docker/entrypoint.sh       buat prefix wine lalu jalankan STARTUP
.github/workflows/docker.yml   build & push otomatis ke Docker Hub
egg-openmp-wine.json       egg untuk di-import ke panel
```

## Catatan arsitektur

Rilis resmi open.mp untuk Windows saat ini hanya `open.mp-win-x86.zip` (32-bit), jadi prefix Wine default-nya `win32`.
Kalau nanti ada build `x86_64`, ubah variabel `OMP_ASSET` dan `WINEARCH=win64` di panel. Image ini sudah menyertakan `wine64` dan `wine32`, jadi keduanya jalan tanpa build ulang.
Command start tetap `wine omp-server.exe`: `wine` otomatis menjalankan exe 32/64-bit sesuai prefix. `wine64` hanya bisa exe 64-bit.

## Upload ke GitHub

1. Buat repo baru di github.com (misal `openmp-wine`), kosong, tanpa README.
2. Ekstrak zip ini, lalu di folder hasil ekstrak:

   ```bash
   git init
   git add .
   git commit -m "init"
   git branch -M main
   git remote add origin https://github.com/USERNAME/openmp-wine.git
   git push -u origin main
   ```

   Atau tanpa git: di halaman repo klik **Add file > Upload files**, drag semua isi folder (pastikan folder `.github` ikut), lalu **Commit changes**.

## Secret untuk Docker Hub

1. Docker Hub > **Account settings > Personal access tokens > Generate new token**, akses **Read & Write**, salin tokennya.
2. Repo GitHub > **Settings > Secrets and variables > Actions > New repository secret**, buat dua:
   - `DOCKERHUB_USERNAME` = `derrick0930`
   - `DOCKERHUB_TOKEN` = token tadi (bukan password akun)

## Build image

1. Tab **Actions** > workflow `build-image` > **Run workflow** (atau push ulang). Tunggu hijau.
2. Image jadi di `derrick0930/openmp-wine:latest` (repo Docker Hub dibuat otomatis, public by default).

## Pasang egg di Pterodactyl

1. Panel admin > **Nests** > pilih nest > **Import Egg** > upload `egg-openmp-wine.json`. Image sudah diisi `derrick0930/openmp-wine:latest`.
2. Buat server dengan egg ini. Installer akan mengunduh release open.mp dari GitHub, lalu server jalan lewat `wine omp-server.exe`.

## Catatan

- Start pertama lebih lama karena Wine membuat prefix di `/home/container/.wine`.
- Port dan `max_players` diisi otomatis ke `config.json`. Kalau tidak berubah, edit manual di file manager.
- Pola `done` di egg (`started|running|listening`) bisa disesuaikan dengan log open.mp yang kamu pakai, supaya status "Running" muncul pas.
- Plugin/komponen Windows (`.dll`) taruh di `components/` atau `plugins/` seperti biasa.
