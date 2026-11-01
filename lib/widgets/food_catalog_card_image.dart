import 'dart:convert';
import 'package:flutter/material.dart';

class FoodCatalogCardImage extends StatelessWidget {
  final String? imageBase64;
  final ColorScheme colorScheme;
  final int calories;

  const FoodCatalogCardImage({
    super.key,
    required this.imageBase64,
    required this.colorScheme,
    required this.calories,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
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
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.local_fire_department_rounded,
                  size: 14,
                  color: Colors.orange.shade800,
                ),
                const SizedBox(width: 4),
                Text(
                  '$calories kcal',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
