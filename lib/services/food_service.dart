import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/food_item.dart';

class FoodService {
  static const String _storageKey = 'custom_foods';
  static const String _backupKey = 'custom_foods_backup';

  Future<List<FoodItem>> getFoods() async {
    final prefs = await SharedPreferences.getInstance();
    final foods = <FoodItem>[];
    // Skip a malformed entry instead of dropping the whole catalog.
    for (final item in _decode(prefs.getString(_storageKey)) ?? const []) {
      try {
        foods.add(FoodItem.fromJson(item as Map<String, dynamic>));
      } catch (_) {
        continue;
      }
    }
    return foods;
  }

  Future<void> saveFood(FoodItem food) async {
    await _update((entries) {
      final index = entries.indexWhere((e) => _idOf(e) == food.id);
      if (index >= 0) {
        entries[index] = food.toJson();
      } else {
        entries.add(food.toJson());
      }
    });
  }

  Future<void> deleteFood(String id) async {
    await _update((entries) => entries.removeWhere((e) => _idOf(e) == id));
  }

  /// Edits the raw stored list, so entries this version cannot parse are written
  /// back untouched; a payload that is not a list is backed up before the overwrite.
  Future<void> _update(void Function(List<dynamic> entries) change) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    var entries = _decode(raw);
    if (entries == null) {
      if (raw != null) await prefs.setString(_backupKey, raw);
      entries = [];
    }
    change(entries);
    await prefs.setString(_storageKey, json.encode(entries));
  }

  static List<dynamic>? _decode(String? raw) {
    if (raw == null) return [];
    try {
      final decoded = json.decode(raw);
      return decoded is List ? List<dynamic>.of(decoded) : null;
    } catch (_) {
      return null;
    }
  }

  static Object? _idOf(Object? entry) => entry is Map ? entry['id'] : null;
}
