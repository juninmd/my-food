import 'dart:typed_data';
import 'package:flutter/material.dart';

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

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.2),
            style: BorderStyle.solid, // Use solid line simulating dashed or soft border
            width: 1.5,
          ),
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
                  Icon(Icons.add_photo_alternate_outlined,
                      size: 48, color: colorScheme.primary.withValues(alpha: 0.6)),
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
    );
  }
}
