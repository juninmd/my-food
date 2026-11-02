import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

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
              borderRadius: BorderRadius.circular(24),
            ),
            clipBehavior: Clip.antiAlias,
            child: imageBytes == null
                ? DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(24),
                    dashPattern: const [8, 4],
                    color: colorScheme.primary.withValues(alpha: 0.5),
                    strokeWidth: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.cloud_upload_outlined,
                                  size: 40, color: colorScheme.primary),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              pickImageText,
                              style: TextStyle(
                                  color: colorScheme.primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Tap to browse or take a photo",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.memory(
                        imageBytes!,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.4),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        if (imageBytes != null)
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton.extended(
              heroTag: 'food_image_edit',
              onPressed: onTap,
              backgroundColor: colorScheme.surface,
              elevation: 4,
              icon: Icon(Icons.edit_outlined, color: colorScheme.primary, size: 20),
              label: Text(
                "Change",
                style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ],
    );
  }
}
