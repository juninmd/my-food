import 'package:webdiet/models/day_plan.dart';

enum SlotStatus { done, next, later }

enum DayPart { morning, afternoon, evening }

/// Turns the wall clock into meal status and greeting period.
class DayClock {
  DayClock._();

  /// A meal counts as done one hour after its planned time. The first meal
  /// that is not done is the next one; the rest come later.
  static Map<MealSlot, SlotStatus> statuses(DateTime now) {
    final minutes = now.hour * 60 + now.minute;
    final result = <MealSlot, SlotStatus>{};
    var nextAssigned = false;
    for (final slot in MealSlot.values) {
      final doneAt = slot.hour * 60 + slot.minute + 60;
      if (minutes >= doneAt) {
        result[slot] = SlotStatus.done;
      } else if (!nextAssigned) {
        result[slot] = SlotStatus.next;
        nextAssigned = true;
      } else {
        result[slot] = SlotStatus.later;
      }
    }
    return result;
  }

  static DayPart period(DateTime now) {
    if (now.hour < 12) return DayPart.morning;
    if (now.hour < 18) return DayPart.afternoon;
    return DayPart.evening;
  }
}
