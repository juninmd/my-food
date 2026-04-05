import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_food/models/food.dart';
import 'package:my_food/services/food_service.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';

class FoodFormPage extends StatefulWidget {
  final Food? food;

  const FoodFormPage({super.key, this.food});

  @override
  State<FoodFormPage> createState() => _FoodFormPageState();
}

class _FoodFormPageState extends State<FoodFormPage> {
  final _formKey = GlobalKey<FormState>();
  final FoodService _foodService = FoodService();

  late TextEditingController _nameController;
  late TextEditingController _caloriesController;
  late TextEditingController _proteinController;
  late TextEditingController _carbsController;
  late TextEditingController _fatController;
  String _selectedCategory = 'Other';
  String _imagePath = '';

  final List<String> _categories = [
    'Dairy & Eggs',
    'Fruits & Vegetables',
    'Meat & Poultry',
    'Grains & Bread',
    'Pantry',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    final food = widget.food;
    _nameController = TextEditingController(text: food?.name ?? '');
    _caloriesController = TextEditingController(text: food?.calories.toString() ?? '');
    _proteinController = TextEditingController(text: food?.protein.toString() ?? '');
    _carbsController = TextEditingController(text: food?.carbs.toString() ?? '');
    _fatController = TextEditingController(text: food?.fat.toString() ?? '');

    if (food != null && _categories.contains(food.category)) {
      _selectedCategory = food.category;
    }
    _imagePath = food?.imagePath ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  void _deleteFood() async {
    if (widget.food != null) {
      await _foodService.deleteFood(widget.food!.id);
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  void _saveFood() async {
    if (_formKey.currentState!.validate()) {
      final newFood = Food(
        id: widget.food?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        category: _selectedCategory,
        calories: int.tryParse(_caloriesController.text) ?? 0,
        protein: int.tryParse(_proteinController.text) ?? 0,
        carbs: int.tryParse(_carbsController.text) ?? 0,
        fat: int.tryParse(_fatController.text) ?? 0,
        imagePath: _imagePath.isEmpty ? 'assets/images/lanche.jpg' : _imagePath,
      );

      await _foodService.saveFood(newFood);
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumber = false, bool isRequired = false, required AppLocalizations l10n}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: isRequired ? (val) => val == null || val.isEmpty ? l10n.foodRequiredField : null : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.food != null;

    Widget imagePreview;
    if (_imagePath.isNotEmpty && !_imagePath.startsWith('assets/')) {
      imagePreview = Image.file(File(_imagePath), fit: BoxFit.cover);
    } else {
      imagePreview = Image.asset('assets/images/lanche.jpg', fit: BoxFit.cover);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? l10n.foodCatalogEdit : l10n.foodCatalogAdd,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: isEditing
            ? [
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(l10n.foodCatalogEdit),
                        content: Text(l10n.foodDeleteConfirm),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              _deleteFood();
                            },
                            child: const Text('Delete', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                )
              ]
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (_imagePath.isNotEmpty) imagePreview,
                        if (_imagePath.isEmpty)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo, size: 40, color: Colors.grey.shade400),
                              const SizedBox(height: 8),
                              Text(l10n.foodAddPhoto, style: TextStyle(color: Colors.grey.shade500)),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildTextField(_nameController, l10n.foodNameLabel, isRequired: true, l10n: l10n),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(labelText: l10n.foodCategoryLabel),
                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) => setState(() => _selectedCategory = val!),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField(_caloriesController, l10n.foodCaloriesLabel, isNumber: true, isRequired: true, l10n: l10n)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField(_proteinController, l10n.foodProteinLabel, isNumber: true, l10n: l10n)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField(_carbsController, l10n.foodCarbsLabel, isNumber: true, l10n: l10n)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField(_fatController, l10n.foodFatLabel, isNumber: true, l10n: l10n)),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(onPressed: _saveFood, child: Text(l10n.foodSaveButton)),
            ],
          ),
        ),
      ),
    );
  }
}
