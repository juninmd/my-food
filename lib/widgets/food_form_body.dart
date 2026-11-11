import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/widgets/food_form_basic_fields.dart';
import 'package:webdiet/widgets/food_form_nutrition_fields.dart';
import 'package:webdiet/widgets/food_image_picker.dart';

/// Layout of the food form: live plate on top, then details and
/// nutrition (side by side on wide screens), then Save.
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

  int _v(TextEditingController c) => int.tryParse(c.text) ?? 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final basic = FoodFormBasicFields(
        nameController: nameController, descController: descController);
    final nutrition = FoodFormNutritionFields(
      calController: calController,
      proteinController: proteinController,
      carbsController: carbsController,
      fatController: fatController,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Form(
            key: formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: FoodImagePicker(
                      imageBytes: imageBytes,
                      onTap: onPickImage,
                      pickImageText: l10n.pickImageButton,
                      macros: Listenable.merge(
                          [proteinController, carbsController, fatController]),
                      protein: () => _v(proteinController),
                      carbs: () => _v(carbsController),
                      fat: () => _v(fatController),
                    ),
                  ),
                  const SizedBox(height: 20),
                  LayoutBuilder(
                    builder: (context, c) => c.maxWidth > 700
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Expanded(child: basic),
                                const SizedBox(width: 16),
                                Expanded(child: nutrition),
                              ])
                        : Column(children: [
                            basic,
                            const SizedBox(height: 16),
                            nutrition
                          ]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: onSave,
                    icon: const Icon(Icons.check_rounded),
                    label: Text(l10n.saveFoodButton),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
