import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/parcel_form_provider.dart';
import '../widgets/step_location.dart';
import '../widgets/step_details.dart';
import '../widgets/step_owner.dart';
import '../widgets/step_residents.dart';
import '../widgets/step_uploads.dart';
import '../widgets/step_summary.dart';

class NewParcelScreen extends ConsumerStatefulWidget {
  const NewParcelScreen({super.key});

  @override
  ConsumerState<NewParcelScreen> createState() => _NewParcelScreenState();
}

class _NewParcelScreenState extends ConsumerState<NewParcelScreen> {
  final PageController _pageController = PageController();

  final List<String> _stepTitles = [
    'Localisation',
    'Détails',
    'Propriétaire',
    'Occupants',
    'Photos',
    'Validation'
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    final current = ref.read(parcelFormProvider).currentStep;
    if (current < _stepTitles.length - 1) {
      ref.read(parcelFormProvider.notifier).nextStep();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Implement final submission
      _handleSubmit();
    }
  }

  void _handleSubmit() {
    // Show success dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Succès'),
        content: const Text('La fiche de recensement a été transmise avec succès.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              ref.read(parcelFormProvider.notifier).reset();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  void _back() {
    final current = ref.read(parcelFormProvider).currentStep;
    if (current > 0) {
      ref.read(parcelFormProvider.notifier).prevStep();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = ref.watch(parcelFormProvider).currentStep;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouveau Recensement'),
        leading: IconButton(
          icon: const Icon(LucideIcons.x),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Step Progress Bar
          _buildProgressIndicator(currentStep),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                StepLocation(),
                StepDetails(),
                StepOwner(),
                StepResidents(),
                StepUploads(),
                StepSummary(),
              ],
            ),
          ),
          // Bottom Navigation
          _buildBottomNav(currentStep),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(int current) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_stepTitles.length, (index) {
              final isActive = index <= current;
              final isCurrent = index == current;
              return Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isCurrent ? AppTheme.accentGold : (isActive ? AppTheme.primaryBlue : Colors.slate.shade200),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isActive ? Colors.white : Colors.slate.shade500,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    if (index < _stepTitles.length - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: index < current ? AppTheme.primaryBlue : Colors.slate.shade200,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
            _stepTitles[current],
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(int current) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          if (current > 0) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: _back,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Retour'),
              ),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _next,
              child: Text(current == _stepTitles.length - 1 ? 'Terminer' : 'Continuer'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderStep(String title) {
    return Center(child: Text(title));
  }
}
