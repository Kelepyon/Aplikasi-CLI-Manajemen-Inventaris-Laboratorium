# 🔬 Lab Inventory CLI

Aplikasi **Command Line Interface (CLI)** berbasis Dart untuk mengelola inventaris laboratorium. Data disimpan secara persisten dalam file JSON lokal.

---

## 📁 Struktur Proyek

```
lab_inventory/
├── main.dart                        # Entry point CLI
├── pubspec.yaml                     # Konfigurasi proyek Dart
├── data/
│   └── inventory.json               # Database JSON (auto-created)
└── lib/
    ├── models/
    │   └── item.dart                # Model data Item
    ├── services/
    │   └── inventory_service.dart   # Logic CRUD
    └── utils/
        └── file_helper.dart         # Baca/tulis JSON
```

---

## 🚀 Cara Menjalankan

### Prasyarat

- [Dart SDK](https://dart.dev/get-dart) versi **3.0.0 atau lebih baru**

### Langkah

```bash
# 1. Masuk ke folder proyek
cd lab_inventory

# 2. Jalankan aplikasi
dart run main.dart
```

---

## 📋 Fitur

| No  | Fitur         | Deskripsi                                            |
| --- | ------------- | ---------------------------------------------------- |
| 1   | Tambah Barang | Input kode, nama, jumlah, kondisi, dan lokasi        |
| 2   | Lihat Barang  | Tampilkan semua barang dalam tabel, sortir nama/kode |
| 3   | Cari Barang   | Cari berdasarkan nama atau kode                      |
| 4   | Update Barang | Ubah jumlah, kondisi, atau lokasi                    |
| 5   | Hapus Barang  | Hapus berdasarkan kode unik dengan konfirmasi        |

---

## 🗄️ Struktur Data

```json
[
  {
    "id": "MIC-001",
    "name": "Mikroskop Olympus",
    "quantity": 5,
    "condition": "baik",
    "location": "Rak A-1"
  }
]
```

### Field validasi:

- **id** — tidak boleh kosong, harus unik (case-insensitive)
- **name** — tidak boleh kosong
- **quantity** — angka integer ≥ 0
- **condition** — hanya `baik` atau `rusak`
- **location** — tidak boleh kosong

---

## 🎨 Tampilan CLI

```
──────────────────────────────────────────────────

██╗ █████╗ ██████╗ ██╗███╗ ██╗██╗ ██╗
██║ ██╔══██╗██╔══██╗ ██║████╗ ██║██║ ██║
██║ ███████║██████╔╝ ██║██╔██╗ ██║██║ ██║
██║ ██╔══██║██╔══██╗ ██║██║╚██╗██║╚██╗ ██╔╝
███████╗██║ ██║██████╔╝ ██║██║ ╚████║ ╚████╔╝
╚══════╝╚═╝ ╚═╝╚═════╝ ╚═╝╚═╝ ╚═══╝ ╚═══╝

Sistem Manajemen Inventaris Laboratorium v1.0
──────────────────────────────────────────────────

══════════════════ MENU UTAMA ══════════════════

1. Tambah Barang
2. Lihat Semua Barang
3. Cari Barang
4. Update Barang
5. Hapus Barang
6. Keluar
   ════════════════════════════════════════════════
   ▶ Pilih menu:
```

## 💡 Contoh Penggunaan

```
▶  Kode Unik (contoh: MIC-001): MIC-001
▶  Nama Barang: Mikroskop Olympus CX23
▶  Jumlah: 3
▶  Kondisi (baik/rusak): baik
▶  Lokasi (contoh: Rak A-3): Lemari B-2

✔  Barang "Mikroskop Olympus CX23" berhasil ditambahkan.
```

---

## 📌 Catatan

- File `data/inventory.json` dibuat otomatis saat pertama kali menjalankan program.
- Kode barang bersifat **case-insensitive** — `mic-001` dan `MIC-001` dianggap sama.
- Tidak diperlukan koneksi internet atau dependensi eksternal.
