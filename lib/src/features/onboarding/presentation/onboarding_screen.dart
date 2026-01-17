import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrify/src/features/authentication/presentation/firebase_auth_controller.dart';
import 'package:nutrify/src/features/onboarding/domain/user_profile_model.dart';
import 'package:nutrify/src/features/onboarding/presentation/onboarding_controller.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _weightController = TextEditingController();
  final _targetWeightController = TextEditingController();
  
  DateTime? _selectedDate; 
  UserGoal _selectedGoal = UserGoal.maintenance;
  Sex _selectedSex = Sex.masculine;

  @override
  void dispose() {
    for (var c in [_nameController, _lastNameController, _weightController, _targetWeightController]) {
      c.dispose();
    }
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    return "$day/$month/$year";
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final profile = UserProfileModel(
        firstName: _nameController.text.trim(), 
        lastName: _lastNameController.text.trim(), 
        dateOfBirth: _selectedDate!, 
        weight: double.tryParse(_weightController.text) ?? 0.0, 
        targetWeight: _selectedGoal == UserGoal.maintenance
          ? null
          : double.tryParse(_targetWeightController.text), 
        sex: _selectedSex, 
        userGoal: _selectedGoal,
        isOnboardingComplete: true,
      );

      ref.read(onboardingControllerProvider.notifier).completeOnboarding(profile);
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your date of birth')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingControllerProvider);
    final authState = ref.watch(firebaseAuthControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tell us about yourself'),
        actions: [
          IconButton(
            onPressed: authState.isLoading 
                ? null 
                : () => ref.read(firebaseAuthControllerProvider.notifier).signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name', border: OutlineInputBorder()),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Date of Birth',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        _selectedDate == null 
                            ? 'Select' 
                            : _formatDate(_selectedDate!), // Uso del helper manual
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<Sex>(
                    initialValue: _selectedSex, 
                    decoration: const InputDecoration(labelText: 'Sex', border: OutlineInputBorder()),
                    items: Sex.values.map((sex) {
                      return DropdownMenuItem<Sex>(
                        value: sex,
                        child: Text(sex == Sex.masculine ? 'Masculine' : 'Femenine'),
                      );
                    }).toList(),
                    onChanged: (Sex? value) {
                      if (value != null) setState(() => _selectedSex = value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _weightController,
              decoration: const InputDecoration(labelText: 'Current weight (kg)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 24),
            const Text('What is your goal?', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SegmentedButton<UserGoal>(
              segments: const [
                ButtonSegment(value: UserGoal.loseWeight, label: Text('Lose')),
                ButtonSegment(value: UserGoal.maintenance, label: Text('Maintain')),
                ButtonSegment(value: UserGoal.gainWeight, label: Text('Gain')),
              ],
              selected: {_selectedGoal},
              onSelectionChanged: (value) => setState(() => _selectedGoal = value.first),
            ),
            const SizedBox(height: 16),
            
            if (_selectedGoal != UserGoal.maintenance)
              TextFormField(
                controller: _targetWeightController,
                decoration: const InputDecoration(
                  labelText: 'Target weight (kg)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.flag_outlined),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => (_selectedGoal != UserGoal.maintenance && (v == null || v.isEmpty)) 
                    ? 'Enter your goal weight' : null,
              ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: state.isLoading ? null : _submit,
              child: state.isLoading 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                  : const Text('Finish Registration'),
            ),
          ],
        ),
      ),
    );
  }
}