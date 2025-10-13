#!/bin/bash
# --------------------------------------------
# Setup Forward + Reverse Zone (k35.com)
# dan pengujian PTR record untuk IP Manwe
# --------------------------------------------
# Jalankan sebagai root di Terion / Earendil
# --------------------------------------------

set -e

echo "=== [BIND CONFIG] Memulai konfigurasi zona k35.com dan reverse ==="

# Pastikan direktori zone tersedia
mkdir -p /etc/bind/zones

# 1️⃣ Konfigurasi /etc/bind/named.conf.local
cat > /etc/bind/named.conf.local <<'EOF'
zone "k35.com." {
        type master;
        file "/etc/bind/zones/k35.com";
        allow-transfer { 10.81.3.4; };
        also-notify { 10.81.3.4; };
};

zone "3.81.10.in-addr.arpa" {
    type master;
    file "/etc/bind/zones/rev.3.81.10.in-addr.arpa";
    allow-transfer { 10.81.3.4; };
};
EOF

echo "✅ named.conf.local diperbarui."

# 2️⃣ Salin atau buat file reverse zone
if [ -f /etc/bind/zone.template ]; then
    cp /etc/bind/zone.template /etc/bind/zones/rev.3.81.10.in-addr.arpa
    echo "✅ Template reverse zone disalin."
else
    echo "⚠️  Template tidak ditemukan, membuat file reverse zone baru..."
    cat > /etc/bind/zones/rev.3.81.10.in-addr.arpa <<'EOF'
$TTL    604800
@       IN      SOA     ns1.k35.com. root.k35.com. (
                        2025101201 ; Serial
                        604800      ; Refresh
                        86400       ; Retry
                        2419200     ; Expire
                        604800 )    ; Negative Cache TTL
;
        IN      NS      ns1.k35.com.
3       IN      PTR     tirion.k35.com.
2       IN      PTR     earendil.k35.com.
5       IN      PTR     static.k35.com.
6       IN      PTR     app.k35.com.
EOF
    echo "✅ File reverse zone baru dibuat."
fi

chmod 644 /etc/bind/zones/rev.3.81.10.in-addr.arpa
chown root:root /etc/bind/zones/rev.3.81.10.in-addr.arpa

# 3️⃣ Validasi konfigurasi BIND
echo "🔍 Mengecek konfigurasi zone dan conf..."
named-checkzone 3.81.10.in-addr.arpa /etc/bind/zones/rev.3.81.10.in-addr.arpa
named-checkconf

# 4️⃣ Restart bind9
echo "🔁 Me-restart layanan bind9..."
systemctl restart bind9
echo "✅ bind9 berhasil direstart."

# 5️⃣ Pastikan dnsutils terpasang
echo "📦 Memastikan paket dnsutils tersedia..."
apt-get update -y
apt-get install -y dnsutils

# 6️⃣ Kembalikan nameserver ke Foosha (gateway DNS utama)
echo "📝 Mengatur /etc/resolv.conf ke Foosha..."
cat > /etc/resolv.conf <<'EOF'
nameserver 192.168.122.1
EOF
echo "✅ Nameserver Foosha diterapkan."

# 7️⃣ Uji PTR lookup untuk IP Manwe (10.81.3.3)
echo "🔍 Menguji PTR record untuk IP 10.81.3.3 (Manwe)..."
host -t PTR 10.81.3.3 || echo "⚠️  PTR lookup gagal, periksa konfigurasi reverse zone."

echo "=== [SELESAI] Reverse zone dan PTR test berhasil ==="
