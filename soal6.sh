#!/bin/bash
# ==========================================================
# Konfigurasi DNS Master-Slave (Tirion & Valmar)
# ==========================================================
# Pastikan script ini dijalankan sebagai root
# Jalankan di node yang sesuai (Tirion atau Valmar)
# ==========================================================

read -p "Apakah ini dijalankan di Tirion (master) atau Valmar (slave)? [master/slave]: " NODE

if [ "$NODE" == "master" ]; then
    echo "[INFO] Konfigurasi DNS MASTER (Tirion)..."

    # Pastikan direktori zona tersedia
    mkdir -p /etc/bind/zones

    # Buat file zona k35.com
    cat > /etc/bind/zones/k35.com << 'EOF'
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

    # Edit konfigurasi BIND untuk zona master
    cat > /etc/bind/named.conf.local << 'EOF'
zone "k35.com" {
    type master;
    file "/etc/bind/zones/k35.com";
    allow-transfer { 10.81.3.4; };   // IP Valmar (slave)
};
EOF

    echo "[INFO] Mengecek konfigurasi..."
    named-checkzone k35.com /etc/bind/zones/k35.com
    named-checkconf

    echo "[INFO] Restarting bind9..."
    systemctl restart bind9

    echo "[INFO] Coba ping domain internal:"
    ping -c 3 elrond.k35.com

    echo "[SELESAI] Master DNS Tirion selesai dikonfigurasi."

elif [ "$NODE" == "slave" ]; then
    echo "[INFO] Konfigurasi DNS SLAVE (Valmar)..."

    # Pastikan direktori cache tersedia
    mkdir -p /var/cache/bind

    # Edit konfigurasi BIND untuk zona slave
    cat > /etc/bind/named.conf.local << 'EOF'
zone "k35.com" {
    type slave;
    masters { 10.81.3.3; };          // IP Tirion (master)
    file "/var/cache/bind/db.k35.com";
};
EOF

    echo "[INFO] Restarting bind9..."
    systemctl restart bind9

    echo "[INFO] Coba tes dengan dig:"
    dig @10.81.3.4 k35.com SOA

    echo "[INFO] Cek file cache slave:"
    ls -la /var/cache/bind/
    cat /var/cache/bind/db.k35.com || echo "(File belum tersinkron — tunggu beberapa detik)"

    echo "[SELESAI] Slave DNS Valmar selesai dikonfigurasi."
else
    echo "[ERROR] Pilihan tidak valid. Ketik 'master' atau 'slave'."
    exit 1
fi
