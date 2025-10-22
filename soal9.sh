#!/bin/bash
# ==========================================================
# Script Deployment: NGINX Static Server (Node Lindon)
# Domain: static.k35.com | lindon.k35.com
# ==========================================================

set -euo pipefail  # Hentikan jika error / variabel tidak terdefinisi
IFS=$'\n\t'

echo "=== [1/6] Memperbarui repository & memasang NGINX ==="
apt update -y
apt install -y nginx

echo "=== [2/6] Menulis konfigurasi Virtual Host ==="
cat << 'NGINXCONF' > /etc/nginx/sites-available/static.k35.com
server {
    listen 80;
    server_name static.k35.com lindon.k35.com;

    root /var/www/static;
    index index.html;

    # Halaman utama
    location / {
        try_files $uri $uri/ =404;
    }

    # Folder arsip (autoindex aktif)
    location /annals/ {
        alias /var/www/static/annals/;
        autoindex on;
        autoindex_exact_size off;
        autoindex_localtime on;
    }
}
NGINXCONF

echo "=== [3/6] Mengaktifkan konfigurasi & menonaktifkan default ==="
ln -sf /etc/nginx/sites-available/static.k35.com /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

echo "=== [4/6] Membuat direktori dan konten statis ==="
install -d /var/www/static/annals

cat << 'HTML' > /var/www/static/index.html
<h1>Welcome to Lindon - Static Archives</h1>
<p>Explore the annals of Beleriand below.</p>
HTML

cat << 'TXT' > /var/www/static/annals/archive1.txt
Archive 1: The Fall of Beleriand
TXT

cat << 'TXT' > /var/www/static/annals/archive2.txt
Archive 2: The Ships of Cirdan
TXT

cat << 'TXT' > /var/www/static/annals/archive3.txt
Archive 3: The Grey Havens
TXT

chown -R www-data:www-data /var/www/static

echo "=== [5/6] Validasi konfigurasi NGINX ==="
nginx -t

echo "=== [6/6] Memuat ulang service NGINX ==="
systemctl restart nginx
systemctl status nginx --no-pager | head -n 5

echo
echo "=== [UJI CEPAT] Akses lokal endpoint ==="
{
    echo ">> Menguji root:"
    curl -s http://static.k35.com | head -n 5
    echo
    echo ">> Menguji direktori annals:"
    curl -s http://static.k35.com/annals/ | head -n 10
} || echo "Gagal mengakses endpoint."

echo
echo "=== ✅ Deployment NGINX Static Server selesai ==="
