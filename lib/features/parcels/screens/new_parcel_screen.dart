import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parcello_mobile/core/theme/app_theme.dart';
import 'package:parcello_mobile/features/parcels/providers/parcel_form_provider.dart';
import 'package:parcello_mobile/features/parcels/widgets/step_location.dart';
import 'package:parcello_mobile/features/parcels/widgets/step_details.dart';
import 'package:parcello_mobile/features/parcels/widgets/step_owner.dart';
import 'package:parcello_mobile/features/parcels/widgets/step_residents.dart';
import 'package:parcello_mobile/features/parcels/widgets/step_uploads.dart';
import 'package:parcello_mobile/features/parcels/widgets/step_summary.dart';
import 'package:parcello_mobile/features/dashboard/providers/stats_repository.dart';

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

  Future<void> _handleSubmit() async {
    final success = await ref.read(parcelFormProvider.notifier).submit();
    
    if (!mounted) return;

    final state = ref.read(parcelFormProvider);
    
    if (success) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Succès'),
          content: Text(state.error ?? 'La fiche de recensement a été transmise avec succès.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                ref.read(parcelFormProvider.notifier).reset();
                Navigator.of(context).pop(); // Pop dialog
                Navigator.of(context).pop(); // Pop screen
                ref.refresh(statsProvider); // Refresh dashboard stats
              },
              child: const Text('Ok'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.error ?? 'Une erreur est survenue lors de l\'envoi.'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    }
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
    final formState = ref.watch(parcelFormProvider);
    final currentStep = formState.currentStep;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouveau Recensement'),
        leading: IconButton(
          icon: Icon(LucideIcons.x),
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
          _buildBottomNav(currentStep, formState.isSubmitting),
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
                        color: isCurrent ? AppTheme.accentGold : (isActive ? AppTheme.primaryBlue : const Color(0xFFE2E8F0)),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isActive ? Colors.white : const Color(0xFF64748B),
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
                          color: index < current ? AppTheme.primaryBlue : const Color(0xFFE2E8F0),
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

  Widget _buildBottomNav(int current, bool isSubmitting) {
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
                onPressed: isSubmitting ? null : _back,
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
              onPressed: isSubmitting ? null : _next,
              child: isSubmitting 
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text(current == _stepTitles.length - 1 ? 'Terminer' : 'Continuer'),
            ),
          ),
        ],
      ),
    );
  }
}
