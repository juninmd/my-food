import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/widgets/food_form_fields.dart';
import 'package:webdiet/widgets/food_form_section.dart';

class FoodFormBasicFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descController;

  const FoodFormBasicFields({
    super.key,
    required this.nameController,
    required this.descController,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FoodFormSection(
      title: l10n.basicDetails,
      icon: Icons.info_outline,
      children: [
        buildTextField(
          context: context,
          controller: nameController,
          label: l10n.foodNameLabel,
          prefixIcon: Icons.fastfood_outlined,
          validator: (val) =>
              val == null || val.isEmpty ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        buildTextField(
          context: context,
          controller: descController,
          label: l10n.foodDescriptionLabel,
          prefixIcon: Icons.description_outlined,
          maxLines: 3,
        ),
      ],
    );
  }
}
