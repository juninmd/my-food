import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';
import 'package:my_food/models/food_item.dart';
import 'package:my_food/services/food_service.dart';
import 'package:my_food/widgets/food_form_body.dart';

class FoodFormPage extends StatefulWidget {
  final FoodItem? foodToEdit;

  const FoodFormPage({super.key, this.foodToEdit});

  @override
  State<FoodFormPage> createState() => _FoodFormPageState();
}

class _FoodFormPageState extends State<FoodFormPage> {
  final _formKey = GlobalKey<FormState>();
  final FoodService _foodService = FoodService();

  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _calController;
  late TextEditingController _proteinController;
  late TextEditingController _carbsController;
  late TextEditingController _fatController;

  String? _imageBase64;
  Uint8List? _imageBytes;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final food = widget.foodToEdit;
    _nameController = TextEditingController(text: food?.name ?? '');
    _descController = TextEditingController(text: food?.description ?? '');
    _calController = TextEditingController(text: food?.calories.toString() ?? '');
    _proteinController = TextEditingController(text: food?.protein.toString() ?? '');
    _carbsController = TextEditingController(text: food?.carbs.toString() ?? '');
    _fatController = TextEditingController(text: food?.fat.toString() ?? '');
    _imageBase64 = food?.imageBase64;
    if (_imageBase64 != null) {
      _imageBytes = base64Decode(_imageBase64!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _calController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _imageBase64 = base64Encode(bytes);
      });
    }
  }

  void _saveFood() async {
    if (_formKey.currentState!.validate()) {
      final newFood = FoodItem(
        id: widget.foodToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        calories: int.tryParse(_calController.text) ?? 0,
        protein: int.tryParse(_proteinController.text) ?? 0,
        carbs: int.tryParse(_carbsController.text) ?? 0,
        fat: int.tryParse(_fatController.text) ?? 0,
        imageBase64: _imageBase64,
      );

      await _foodService.saveFood(newFood);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEditing = widget.foodToEdit != null;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: true,
            pinned: true,
            backgroundColor: colorScheme.surface,
            iconTheme: IconThemeData(color: colorScheme.onSurface),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
              title: Text(
                isEditing ? l10n.editFoodTitle : l10n.addFoodTitle,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: FoodFormBody(
              formKey: _formKey,
              nameController: _nameController,
              descController: _descController,
              calController: _calController,
              proteinController: _proteinController,
              carbsController: _carbsController,
              fatController: _fatController,
              imageBytes: _imageBytes,
              onPickImage: _pickImage,
              onSave: _saveFood,
            ),
          ),
        ],
      ),
    );
  }
}
