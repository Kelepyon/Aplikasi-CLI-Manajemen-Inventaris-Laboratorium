// lib/services/inventory_service.dart

import '../models/item.dart';
import '../utils/file_helper.dart';

/// Hasil operasi service — membawa pesan sukses/error
class ServiceResult {
  final bool success;
  final String message;
  final dynamic data;

  ServiceResult({required this.success, required this.message, this.data});
}

class InventoryService {
  List<Item> _items = [];

  // ─────────────────────────────────────────────
  //  INISIALISASI
  // ─────────────────────────────────────────────

  Future<void> load() async {
    _items = await FileHelper.readItems();
  }

  Future<void> _save() async {
    await FileHelper.writeItems(_items);
  }

  // ─────────────────────────────────────────────
  //  TAMBAH BARANG
  // ─────────────────────────────────────────────

  Future<ServiceResult> addItem({
    required String id,
    required String name,
    required int quantity,
    required String condition,
    required String location,
  }) async {
    // Cek duplikat ID
    if (_findById(id) != null) {
      return ServiceResult(
        success: false,
        message: 'Kode "$id" sudah digunakan. Gunakan kode unik lain.',
      );
    }

    final newItem = Item(
      id: id.toUpperCase(),
      name: name,
      quantity: quantity,
      condition: condition,
      location: location,
    );

    _items.add(newItem);
    await _save();

    return ServiceResult(
      success: true,
      message: 'Barang "${newItem.name}" berhasil ditambahkan.',
      data: newItem,
    );
  }

  // ─────────────────────────────────────────────
  //  LIHAT SEMUA BARANG
  // ─────────────────────────────────────────────

  List<Item> getAllItems({String sortBy = 'name'}) {
    final sorted = List<Item>.from(_items);
    if (sortBy == 'id') {
      sorted.sort((a, b) => a.id.compareTo(b.id));
    } else {
      sorted.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
    }
    return sorted;
  }

  int get totalItems => _items.length;

  // ─────────────────────────────────────────────
  //  CARI BARANG
  // ─────────────────────────────────────────────

  List<Item> searchItems(String query) {
    final q = query.toLowerCase().trim();
    return _items.where((item) {
      return item.name.toLowerCase().contains(q) ||
          item.id.toLowerCase().contains(q);
    }).toList();
  }

  // ─────────────────────────────────────────────
  //  UPDATE BARANG
  // ─────────────────────────────────────────────

  Future<ServiceResult> updateItem(
    String id, {
    int? quantity,
    String? condition,
    String? location,
  }) async {
    final item = _findById(id.toUpperCase());
    if (item == null) {
      return ServiceResult(
        success: false,
        message: 'Barang dengan kode "$id" tidak ditemukan.',
      );
    }

    if (quantity != null) item.quantity = quantity;
    if (condition != null) item.condition = condition;
    if (location != null) item.location = location;

    await _save();
    return ServiceResult(
      success: true,
      message: 'Barang "${item.name}" berhasil diperbarui.',
      data: item,
    );
  }

  // ─────────────────────────────────────────────
  //  HAPUS BARANG
  // ─────────────────────────────────────────────

  Future<ServiceResult> deleteItem(String id) async {
    final item = _findById(id.toUpperCase());
    if (item == null) {
      return ServiceResult(
        success: false,
        message: 'Barang dengan kode "$id" tidak ditemukan.',
      );
    }

    _items.remove(item);
    await _save();
    return ServiceResult(
      success: true,
      message: 'Barang "${item.name}" berhasil dihapus.',
    );
  }

  // ─────────────────────────────────────────────
  //  HELPER PRIVAT
  // ─────────────────────────────────────────────

  Item? _findById(String id) {
    try {
      return _items.firstWhere((e) => e.id == id.toUpperCase());
    } catch (_) {
      return null;
    }
  }
}
