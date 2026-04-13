import 'package:flutter/material.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';
import 'package:my_food/widgets/food_image_picker.dart';
import 'package:my_food/widgets/food_form_fields.dart';
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
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FoodImagePicker(
              imageBytes: imageBytes,
              onTap: onPickImage,
              pickImageText: l10n.pickImageButton,
            ),
            const SizedBox(height: 24),
            buildTextField(
              context: context,
              controller: nameController,
              label: l10n.foodNameLabel,
              validator: (val) => val == null || val.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            buildTextField(
              context: context,
              controller: descController,
              label: l10n.foodDescriptionLabel,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: buildTextField(context: context, controller: calController, label: l10n.foodCaloriesLabel, keyboardType: TextInputType.number)),
                const SizedBox(width: 16),
                Expanded(child: buildTextField(context: context, controller: proteinController, label: l10n.foodProteinLabel, keyboardType: TextInputType.number)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: buildTextField(context: context, controller: carbsController, label: l10n.foodCarbsLabel, keyboardType: TextInputType.number)),
                const SizedBox(width: 16),
                Expanded(child: buildTextField(context: context, controller: fatController, label: l10n.foodFatLabel, keyboardType: TextInputType.number)),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              child: Text(
                l10n.saveFoodButton,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
