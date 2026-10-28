import 'dart:convert';
import 'package:flutter/material.dart';

class FoodCatalogCardImage extends StatelessWidget {
  final String? imageBase64;
  final ColorScheme colorScheme;

  const FoodCatalogCardImage({
    super.key,
    required this.imageBase64,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
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
