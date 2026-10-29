import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/widgets/food_image_picker.dart';
import 'package:webdiet/widgets/food_form_basic_fields.dart';
import 'package:webdiet/widgets/food_form_nutrition_fields.dart';
import 'dart:typed_data';

class FoodFormBody extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descController;
  final TextEditingController calController;
  final TextEditingController proteinController;
  final TextEditingController carbsController;
  final TextEditingController fatController;
  final Uint8List? imageBytes;
  final VoidCallback onPickImage;
  final VoidCallback onSave;

  const FoodFormBody({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.descController,
    required this.calController,
    required this.proteinController,
    required this.carbsController,
    required this.fatController,
    required this.imageBytes,
    required this.onPickImage,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      // Productive layout spacing (WebDiet inspired)
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile-style header integrating image and basic details
            FoodImagePicker(
              imageBytes: imageBytes,
              onTap: onPickImage,
              pickImageText: l10n.pickImageButton,
            ),
            const SizedBox(height: 24),
            FoodFormBasicFields(
              nameController: nameController,
              descController: descController,
            ),
            const SizedBox(height: 24),
            FoodFormNutritionFields(
              calController: calController,
              proteinController: proteinController,
              carbsController: carbsController,
              fatController: fatController,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onSave,
                icon: const Icon(Icons.check),
                label: Text(
                  l10n.saveFoodButton,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
