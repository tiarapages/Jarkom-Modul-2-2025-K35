
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






