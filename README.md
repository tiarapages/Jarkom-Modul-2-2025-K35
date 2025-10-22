
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

### konfigurasi layanan DNS (Domain Name System) menggunakan dua server, yaitu:

- Tirion (ns1/master) sebagai DNS authoritative master.

- Valmar (ns2/slave) sebagai DNS slave.

Keduanya mengelola zona <xxxx>.com, dengan konfigurasi SOA, NS, dan A record sesuai ketentuan. Selain itu, konfigurasi juga mencakup pengaturan notify, allow-transfer, serta forwarders untuk menunjang replikasi zona dan resolusi DNS.

### Struktur File Shell Script

- tirion.sh → konfigurasi untuk server master (ns1)

- valmar.sh → konfigurasi untuk server slave (ns2)

- cirdan.sh → konfigurasi resolver pada client

### Beri izin eksekusi pada semua file
```
chmod +x tirion.sh valmar.sh cirdan.sh
```
### Jalankan konfigurasi
```
./tirion.sh
./valmar.sh
./cirdan.sh
```
### Tes pada client
```
ping k35.com
```
konfigurasi DNS master–slave berhasil dilakukan. Zona <xxxx>.com dapat diakses dan direplikasi dengan baik antara server Tirion (master) dan Valmar (slave), serta klien dapat melakukan resolusi nama domain dengan benar melalui ns1 dan ns2.

<img width="676" height="105" alt="Screenshot 2025-10-21 002155" src="https://github.com/user-attachments/assets/9a159260-0b04-44f4-80e3-3a37bd40ccb5" />

# 5

konfigurasi dilakukan di Tirion (ns1/master) untuk menamai setiap host sesuai glosarium dan menambahkan entri domain <hostname>.<xxxx>.com pada zona DNS <xxxx>.com.
Semua hostname harus dikenali system-wide, dan verifikasi dilakukan dengan ping ke salah satu domain (contoh: elrond.k35.com).

### Beri Izin Eksekusi
```
chmod +x tirion.sh
```

### Jalankan Script
```
./tirion.sh
```

### Verifikasi

Setelah konfigurasi selesai, pastikan DNS menjawab query dengan benar:

- Uji resolusi nama
- ping elrond.k35.com

### Jika alamat IP yang muncul sesuai dengan IP Cirdan yang telah ditentukan

- Zona DNS sudah berfungsi

- Hostname dikenali system-wide
  
- Konfigurasi berhasil

### Hasil yang Diharapkan

- Semua hostname sesuai glosarium dikenali.

- Domain <hostname>.k35.com dapat di-resolve dari ns1 (Tirion).

- ping elrond.k35.com berhasil dengan IP Cirdan yang benar.

<img width="703" height="192" alt="image" src="https://github.com/user-attachments/assets/0c01b20e-2ac0-44ae-b6e5-6e475e7f45ce" />

# 6

dilakukan verifikasi zone transfer antara server master (Tirion/ns1) dan server slave (Valmar/ns2).
Tujuannya adalah memastikan bahwa zona k35.com berhasil dikirim dari ns1 ke ns2, serta serial number pada record SOA di keduanya sama, menandakan sinkronisasi berhasil.

### Cek SOA Record dari ns1 (Tirion)
```
dig @10.81.3.3 k35.com SOA
```
<img width="1184" height="477" alt="image" src="https://github.com/user-attachments/assets/14c86100-a600-4098-9075-4377223903a0" />

### Cek SOA Record dari ns2 (Valmar):
```
dig @10.81.3.4 k35.com SOA
```
<img width="1167" height="455" alt="image" src="https://github.com/user-attachments/assets/5144f5e0-152f-472a-9b82-53943c46e6e0" />

### Pastikan Serial Number Sama

- Perhatikan baris Serial: pada output kedua perintah di atas.

- Jika angka serial sama, berarti zona <xxxx>.com sudah tersinkronisasi dengan baik antara master dan slave.

# 7

menambahkan A record dan CNAME ke zona DNS <xxxx>.com pada server Tirion (ns1/master).
Ketiga host utama dilambangkan sebagai:

- Sirion → gerbang utama (front door)

- Lindon → web statis

- Vingilot → web dinamis

Selain itu, ditambahkan CNAME alias agar domain utama (www, static, dan app) dapat diarahkan ke host masing-masing.

### Tujuan

- Menambahkan A record untuk sirion, lindon, dan vingilot.

- Menambahkan alias CNAME:

-www → sirion

-static → lindon

-app → vingilot

- Memastikan domain dapat di-resolve dengan benar dari klien.

### Buat File di Tirion file tirion.sh

### Beri Izin Eksekusi
```
chmod +x tirion.sh
```

### Jalankan Script
```
./tirion.sh
```

### tes langsung dengan ping
```
ping www.k35.com
ping static.k35.com
ping app.k35.com
```

### Hasil yang Diharapkan:

Domain	Mengarah ke	IP
- www.k35.com -> sirion.k35.com

- static.k35.com	-> lindon.k35.com
  
- app.k35.com	-> vingilot.k35.com

<img width="936" height="467" alt="Screenshot 2025-10-21 002901" src="https://github.com/user-attachments/assets/efa4bec5-db61-481a-92b8-58d7d83f5934" />


# 8

Konfigurasi reverse DNS zone dilakukan agar setiap alamat IP dalam segmen jaringan tertentu dapat diterjemahkan kembali menjadi nama host (hostname).
Dengan kata lain, reverse DNS digunakan untuk melakukan pencarian balik (reverse lookup) dari IP → hostname menggunakan catatan PTR (Pointer Record).

### Dalam konteks ini:

- Tirion (ns1) bertindak sebagai DNS Master.

- Valmar (ns2) bertindak sebagai DNS Slave.

- Sirion, Lindon, dan Vingilot adalah host yang berada di segmen DMZ (10.81.3.0/24).

### Tujuannya agar ketika dilakukan query seperti:
```
host -t PTR 10.81.3.3
```

### maka hasilnya menampilkan `10.3.81.10.in-addr.arpa domain name pointer sirion.k35.com.`

<img width="649" height="50" alt="Screenshot 2025-10-21 003459" src="https://github.com/user-attachments/assets/dd54f311-5fb2-49fb-960e-24df7d106b8f" />

# 9

Pada tahap ini, Lindon berfungsi sebagai web server statis yang akan diakses melalui hostname static.k35.com. Server ini harus mampu menampilkan isi direktori /annals/ secara langsung (directory listing / autoindex) melalui protokol HTTP, bukan melalui IP address. Fungsionalitas ini mengilustrasikan bagaimana layanan web di-deploy pada lingkungan DNS yang telah terintegrasi, di mana akses ke web dilakukan berdasarkan nama domain, bukan alamat IP mentah.

### Langkah Teknis di Server Lindon (static.k35.com)   
1. Instalasi dan aktivasi web server (nginx atau Apache)    
2. Pembuatan direktori konten statis   
3. Konfigurasi Virtual Host    
4. Aktifkan konfigurasi dan reload nginx   

### Pengujian dari Client (Cirdan)
Setelah konfigurasi DNS dan web server aktif, lakukan pengujian dari sisi client:
```
lynx http://static.k35.com/
lynx http://static.k35.com/annals/
lynx http://192.239.3.5/
```

<img width="1919" height="831" alt="image" src="https://github.com/user-attachments/assets/cb92dd52-9e0c-4e92-8203-4163237e5d7e" />
<img width="990" height="385" alt="image" src="https://github.com/user-attachments/assets/410fec47-d23d-4d0b-a691-f1d69ef07b28" />


# 10

Pada tahap ini, Vingilot berperan sebagai web server dinamis yang melayani domain app.k35.com. Server ini menjalankan PHP-FPM (FastCGI Process Manager) untuk mengeksekusi kode PHP secara efisien.

### Website ini memiliki dua halaman utama:

- index.php → sebagai beranda

- about.php → sebagai halaman “About”

Selain itu, diterapkan URL rewriting agar pengguna dapat mengakses /about tanpa perlu menulis ekstensi .php. Akses hanya boleh dilakukan menggunakan hostname app.k35.com, bukan melalui alamat IP secara langsung.

### Membuat file .sh
1. membuat file nano
  
2. memberi izin eksekusi
   ```
   chmod +x <filename>.sh
   ```
   
3.  Menjalankan file
   ```
  ./<filename>.sh
  ```

### Langkah Konfigurasi Teknis   

1. Instalasi Paket Web Dinamis
   
2. Struktur Direktori Web
   
3. Konfigurasi Virtual Host Nginx

### Pengujian di Client (Cirdan)

Gunakan lynx untuk memastikan akses melalui hostname berhasil:
```
lynx http://app.k35.com/
lynx http://app.k35.com/about
lynx http://10.81.3.6/
```

# 11

Pada tahap ini, Sirion berfungsi sebagai reverse proxy server yang mengarahkan permintaan (request) HTTP ke dua backend berbeda berdasarkan path (rute URL).
Tujuannya adalah membangun path-based routing, di mana:
- /static diteruskan ke Lindon (web statis)

- /app diteruskan ke Vingilot (web dinamis)

Sirion juga menerima akses dari dua domain:

- www.k35.com (domain kanonik utama)

- sirion.k35.com (nama host internal)

Selain itu, konfigurasi harus meneruskan header penting:

- Host → agar backend tahu domain asli yang diminta klien.

- X-Real-IP → agar backend mengetahui alamat IP klien sebenarnya (bukan IP Sirion).

Dengan cara ini, Sirion bertindak sebagai gerbang depan (front gateway) untuk semua akses web.

### Langkah Konfigurasi Teknis

1. Instalasi dan Persiapan
   
2. Struktur dan Alamat Backend
   
3. Konfigurasi Reverse Proxy

### Uji Akses dari Client

Pastikan resolusi DNS dan routing berjalan dengan benar.

- Akses ke Web Statis (Menampilkan isi halaman dari Lindon (web statis)).
```
lynx http://www.k35.com/static/
```

- Akses ke Web Dinamis (Menampilkan konten dari Vingilot (web dinamis)).
```
lynx http://www.k35.com/app/
```

` Akses langsung via IP
```
lynx http://10.81.3.3/
```

# 12

Pada tahap ini, Sirion (reverse proxy utama) diperkuat dengan lapisan keamanan tambahan untuk melindungi direktori sensitif /admin.
Metode autentikasi yang digunakan adalah HTTP Basic Authentication, di mana pengguna harus memasukkan username dan password sebelum dapat mengakses path /admin.

Jika pengguna mencoba mengakses /admin tanpa kredensial atau dengan kredensial salah, maka akses harus ditolak (HTTP 401 Unauthorized).
Namun, jika username dan password benar, maka akses akan diizinkan dan halaman backend ditampilkan.

Tujuan langkah ini adalah memastikan bahwa path administratif tidak dapat diakses publik, melainkan hanya oleh pengguna yang memiliki izin.

### Langkah Konfigurasi Teknis

1. Instalasi Paket Pendukung

2. Membuat File Password

3. Konfigurasi Server Block di Sirion

### Uji Akses dari Client

Gunakan lynx atau curl untuk menguji akses.
```
curl -I http://www.k35.com/admin/
curl -I -u admin:jarkom http://www.k35.com/admin/ (benar)
curl -I -u admin:admin http://www.k35.com/admin/ (salah)
```

# 13
Pada tahap ini, konfigurasi dilakukan pada Sirion, yang berfungsi sebagai reverse proxy dalam sistem jaringan domain k35.com.
Tujuannya adalah untuk menetapkan hostname kanonik (www.k35.com) sebagai satu-satunya nama domain resmi yang digunakan untuk mengakses layanan web.


Secara teknis, konfigurasi ini memastikan bahwa setiap permintaan HTTP yang masuk ke Sirion — baik menggunakan alamat IP langsung (10.81.3.3) maupun subdomain sirion.k35.com — akan di-redirect secara permanen (HTTP 301) menuju www.k35.com.

Konfigurasi ini juga menjadi langkah terakhir dalam penyatuan sistem DNS dan layanan web antara node:

- Lindon (static site)

- Vingilot (dynamic PHP site)

- Sirion (reverse proxy dan redirect handler)

#### Pengujian

- Akses via IP → HARUS 301 ke www
```
curl -I http://10.81.3.3/
```

- Akses sirion.k35.com → HARUS 301 ke www
```
curl -I http://sirion.k35.com/app/about
```

- Akses kanonik → HARUS 200/OK (dilayani oleh vhost www)
```
curl -I http://www.k35.com/static/
curl -I http://www.k35.com/app/
curl -I http://www.k35.com/app/about
```

- Akses admin → HARUS 401 bila tanpa kredensial, 200 bila pakai kredensial
```
curl -I http://www.k35.com/admin/
curl -I -u admin:password http://www.k35.com/admin/
```

# 14

Pada tahap ini, konfigurasi berfokus pada pelacakan IP asli klien ketika trafik web melewati reverse proxy (Sirion) sebelum mencapai Vingilot (backend aplikasi PHP-FPM).
Secara default, ketika permintaan dikirim melalui reverse proxy seperti Nginx, Vingilot hanya melihat IP Sirion (misalnya 10.81.3.2) karena koneksi TCP terakhir berasal dari proxy tersebut. Agar log tetap akurat, kita harus meneruskan informasi IP asli klien menggunakan header X-Real-IP dan X-Forwarded-For dari Sirion ke Vingilot, kemudian mengonfigurasi Nginx di Vingilot agar membaca header tersebut dan menuliskannya ke access log.


Langkah ini penting agar catatan log (/var/log/nginx/access.log) di Vingilot benar-benar mencerminkan siapa pengunjung aslinya, bukan hanya proxy yang meneruskan koneksi.
Hasil akhir yang diharapkan:

-Saat klien (mis. Cirdan) mengakses situs melalui www.k35.com, IP yang muncul di log Vingilot adalah IP klien, bukan IP Sirion.

-Semua permintaan yang datang melalui Sirion masih diteruskan dengan header Host dan X-Real-IP yang benar.













