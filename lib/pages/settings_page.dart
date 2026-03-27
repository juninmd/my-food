import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _caloriesController.text = (prefs.getInt('target_calories') ?? 2430).toString();
      _proteinController.text = (prefs.getInt('target_protein') ?? 150).toString();
      _carbsController.text = (prefs.getInt('target_carbs') ?? 300).toString();
      _fatsController.text = (prefs.getInt('target_fats') ?? 70).toString();
    });
  }

  Future<void> _saveSettings() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('target_calories', int.parse(_caloriesController.text));
      await prefs.setInt('target_protein', int.parse(_proteinController.text));
      await prefs.setInt('target_carbs', int.parse(_carbsController.text));
      await prefs.setInt('target_fats', int.parse(_fatsController.text));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.settingsSavedMessage),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context, true); // Return true to indicate changes were saved
      }
    }
  }

  @override
  void dispose() {
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.settingsTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settingsDietaryPreferences,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),

                _buildNumberField(
                  controller: _caloriesController,
                  label: l10n.settingsTargetCalories,
                  icon: Icons.local_fire_department_outlined,
                ),
                const SizedBox(height: 16),

                _buildNumberField(
                  controller: _proteinController,
                  label: l10n.settingsTargetProtein,
                  icon: Icons.fitness_center_outlined,
                ),
                const SizedBox(height: 16),

                _buildNumberField(
                  controller: _carbsController,
                  label: l10n.settingsTargetCarbs,
                  icon: Icons.bakery_dining_outlined,
                ),
                const SizedBox(height: 16),

                _buildNumberField(
                  controller: _fatsController,
                  label: l10n.settingsTargetFats,
                  icon: Icons.water_drop_outlined,
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveSettings,
                    child: Text(l10n.settingsSaveButton),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a value';
        }
        if (int.tryParse(value) == null || int.parse(value) <= 0) {
          return 'Please enter a valid positive number';
        }
        return null;
      },
    );
  }
}
