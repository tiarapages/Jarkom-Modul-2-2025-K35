
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
