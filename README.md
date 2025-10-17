
# Jarkom-Modul-2-2025-K35

| Nama | NRP |
|---|---|
| Tiara Putri Prasetya | 5027241013 |
| Naufal Ardhana | 5027241118 |

# 1  
- Eonwe = router utama  
- Earendil, Elwing = klien Barat  
- Cirdan, Elrond, Maglor = klien Timur  
- Sirion, Tirion, Valmar, Lindon, Vingilot = pelabuhan/DMZ

Berikut merupakan masing masing Address pada node
| **No** | **Host (Tokoh)**  | **Address** |
| :----: | ---------------- | ------------- |
| 1 | **Eonwe**   | 10.81.1.1 |
| 2 | **Earendil**| 10.81.1.2 |
| 3 | **Elwing**  | 10.81.1.3 |
| 4 | **Cirdan**  | 10.81.2.2 |
| 5 | **Elrond**  | 10.81.2.3 |
| 6 | **Maglor**  | 10.81.2.4 |
| 7 | **Sirion**  | 10.81.3.2 |
| 8 | **Tirion** | 10.81.3.3 |
| 9 | **Valmar** | 10.81.3.4 |
| 10 | **Lindon** | 10.81.3.5 |
| 11 | **Vingilot**  | 10.81.3.6 |

<img width="792" height="713" alt="Screenshot 2025-10-13 143144" src="https://github.com/user-attachments/assets/76d8bf47-ff19-4dc6-8ba9-e4ea07510e92" />  
Pertama, setting network masing-masing node dengan fitur Edit network configuration, Prefix IP menggunakan 10.81 untuk kelompok 35 

1. Eonwe

```
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
  address 10.81.1.1
  netmask 255.255.255.0

auto eth2
iface eth2 inet static
  address 10.81.2.1
  netmask 255.255.255.0

auto eth3
iface eth3 inet static
  address 10.81.3.1
  netmask 255.255.255.0

up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.81.0.0/16

```

2. Earendil
```
auto eth0
iface eth0 inet static
    address 10.81.1.2
    netmask 255.255.255.0
    gateway 10.81.1.1

 up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

3. Elwing
```
auto eth0
iface eth0 inet static
    address 10.81.1.3
    netmask 255.255.255.0
    gateway 10.81.1.1

 up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

4. Cirdan
```
auto eth0
iface eth0 inet static
    address 10.81.2.2
    netmask 255.255.255.0
    gateway 10.81.2.1

    up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

5. Elrond
```
auto eth0
iface eth0 inet static
    address 10.81.2.3
    netmask 255.255.255.0
    gateway 10.81.2.1

up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

6. Maglor
```
auto eth0
iface eth0 inet static
    address 10.81.2.4
    netmask 255.255.255.0
    gateway 10.81.2.1

  up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

7. Sirion
```
auto eth0
iface eth0 inet static
    address 10.81.3.2
    netmask 255.255.255.0
    gateway 10.81.3.1

up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

8. Tirion
```
auto eth0
iface eth0 inet static
    address 10.81.3.3
    netmask 255.255.255.0
    gateway 10.81.3.1

up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

9. Valmar
```
auto eth0
iface eth0 inet static
    address 10.81.3.4
    netmask 255.255.255.0
    gateway 10.81.3.1

up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

10. Lindon
```
auto eth0
iface eth0 inet static
    address 10.81.3.5
    netmask 255.255.255.0
    gateway 10.81.3.1

    up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

11. Vingilot
```
auto eth0
iface eth0 inet static
    address 10.81.3.6
    netmask 255.255.255.0
    gateway 10.81.3.1

  up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

# 2
Bagian ini menjelaskan bahwa **Eonwe**, sebagai router utama, berperan untuk **menghubungkan jaringan internal** (LAN Barat, LAN Timur, dan DMZ) dengan **jaringan eksternal (internet)**.  
Agar host di jaringan internal (yang menggunakan IP privat) dapat mengakses jaringan luar (yang menggunakan IP publik), diperlukan mekanisme **NAT (Network Address Translation)**.

Tanpa NAT, paket dari IP privat seperti `10.81.x.x` akan ditolak oleh jaringan luar karena IP tersebut tidak dapat dirutekan di internet.  
Dengan NAT, router akan menerjemahkan alamat sumber paket internal menjadi alamat IP publik milik router pada interface WAN-nya.  
Sehingga, router bertindak sebagai perantara yang meneruskan lalu lintas keluar dan mencatat sesi koneksi agar balasan dari luar dapat diarahkan kembali ke host yang benar. Yang pertama yaitu menambahkan `nano /root/.bashrc` pada semua node agar jika di refresh tidak hilang. lalu tambahkan script berikut

```
# pada Eonwe
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.81.0.0/16

# pada node lainnya
echo nameserver 192.168.122.1 > /etc/resolv.conf
```
Lalu jika sudah, kita dapat melihat nameserver, lalu restart node terlebih dahulu dan dapat melakukan `ping`

```
cat /etc/resolv.conf
ping google.com
```
<img width="1228" height="453" alt="Screenshot 2025-10-13 153526" src="https://github.com/user-attachments/assets/98982f45-42d6-48dd-9136-0bad5413f377" />

# 3

Bagian ini memastikan bahwa **semua klien di jaringan Barat (Earendil, Elwing)** dan **Timur (Círdan, Elrond, Maglor)** dapat saling berkomunikasi melewati router **Eonwe**.  
Karena Eonwe sudah memiliki beberapa interface (10.81.1.1, 10.81.2.1, 10.81.3.1) dan **IP forwarding** telah diaktifkan pada tahap NAT, maka paket antar subnet akan otomatis diteruskan oleh router.

Dengan demikian:
- Klien di jaringan Barat dapat mengirim paket ke jaringan Timur melalui Eonwe.  
- Klien di jaringan Timur juga dapat menjangkau jaringan DMZ (Sirion, Tirion, Valmar, dsb).  
- Tidak perlu routing tambahan di klien karena semua sudah diarahkan melalui gateway masing-masing (IP router Eonwe).

Agar setiap klien dapat mengunduh paket atau update dari internet sebelum DNS internal aktif, ditambahkan resolver sementara `192.168.122.1` pada file konfigurasi jaringan masing-masing klien.

Contoh :
- Dari Earendil (Barat), lakukan ping ke Elrond (Timur) menggunakan `root@Earendil:~# ping 10.81.2.3` 
<img width="841" height="147" alt="Screenshot 2025-10-13 154245" src="https://github.com/user-attachments/assets/571f5393-fd86-4a1a-8c76-7d5a5f35ca83" />

- Dari Elrond (Timur), lakukan ping ke Melwig(Barat) menggunakan `root@Elrond:~# ping 10.81.1.3`
  <img width="810" height="117" alt="Screenshot 2025-10-13 154314" src="https://github.com/user-attachments/assets/cfb091f5-eaa2-4230-815f-3607a00512e5" />

  # 4

  Di Node Tirion
  
```
  mkdir /etc/bind/zones
  nano /etc/bind/named.conf.local
 ```
Edit Konfigurasi Lokal
```
zone "k35.com" {
 type master;
 file "/etc/bind/zones/k35.com";
 notify yes;
 allow-transfer { 10.81.3.4; };
 also-notify { 10.81.3.4; };
 };
 nano /etc/bind/named.conf.options
 forwarders {
 192.168.122.1;
 };
 nano /etc/bind/zone.template
 $TTL    604800          ; Waktu cache default (detik)
 @       IN      SOA     localhost. root.localhost. (
 2025100401 ; Serial (format YYYYMMDDXX)
 604800     ; Refresh (1 minggu)
 86400      ; Retry (1 hari)
 2419200    ; Expire (4 minggu)
 604800 )   ; Negative Cache TTL
 ;
 @       IN      NS      localhost.
 @       IN      A       127.0.0.1
```
Masukkan `cp /etc/bind/zone.template /etc/bind/zones/k35.com`
dan edit konfigurasi zones 35 `nano /etc/bind/zones/k35.com`

```
 $TTL    604800          ; Waktu cache default (detik)
@       IN      SOA     k35.com. root.k35.com. (
 2025100401 ; Serial (format YYYYMMDDXX)
 604800     ; Refresh (1 minggu)
 86400      ; Retry (1 hari)
 2419200    ; Expire (4 minggu)
 604800 )   ; Negative Cache TTL
 ;
 @       IN      NS      ns1.k35.com.
 @       IN      NS      ns2.k35.com.
 @       IN      A       10.81.3.2;
 ns1     IN      A       10.81.3.3;
 ns2     IN      A       10.81.3.4;
```
Restart service bind9 ` service bind9 restart`
Di Node Valmar
Edit Konfigurasi Lokal ` nano /etc/bind/named.conf.local`

```
 zone "k35.com" {  
type slave;  
masters { 10.81.3.3; };
 file "/etc/bind/zones/k35.com";  
};
```

Restart service bind9 ` service bind9 restart`

di client masukkan nameserver kedalam solv.conf
```
nameserver 192.239.3.3
nameserver 192.239.3.4
```
<img width="820" height="310" alt="image" src="https://github.com/user-attachments/assets/cf3ea9a3-e757-4441-a420-a7e86ae59b83" />

Hasil Ping yang berfungsi

# 5
Di Node Tirion Lakukan Konfigurasi zone ` nano /etc/bind/zones/k56.com`
```
 $TTL    604800          ; Waktu cache default (detik)
 @       IN      SOA     k35.com. root.k35.com. (
 2025100401 ; Serial (format YYYYMMDDXX)
 604800     ; Refresh (1 minggu)
 86400      ; Retry (1 hari)
 2419200    ; Expire (4 minggu)
 604800 )   ; Negative Cache TTL
 ;
 @       IN      NS      ns1.k35.com.
 @       IN      NS      ns2.k35.com.
 @       IN      A       10.81.3.2;
 ns1     IN      A       10.81.3.3;
 ns2     IN      A       10.81.3.4;
 eonwe   IN      A       10.81.1.1;
 earendil IN     A       10.81.1.2;
 elwing  IN      A       10.81.1.3;
 cirdan  IN      A       10.81.2.2;
 elrond  IN      A       10.81.2.3;
 maglor  IN      A       10.81.2.4;
 sirion  IN      A       10.81.3.2;
 lindon  IN      A       10.81.3.5;
 vingilot IN     A       10.81.3.6;
```
Restart service agar berjalan `service bind9 restart`
<img width="703" height="192" alt="image" src="https://github.com/user-attachments/assets/0c01b20e-2ac0-44ae-b6e5-6e475e7f45ce" />

# 6
Jalankan dig untuk melihat serial number ` dig @10.81.3.3 k35.com SOA`
<img width="1184" height="477" alt="image" src="https://github.com/user-attachments/assets/14c86100-a600-4098-9075-4377223903a0" />
Jalankan dig juga untuk melihat serial number `dig @192.239.3.4 k35.com SOA`
<img width="1167" height="455" alt="image" src="https://github.com/user-attachments/assets/5144f5e0-152f-472a-9b82-53943c46e6e0" />

# 7
Di Tirion
Edit konfigurasi zones `nano /etc/bind/zones/k35.com`
```
 $TTL    604800          ; Waktu cache default (detik)
 @       IN      SOA     k35.com. root.k35.com. (
 2025100401 ; Serial (format YYYYMMDDXX)
 604800     ; Refresh (1 minggu)
 86400      ; Retry (1 hari)
 2419200    ; Expire (4 minggu)
 604800 )   ; Negative Cache TTL
 ;
 @       IN      NS      ns1.k35.com.
 @       IN      NS      ns2.k35.com.
 @       IN      A       10.81.3.2;
 ns1     IN      A       10.81.3.3;
 ns2     IN      A       10.81.3.4;
 eonwe   IN      A       10.81.1.1;
 earendil IN      A       10.81.1.2;
 elwing  IN      A       10.81.1.3;
 cirdan  IN      A       10.81.2.2;
 elrond  IN      A       10.81.2.3;
 maglor  IN      A       10.81.2.4;
 sirion  IN      A       10.81.3.2;
 lindon  IN      A       10.81.3.5;
 vingilot IN      A       10.81.3.6;
 www     IN      CNAME   sirion.k35.com.
 static  IN      CNAME   lindon.k35.com.
 app     IN      CNAME   vingilot.k35.com.
```
Restart kembali service `service bind9 restart`
<img width="850" height="589" alt="image" src="https://github.com/user-attachments/assets/a9b2d0db-8ba0-4202-8d3a-90d33b5a794a" />
<img width="803" height="515" alt="image" src="https://github.com/user-attachments/assets/26ec0c8f-5d2f-4900-b891-e9a27bec44c7" />

# 8
Di Tirion
Edit Konfigurasi Lokal ` nano /etc/bind/named.conf.local`
```
zone "3.239.192.in-addr.arpa" {
 type master;
 file "/etc/bind/zones/3.239.192.in-addr.arpa";
 allow-transfer { 10.81.3.4; };
 };
```

Edit Konfigurasi zones addr.arpa `nano /etc/bind/zones/3.239.192.in-addr.arpa`
```
$TTL    604800          ; Waktu cache default (detik)
 @       IN      SOA      k35.com. root.k35.com. (
 2025100401 ; Serial (format YYYYMMDDXX)
 604800     ; Refresh (1 minggu)
 86400      ; Retry (1 hari)
 2419200    ; Expire (4 minggu)
 604800 )   ; Negative Cache TTL
 ;
 3.239.192.in-addr.arpa.       IN      NS      k35.com.
 3       IN      PTR     k35.com.
 2       IN      PTR     sirion.k35.com.
 5       IN      PTR     lindon.k35.com.
 6       IN      PTR     vingilot.k35.com.
```
Restart kembali service bind9 `service bind9 restart`

Di Node Valmar
Edit Konfigurasi Lokal `nano /etc/bind/named.conf.local`
```
zone "3.239.192.in-addr.arpa" {
 type slave;
 masters { 10.81.3.3; };
 file "/etc/bind/zones/3.239.192.in-addr.arpa";
 };
```
Restart kembali service `service bind9 restart`
Dan jalankan tes `host -t PTR 10.81.3.3`

# 9
Di Node Lindon
`apt update && apt install nginx -y`

Dan buat direktori serta ubha hak akses
```
mkdir -p /var/www/static/annals
chown -R www-data:www-data /var/www/static
```
Edit static html dan log txt
```
 echo "index for static site" | tee /var/www/static/index.html
 echo "log-2025.txt" | tee /var/www/static/annals/log-2025.txt
```

Edit nginx sites ip ` nano /etc/nginx/sites-available/000-default-ip-block`
```
 server {
 listen 80 default_server;
 listen [::]:80 default_server;
 server_name _;
 return 444;
 }
```
Jalankan list nginx melalui node `ln -s /etc/nginx/sites-available/000-default-ip-block /etc/nginx/sites
enabled/000-default-ip-block`

Edit defaul nginx ` nano /etc/nginx/sites-enabled/default`

Dan Hapus default_server di listen 80
`nano /etc/nginx/sites-available/static.k35.com`
```
 server {
 listen 80;
 listen [::]:80;
 server_name static.k56.com;
 root /var/www/static;
 index index.html;
 if ($host != "static.k56.com") { return 444; }
location / {
 try_files $uri $uri/ =404;
 }
 location /annals/ {
 autoindex on;
 autoindex_exact_size off;
 autoindex_localtime on;
 disable_symlinks on;
 }
 add_header X-Content-Type-Options nosniff;
 add_header Referrer-Policy no-referrer;
 add_header X-Frame-Options SAMEORIGIN;
 }
```
enable nginx 
```
ln -s /etc/nginx/sites-available/static.k56.com /etc/nginx/sites
enabled/
nginx -t
service nginx restart
```
Jalankan protokol dan tes
```
 curl -I http://static.k56.com/
 curl -I http://static.k56.com/annals/
 curl -I http://192.239.3.5/
```
<img width="1919" height="831" alt="image" src="https://github.com/user-attachments/assets/cb92dd52-9e0c-4e92-8203-4163237e5d7e" />
<img width="990" height="385" alt="image" src="https://github.com/user-attachments/assets/410fec47-d23d-4d0b-a691-f1d69ef07b28" />


# 10
Di Node Vingilot
Install protokol nginx
```
 apt update && apt install nginx php8.4-fpm php8.4-cli -y
 service php8.4-fpm start --now
```
Buat Folder app dan edit hak akses
```
 mkdir -p /var/www/app
 chown -R www-data:www-data /var/www/app
```
Edit hasil nginx
```
tee /var/www/app/index.php >/dev/null <<'PHP'
 <?php
 echo "<h1>Welcome to app.&lt;xxxx&gt;.com</h1>";
 echo '<p><a href="/about">About</a></p>';
 PHP
 tee /var/www/app/about.php >/dev/null <<'PHP'
 <?php
 echo "<h1>About</h1><p>This is the about page served via PHP-FPM.</p>";
 PHP
 ```
Edit ip block agar bisa berjalan ` nano /etc/nginx/sites-available/000-default-ip-block`
```
server {
 listen 80 default_server;
 listen [::]:80 default_server;
 server_name _;
 return 444;
 }
```
Aktifkan konfigurasinya
```
 ln -s /etc/nginx/sites-available/000-default-ip-block /etc/nginx/sites
enabled/000-default-ip-block
```
edit sistem default agar tidak ada defaul server di listen 80
```
nano /etc/nginx/sites-enabled/default
 //Hapus default_server di listen 80
 nano /etc/nginx/sites-available/app.k56.com
 server {
listen 80;
 listen [::]:80;
 server_name app.k56.com;
 root /var/www/app;
 index index.php index.html;
 if ($host != "app.k56.com") { return 444; }
 location / {
 try_files $uri $uri/ $uri.php?$args;
 }
 location ~ \.php$ {
 include snippets/fastcgi-php.conf;
 fastcgi_pass unix:/run/php/php8.4-fpm.sock;
 fastcgi_param SCRIPT_FILENAME 
$document_root$fastcgi_script_name;
 fastcgi_read_timeout 60s;
 }
 location ~* \.(?:env|ini|log|backup|bak)$ { deny all; }
 add_header X-Content-Type-Options nosniff;
 add_header Referrer-Policy no-referrer;
 add_header X-Frame-Options SAMEORIGIN;
 }
```
Jalankan sistem default nginx
```
 ln -s /etc/nginx/sites-available/app.k56.com /etc/nginx/sites-enabled/
 nginx -t
 service nginx restart
```
Uji coba sistem
```
curl -I http://app.k56.com/
 curl -I http://app.k56.com/about
 curl -I http://192.239.3.6/
```
<img width="1000" height="511" alt="image" src="https://github.com/user-attachments/assets/ef2a8319-5cb4-4429-9f67-73cfd0f84923" />

# 11















