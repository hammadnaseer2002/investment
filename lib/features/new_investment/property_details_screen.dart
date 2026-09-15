import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/validators.dart';
import '../../widgets/bottom_action_bar.dart';
import '../../widgets/progress_stepper.dart';
import 'purchase_costs_screen.dart';
import 'new_investment_provider.dart';
import '../../core/theme/app_colors.dart';

class PropertyDetailsScreen extends ConsumerStatefulWidget {
  const PropertyDetailsScreen({super.key});

  @override
  ConsumerState<PropertyDetailsScreen> createState() =>
      _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends ConsumerState<PropertyDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  String _propertyType = 'House';
  String _propertyStatus = 'Ready to Move';
  final _locationCtrl = TextEditingController();
  final _sizeCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill from state if returning
    final inv = ref.read(newInvestmentProvider);
    _propertyType = inv.propertyType.isEmpty ? 'House' : inv.propertyType;
    _locationCtrl.text = inv.location;
    _sizeCtrl.text = inv.size?.toString() ?? '';
    _notesCtrl.text = inv.notes;
  }

  @override
  void dispose() {
    _locationCtrl.dispose();
    _sizeCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (!_formKey.currentState!.validate()) return;

    // Save to provider
    ref.read(newInvestmentProvider.notifier).updatePropertyDetails(
          type: _propertyType,
          status: _propertyStatus,
          location: _locationCtrl.text,
          size: double.tryParse(_sizeCtrl.text),
          notes: _notesCtrl.text,
        );

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const PurchaseCostsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(' Property Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const ProgressStepper(
            currentStep: 0,
            steps: [
              'Property',
              'Purchase',
              'Finance',
              'Rental',
              'Expenses',
              'Review'
            ],
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const Text('Property Details',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkNavy)),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _propertyType,
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: AppColors.textSecondary),
                    decoration:
                        const InputDecoration(labelText: 'Property Type'),
                    items: const ['House', 'Apartment', 'Shop', 'Plot', 'Other']
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (v) =>
                        setState(() => _propertyType = v ?? _propertyType),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _propertyStatus,
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: AppColors.textSecondary),
                    decoration:
                        const InputDecoration(labelText: 'Property Status'),
                    items: const [
                      'Ready to Move',
                      'Under Construction',
                      'On Plan'
                    ]
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (v) =>
                        setState(() => _propertyStatus = v ?? _propertyStatus),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _locationCtrl,
                    validator: Validators.requiredField,
                    decoration: const InputDecoration(
                      labelText: 'Location',
                      suffixIcon: Icon(Icons.location_on_outlined,
                          color: AppColors.primaryBlue),
                      hintText: 'Enter location',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _sizeCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'Property Size (Optional)',
                        hintText: ' 100x100 Sqft'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notesCtrl,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Description (Optional)',
                      hintText: 'e.g. Corner house, near main road...',
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          BottomActionBar(onNext: _next),
        ],
      ),
    );
  }
}
