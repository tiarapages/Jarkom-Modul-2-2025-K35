#!/bin/bash
# --------------------------------------------
# Setup DNS Master (Terion) dan Slave (Valmar)
# --------------------------------------------
# Pastikan dijalankan sebagai root
# Gunakan parameter: master / slave / test
# Contoh:
#   ./setup_dns_k35.sh master
#   ./setup_dns_k35.sh slave
#   ./setup_dns_k35.sh test
# --------------------------------------------

set -e

# ---------- MASTER (Terion) ----------
if [ "$1" == "master" ]; then
    echo "=== [MASTER: Terion] Mengonfigurasi BIND9 ==="
    apt-get update -y
    apt-get install -y bind9 bind9utils bind9-doc

    mkdir -p /etc/bind/zones

    cat > /etc/bind/zones/k35.com <<'EOF'
$TTL    604800
@       IN      SOA     k35.com. root.k35.com. (
                        2025100401
                        604800
                        86400
                        2419200
                        604800 )
;
@       IN      NS      ns1.k35.com.
@       IN      NS      ns2.k35.com.
@       IN      A       10.81.3.2
ns1     IN      A       10.81.3.3
ns2     IN      A       10.81.3.4
EOF

    cat > /etc/bind/named.conf.options <<'EOF'
options {
        directory "/var/cache/bind";
        forwarders {
             192.168.122.1;
        };
        allow-query { any; };
        recursion yes;
};
EOF

    cat > /etc/bind/named.conf.local <<'EOF'
zone "k35.com" {
        type master;
        file "/etc/bind/zones/k35.com";
        allow-transfer { 10.81.3.4; };
        also-notify { 10.81.3.4; };
};
EOF

    systemctl restart bind9
    echo "=== [MASTER] BIND9 berhasil dikonfigurasi dan direstart ==="
fi

# ---------- SLAVE (Valmar) ----------
if [ "$1" == "slave" ]; then
    echo "=== [SLAVE: Valmar] Mengonfigurasi BIND9 ==="
    apt-get update -y
    apt-get install -y bind9 bind9utils bind9-doc

    mkdir -p /etc/bind/zones

    cat > /etc/bind/named.conf.local <<'EOF'
zone "k35.com" {
    type slave;
    file "/etc/bind/zones/k35.com";
    masters { 10.81.3.3; };
};
EOF

    systemctl restart bind9
    echo "=== [SLAVE] BIND9 berhasil dikonfigurasi dan direstart ==="
fi

# ---------- TEST (Cirdan) ----------
if [ "$1" == "test" ]; then
    echo "=== [TEST: Cirdan] Menguji resolusi DNS ==="

    echo "nameserver 10.81.3.3" > /etc/resolv.conf
    echo "nameserver 10.81.3.4" >> /etc/resolv.conf

    echo ">> Ping k35.com"
    ping -c 3 k35.com || echo "Gagal ping k35.com"

    echo ">> Ping ns1.k35.com"
    ping -c 3 ns1.k35.com || echo "Gagal ping ns1.k35.com"

    echo ">> Ping ns2.k35.com"
    ping -c 3 ns2.k35.com || echo "Gagal ping ns2.k35.com"

    echo ">> Dig record ns1 dari slave (10.81.3.4)"
    dig @10.81.3.4 ns1.k35.com A

    echo "=== Matikan Terion dan uji ulang (manual) ==="
    echo "Setelah Terion dimatikan, jalankan kembali:"
    echo "ping -c 3 k35.com"
    echo "ping -c 3 ns1.k35.com"
fi
