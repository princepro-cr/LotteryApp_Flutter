import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/pick_viewmodel.dart';
import '../core/app_colors.dart';
import '../core/app_constants.dart';

class PickScreen extends StatelessWidget {
  const PickScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PickViewModel>(
      builder: (context, vm, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildJackpotBanner(),
              const SizedBox(height: 16),
              _buildBetSlip(vm),
              const SizedBox(height: 16),
              _buildActionButtons(context, vm),
              const SizedBox(height: 16),
              _buildHotLegend(),
              const SizedBox(height: 12),
              _buildNumberGrid(vm),  // ← Fixed: Added the number grid builder
            ],
          ),
        );
      },
    );
  }

  Widget _buildJackpotBanner() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0A5538), Color(0xFF0D6B47)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'JACKPOT',
                style: TextStyle(fontSize: 11, color: Colors.white70),
              ),
              const Text(
                'R 4,200,000',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD4A017),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Fri 6 Jun 2026',
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
              const Text(
                '20:00 SAST',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD4A017),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBetSlip(PickViewModel vm) {
    if (vm.selectedNumbers.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.emeraldBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.emeraldBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Select 6 numbers',
              style: TextStyle(fontSize: 14),
            ),
            const Icon(Icons.edit, color: AppColors.emerald),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.emeraldBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.emeraldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Bet Slip',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: vm.clearSlip,
                child: const Icon(Icons.clear, size: 20, color: AppColors.emerald),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: List.generate(6, (index) {
              final number = index < vm.selectedNumbers.length
                  ? vm.selectedNumbers[index]
                  : null;
              return Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: number != null ? AppColors.emerald : AppColors.background,
                  border: Border.all(
                    color: number != null ? AppColors.emerald : AppColors.emeraldBorder,
                    width: 1.5,
                  ),
                  boxShadow: number != null
                      ? [
                          BoxShadow(
                            color: AppColors.emerald.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    number?.toString() ?? '${index + 1}',
                    style: TextStyle(
                      color: number != null ? Colors.white : AppColors.textSub,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, PickViewModel vm) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: vm.quickPick,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4A017),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('🎲 Quick Pick'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton(
            onPressed: vm.clearSlip,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.emerald,
              side: const BorderSide(color: AppColors.emerald),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Clear'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: vm.canPlaceBet
                ? () async {
                    final success = await vm.placeBet();
                    if (success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Bet placed! Go to Draw tab'),
                          backgroundColor: AppColors.emerald,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.emerald,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: vm.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Place Bet →'),
          ),
        ),
      ],
    );
  }

  Widget _buildHotLegend() {
    return const Row(
      children: [
        SizedBox(
          width: 10,
          height: 10,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFFD4A017),
              shape: BoxShape.circle,
            ),
          ),
        ),
        SizedBox(width: 6),
        Text(
          'Highlighted = hot numbers (drawn often)',
          style: TextStyle(fontSize: 12, color: Color(0xFF4A7A62)),
        ),
      ],
    );
  }

  Widget _buildNumberGrid(PickViewModel vm) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 1,
      ),
      itemCount: AppConstants.numberRangeMax,
      itemBuilder: (context, index) {
        final number = index + 1;
        final isSelected = vm.selectedNumbers.contains(number);
        final isHot = vm.hotNumbers.contains(number);
        
        return GestureDetector(
          onTap: () => vm.toggleNumber(number),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? AppColors.emerald
                  : (isHot ? AppColors.goldBg : AppColors.card),
              border: Border.all(
                color: isSelected
                    ? AppColors.emerald
                    : (isHot ? AppColors.gold : AppColors.emeraldBorder),
                width: 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.emerald.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : (isHot ? AppColors.goldDark : AppColors.text),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}