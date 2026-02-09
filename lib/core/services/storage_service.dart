import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storageProvider = Provider((ref) => StorageService());

class StorageService {
  static const String _boxName = 'fair_adda_box';
  
  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
  }

  Box get _box => Hive.box(_boxName);

  // Generic Get/Set
  Future<void> save(String key, dynamic value) async => await _box.put(key, value);
  dynamic read(String key) => _box.get(key);
  Future<void> delete(String key) async => await _box.delete(key);

  // Specific Use Cases
  bool get isDarkMode => _box.get('isDarkMode', defaultValue: true);
  Future<void> setDarkMode(bool value) => save('isDarkMode', value);

  List<String> get searchHistory => _box.get('searchHistory', defaultValue: <String>[]);
}