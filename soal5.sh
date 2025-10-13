#!/bin/bash
# --------------------------------------------
# Konfigurasi Zona DNS Utama (k35.com) di Node Terion
# --------------------------------------------
# Jalankan dengan: sudo ./setup_zone_terion.sh
# --------------------------------------------

set -e

echo "=== [BIND CONFIG] Mengatur zona utama k35.com di Terion ==="

# 1️⃣ Pastikan direktori zone tersedia
mkdir -p /etc/bind/zones

# 2️⃣ Tulis file zone k35.com
cat > /etc/bind/zones/k35.com <<'EOF'
$TTL    604800
@       IN      SOA     ns1.k35.com. root.k35.com. (
                        2025100401 ; Serial
                        604800     ; Refresh
                        86400      ; Retry
                        2419200    ; Expire
                        604800 )   ; Negative Cache TTL
;

@       IN      NS      ns1.k35.com.
@       IN      NS      ns2.k35.com.

@       IN      A       10.81.3.2
ns1     IN      A       10.81.3.3
ns2     IN      A       10.81.3.4

eonwe   IN      A       10.81.1.1
earendil IN     A       10.81.1.2
elwing  IN      A       10.81.1.3
cirdan  IN      A       10.81.2.2
elrond  IN      A       10.81.2.3
maglor  IN      A       10.81.2.4
sirion  IN      A       10.81.3.2
lindon  IN      A       10.81.3.5
vingilot IN     A       10.81.3.6
EOF

echo "✅ File zona k35.com dibuat di /etc/bind/zones/k35.com"

# 3️⃣ Periksa hak akses file zona
echo "🔍 Mengecek hak akses file di /etc/bind/zones/"
ls -l /etc/bind/zones/

# 4️⃣ Cek konfigurasi zona
echo "🔍 Menjalankan named-checkzone untuk k35.com..."
named-checkzone k35.com /etc/bind/zones/k35.com

# 5️⃣ Restart layanan bind9
echo "🔁 Me-restart layanan bind9..."
systemctl restart bind9

# 6️⃣ Pastikan nameserver di /etc/resolv.conf benar
echo "📝 Memastikan nameserver terisi..."
if ! grep -q "nameserver" /etc/resolv.conf; then
    echo "nameserver 10.81.3.2" > /etc/resolv.conf
    echo "✅ Nameserver 10.81.3.2 ditambahkan ke /etc/resolv.conf"
else
    echo "ℹ️  Nameserver sudah terisi:"
    cat /etc/resolv.conf
fi

# 7️⃣ Uji DNS lookup
echo "🔍 Menguji ping ke elrond.k35.com..."
ping -c 4 elrond.k35.com || echo "⚠️  Ping gagal, periksa konfigurasi BIND atau jaringan."

echo "=== [SELESAI] Zona k35.com berhasil dikonfigurasi di Terion ==="
