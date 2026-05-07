// main.dart

import 'dart:io';

import 'lib/services/inventory_service.dart';

// ═══════════════════════════════════════════════════
//  KONSTANTA WARNA ANSI
// ═══════════════════════════════════════════════════
const String reset = '\x1B[0m';
const String bold = '\x1B[1m';
const String cyan = '\x1B[36m';
const String green = '\x1B[32m';
const String yellow = '\x1B[33m';
const String red = '\x1B[31m';
const String blue = '\x1B[34m';
const String white = '\x1B[37m';

// ═══════════════════════════════════════════════════
//  ENTRY POINT
// ═══════════════════════════════════════════════════
Future<void> main() async {
  final service = InventoryService();
  await service.load();

  printBanner();

  while (true) {
    printMenu();
    final choice = prompt('Pilih menu').trim();

    switch (choice) {
      case '1':
        await menuTambahBarang(service);
      case '2':
        menuLihatBarang(service);
      case '3':
        menuCariBarang(service);
      case '4':
        await menuUpdateBarang(service);
      case '5':
        await menuHapusBarang(service);
      case '0':
        printLine(cyan);
        print(
          '$cyan${bold}Terima kasih telah menggunakan Lab Inventory.$reset',
        );
        printLine(cyan);
        exit(0);
      default:
        printWarning('Pilihan tidak valid. Masukkan angka 0–5.');
    }
  }
}

// ═══════════════════════════════════════════════════
//  MENU 1 — TAMBAH BARANG
// ═══════════════════════════════════════════════════
Future<void> menuTambahBarang(InventoryService service) async {
  printHeader('TAMBAH BARANG BARU');

  final id = promptRequired('Kode Unik (contoh: MIC-001)');
  final name = promptRequired('Nama Barang');
  final quantity = promptInt('Jumlah');
  final condition = promptCondition();
  final location = promptRequired('Lokasi (contoh: Rak A-3)');

  final result = await service.addItem(
    id: id,
    name: name,
    quantity: quantity,
    condition: condition,
    location: location,
  );

  result.success ? printSuccess(result.message) : printError(result.message);
  pausePrompt();
}

// ═══════════════════════════════════════════════════
//  MENU 2 — LIHAT SEMUA BARANG
// ═══════════════════════════════════════════════════
void menuLihatBarang(InventoryService service) {
  printHeader('DAFTAR INVENTARIS LABORATORIUM');

  if (service.totalItems == 0) {
    printWarning('Belum ada barang dalam inventaris.');
    pausePrompt();
    return;
  }

  print('Urutkan berdasarkan:');
  print('  ${cyan}1$reset. Nama');
  print('  ${cyan}2$reset. Kode');
  final sortChoice = prompt('Pilihan urutan [1]').trim();
  final sortBy = sortChoice == '2' ? 'id' : 'name';

  final items = service.getAllItems(sortBy: sortBy);
  printTable(items);
  print('\n${blue}Total: ${bold}${items.length} barang$reset');
  pausePrompt();
}

// ═══════════════════════════════════════════════════
//  MENU 3 — CARI BARANG
// ═══════════════════════════════════════════════════
void menuCariBarang(InventoryService service) {
  printHeader('CARI BARANG');

  final query = promptRequired('Masukkan nama / kode barang');
  final results = service.searchItems(query);

  if (results.isEmpty) {
    printWarning('Tidak ditemukan barang dengan kata kunci "$query".');
  } else {
    printSuccess('Ditemukan ${results.length} barang:');
    printTable(results);
  }
  pausePrompt();
}

// ═══════════════════════════════════════════════════
//  MENU 4 — UPDATE BARANG
// ═══════════════════════════════════════════════════
Future<void> menuUpdateBarang(InventoryService service) async {
  printHeader('UPDATE BARANG');

  final id = promptRequired('Masukkan Kode Barang yang akan diubah');

  print('\nKosongkan field untuk tidak mengubah nilainya.\n');

  // Jumlah
  int? newQty;
  final qtyStr = prompt('Jumlah baru').trim();
  if (qtyStr.isNotEmpty) {
    final parsed = int.tryParse(qtyStr);
    if (parsed == null || parsed < 0) {
      printError('Jumlah tidak valid, field ini dilewati.');
    } else {
      newQty = parsed;
    }
  }

  // Kondisi
  String? newCond;
  final condStr = prompt('Kondisi baru (baik/rusak)').trim().toLowerCase();
  if (condStr.isNotEmpty) {
    if (condStr == 'baik' || condStr == 'rusak') {
      newCond = condStr;
    } else {
      printError('Kondisi tidak valid, field ini dilewati.');
    }
  }

  // Lokasi
  String? newLoc;
  final locStr = prompt('Lokasi baru').trim();
  if (locStr.isNotEmpty) newLoc = locStr;

  if (newQty == null && newCond == null && newLoc == null) {
    printWarning('Tidak ada perubahan yang dilakukan.');
    pausePrompt();
    return;
  }

  final result = await service.updateItem(
    id,
    quantity: newQty,
    condition: newCond,
    location: newLoc,
  );

  result.success ? printSuccess(result.message) : printError(result.message);
  pausePrompt();
}

// ═══════════════════════════════════════════════════
//  MENU 5 — HAPUS BARANG
// ═══════════════════════════════════════════════════
Future<void> menuHapusBarang(InventoryService service) async {
  printHeader('HAPUS BARANG');

  final id = promptRequired('Masukkan Kode Barang yang akan dihapus');

  // Konfirmasi
  final confirm = prompt(
    'Yakin hapus barang "$id"? (y/n)',
  ).trim().toLowerCase();
  if (confirm != 'y') {
    printWarning('Penghapusan dibatalkan.');
    pausePrompt();
    return;
  }

  final result = await service.deleteItem(id);
  result.success ? printSuccess(result.message) : printError(result.message);
  pausePrompt();
}

// ═══════════════════════════════════════════════════
//  HELPERS — UI
// ═══════════════════════════════════════════════════

void printBanner() {
  printLine(cyan);
  print('$cyan$bold');
  print('  ██╗      █████╗ ██████╗    ██╗███╗   ██╗██╗   ██╗');
  print('  ██║     ██╔══██╗██╔══██╗   ██║████╗  ██║██║   ██║');
  print('  ██║     ███████║██████╔╝   ██║██╔██╗ ██║██║   ██║');
  print('  ██║     ██╔══██║██╔══██╗   ██║██║╚██╗██║╚██╗ ██╔╝');
  print('  ███████╗██║  ██║██████╔╝   ██║██║ ╚████║ ╚████╔╝ ');
  print('  ╚══════╝╚═╝  ╚═╝╚═════╝    ╚═╝╚═╝  ╚═══╝  ╚═══╝ ');
  print('$reset');
  print('  ${white}Sistem Manajemen Inventaris Laboratorium v1.0$reset');
  printLine(cyan);
}

void printMenu() {
  print('\n$bold${blue}══════════════════ MENU UTAMA ══════════════════$reset');
  print('  ${cyan}1$reset. Tambah Barang');
  print('  ${cyan}2$reset. Lihat Semua Barang');
  print('  ${cyan}3$reset. Cari Barang');
  print('  ${cyan}4$reset. Update Barang');
  print('  ${cyan}5$reset. Hapus Barang');
  print('  ${red}0$reset. Keluar');
  print('$blue════════════════════════════════════════════════$reset');
}

void printHeader(String title) {
  print('\n$bold$cyan╔══════════════════════════════════════════════╗$reset');
  print('$bold$cyan║$reset $bold${title.padRight(44)}$cyan║$reset');
  print('$bold$cyan╚══════════════════════════════════════════════╝$reset\n');
}

void printLine([String color = white]) {
  print('$color${'─' * 50}$reset');
}

void printSuccess(String msg) => print('\n$green✔  $msg$reset');
void printError(String msg) => print('\n$red✘  $msg$reset');
void printWarning(String msg) => print('\n$yellow⚠  $msg$reset');

void printTable(List items) {
  // Header
  final sep = '─' * 72;
  print('\n$cyan$sep$reset');
  print(
    '$bold'
    '${'KODE'.padRight(12)}'
    '${'NAMA BARANG'.padRight(24)}'
    '${'QTY'.padLeft(6)}'
    '${'  KONDISI'.padRight(10)}'
    '${'LOKASI'.padRight(18)}'
    '$reset',
  );
  print('$cyan$sep$reset');

  for (final item in items) {
    final condColor = item.condition == 'baik' ? green : red;
    print(
      '${item.id.padRight(12)}'
      '${_truncate(item.name, 23).padRight(24)}'
      '${item.quantity.toString().padLeft(6)}'
      '  $condColor${item.condition.padRight(8)}$reset'
      '${_truncate(item.location, 18).padRight(18)}',
    );
  }
  print('$cyan$sep$reset');
}

String _truncate(String s, int max) =>
    s.length > max ? '${s.substring(0, max - 1)}…' : s;

// ═══════════════════════════════════════════════════
//  HELPERS — INPUT
// ═══════════════════════════════════════════════════

String prompt(String label) {
  stdout.write('$yellow▶  $label$reset: ');
  return stdin.readLineSync() ?? '';
}

String promptRequired(String label) {
  while (true) {
    final val = prompt(label).trim();
    if (val.isNotEmpty) return val;
    printError('Field ini tidak boleh kosong.');
  }
}

int promptInt(String label) {
  while (true) {
    final raw = prompt(label).trim();
    final parsed = int.tryParse(raw);
    if (parsed != null && parsed >= 0) return parsed;
    printError('Masukkan angka valid (>= 0).');
  }
}

String promptCondition() {
  while (true) {
    stdout.write(
      '$yellow▶  Kondisi (${green}baik${reset}/${red}rusak${reset}$yellow)$reset: ',
    );
    final val = (stdin.readLineSync() ?? '').trim().toLowerCase();
    if (val == 'baik' || val == 'rusak') return val;
    printError('Kondisi harus "baik" atau "rusak".');
  }
}

void pausePrompt() {
  stdout.write('\n$blue[Tekan ENTER untuk melanjutkan...]$reset');
  stdin.readLineSync();
}
