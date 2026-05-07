// lib/utils/file_helper.dart

import 'dart:convert';
import 'dart:io';

import '../models/item.dart';

class FileHelper {
  static const String _dataPath = 'data/inventory.json';

  /// Pastikan folder data/ ada
  static Future<void> _ensureDirectory() async {
    final dir = Directory('data');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
  }

  /// Baca semua item dari file JSON
  static Future<List<Item>> readItems() async {
    await _ensureDirectory();

    final file = File(_dataPath);
    if (!await file.exists()) {
      return [];
    }

    try {
      final contents = await file.readAsString();
      if (contents.trim().isEmpty) return [];

      final List<dynamic> jsonList = jsonDecode(contents) as List<dynamic>;
      return jsonList
          .map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('[FileHelper] Gagal membaca file: $e');
      return [];
    }
  }

  /// Tulis semua item ke file JSON (overwrite)
  static Future<bool> writeItems(List<Item> items) async {
    await _ensureDirectory();

    try {
      final file = File(_dataPath);
      final jsonString = const JsonEncoder.withIndent(
        '  ',
      ).convert(items.map((e) => e.toJson()).toList());
      await file.writeAsString(jsonString);
      return true;
    } catch (e) {
      print('[FileHelper] Gagal menulis file: $e');
      return false;
    }
  }
}
