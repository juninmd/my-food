import 'dart:convert';
import 'package:flutter/material.dart';

class FoodCatalogCardImage extends StatelessWidget {
  final String? imageBase64;

  const FoodCatalogCardImage({super.key, this.imageBase64});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        image: imageBase64 != null
            ? DecorationImage(
                image: MemoryImage(base64Decode(imageBase64!)),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: imageBase64 == null
          ? Icon(
              Icons.fastfood_outlined,
              color: colorScheme.primary,
              size: 48,
            )
          : null,
    );
  }
}
