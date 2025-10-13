#!/bin/bash

ZONE_FILE="/etc/bind/zones/db.k35.com"

echo "[+] Menambahkan A dan CNAME record ke zona k35.com..."

# Backup dulu
cp $ZONE_FILE ${ZONE_FILE}.bak

# Update Serial otomatis
sed -i "s/\([0-9]\{10\}\)/$(( $(date +%Y%m%d) * 100 + 1 ))/" $ZONE_FILE

# Tambah A dan CNAME record jika belum ada
grep -q "sirion" $ZONE_FILE || cat >> $ZONE_FILE <<EOF

; Host A records
sirion      IN  A   10.81.3.2
lindon      IN  A   10.81.3.5
vingilot    IN  A   10.81.3.6

; CNAME aliases
www         IN  CNAME  sirion.k35.com.
static      IN  CNAME  lindon.k35.com.
app         IN  CNAME  vingilot.k35.com.

EOF

echo "[+] Restarting Bind9 di ns1 (Tirion)..."
service bind9 restart

echo "[+] Menunggu zone transfer ke ns2 (Valmar)..."
sleep 5

echo "[+] Verifikasi serial di master dan slave:"
dig @10.81.3.3 k35.com SOA +short
dig @10.81.3.4 k35.com SOA +short

echo ""
echo "[+] Test resolusi host A record:"
dig @10.81.3.3 sirion.k35.com +short
dig @10.81.3.3 lindon.k35.com +short
dig @10.81.3.3 vingilot.k35.com +short

echo ""
echo "[+] Test resolusi alias CNAME:"
dig @10.81.3.3 www.k35.com +short
dig @10.81.3.3 static.k35.com +short
dig @10.81.3.3 app.k35.com +short

echo ""
echo "[+] Test dari dua klien (Earendil dan Elwing, misal):"
for IP in 10.81.1.1 10.81.1.2; do
  echo "=== Uji dari klien: $IP ==="
  ssh root@$IP "dig www.k35.com +short; dig static.k35.com +short; dig app.k35.com +short"
done

echo "[+] Selesai!"
