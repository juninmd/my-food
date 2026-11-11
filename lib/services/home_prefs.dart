import 'package:shared_preferences/shared_preferences.dart';
import 'package:webdiet/models/day_plan.dart';

/// What the home screen restores on launch.
class HomeSnapshot {
  final int water;
  final Map<MealSlot, int> mealIndex;
  final Set<String> checked;
  const HomeSnapshot(this.water, this.mealIndex, this.checked);
}

/// Device storage for the home screen. Keys are kept from earlier versions
/// so existing users keep their plan, water and shopping checks.
class HomePrefs {
  static const waterKey = 'water_glasses';
  static const checkedKey = 'checked_ingredients';

  static String mealKey(MealSlot slot) => '${slot.name}_index';

  Future<HomeSnapshot> load() async {
    final p = await SharedPreferences.getInstance();
    return HomeSnapshot(
      p.getInt(waterKey) ?? 0,
      {for (final s in MealSlot.values) s: p.getInt(mealKey(s)) ?? 0},
      (p.getStringList(checkedKey) ?? const []).toSet(),
    );
  }

  Future<void> saveWater(int glasses) async =>
      (await SharedPreferences.getInstance()).setInt(waterKey, glasses);

  Future<void> saveMeal(MealSlot slot, int index) async =>
      (await SharedPreferences.getInstance()).setInt(mealKey(slot), index);

  Future<void> saveChecked(Set<String> checked) async =>
      (await SharedPreferences.getInstance())
          .setStringList(checkedKey, checked.toList());
}
