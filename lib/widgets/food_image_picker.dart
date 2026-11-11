import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/theme/app_tokens.dart';
import 'package:webdiet/widgets/common/meal_plate.dart';
import 'package:webdiet/widgets/common/pressable.dart';

/// Live preview of the food: the plate follows the macros being typed,
/// or shows the photo. Tapping it picks a photo.
class FoodImagePicker extends StatelessWidget {
  final Uint8List? imageBytes;
  final VoidCallback onTap;
  final String pickImageText;
  final Listenable macros;
  final int Function() protein;
  final int Function() carbs;
  final int Function() fat;

  const FoodImagePicker({
    super.key,
    required this.imageBytes,
    required this.onTap,
    required this.pickImageText,
    required this.macros,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Pressable(
      onTap: onTap,
      semanticLabel: pickImageText,
      child: Column(children: [
        Stack(clipBehavior: Clip.none, children: [
          ListenableBuilder(
            listenable: macros,
            builder: (context, _) => MealPlate(
              protein: protein(),
              carbs: carbs(),
              fat: fat(),
              size: 120,
              image: imageBytes,
            ),
          ),
          Positioned(
            right: -4,
            bottom: -4,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: t.ink,
                shape: BoxShape.circle,
                border: Border.all(color: t.paper, width: 3),
              ),
              child: Icon(
                imageBytes == null
                    ? Icons.add_a_photo_outlined
                    : Icons.edit_outlined,
                size: 18,
                color: t.paper,
              ),
            ),
          ),
        ]),
        const SizedBox(height: 10),
        Text(
          imageBytes == null ? l10n.tapToBrowse : l10n.changePhoto,
          style: TextStyle(
              fontSize: 12, color: t.ink2, fontWeight: FontWeight.w600),
        ),
      ]),
    );
  }
}
