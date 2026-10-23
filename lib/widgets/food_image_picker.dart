import 'dart:typed_data';
import 'package:flutter/material.dart';

/// Widget responsável pela "Adição de fotos" nos alimentos customizados.
class FoodImagePicker extends StatelessWidget {
  final Uint8List? imageBytes;
  final VoidCallback onTap;
  final String pickImageText;

  const FoodImagePicker({
    super.key,
    required this.imageBytes,
    required this.onTap,
    required this.pickImageText,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 220, // Taller for hero feel
            width: double.infinity,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(24),
              image: imageBytes != null
                  ? DecorationImage(
                      image: MemoryImage(imageBytes!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageBytes == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt_outlined,
                          size: 64,
                          color: colorScheme.primary.withValues(alpha: 0.6)),
                      const SizedBox(height: 12),
                      Text(
                        pickImageText,
                        style: TextStyle(
                            color: colorScheme.primary.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                : null,
          ),
        ),
        if (imageBytes != null)
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton.small(
              heroTag: 'food_image_edit',
              onPressed: onTap,
              backgroundColor: colorScheme.surface,
              elevation: 4,
              child: Icon(Icons.edit_outlined, color: colorScheme.primary),
            ),
          ),
      ],
    );
  }
}
