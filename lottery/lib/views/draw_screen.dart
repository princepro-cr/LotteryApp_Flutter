import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/draw_viewmodel.dart';
import '../core/app_colors.dart';

class DrawScreen extends StatelessWidget {
  const DrawScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DrawViewModel>(
      builder: (context, vm, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMyNumbers(vm),
              const SizedBox(height: 20),
              const Text('Draw Spin', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildDrums(vm),
              const SizedBox(height: 20),
              if (vm.lastDrawNumbers != null) _buildResult(vm),
              const SizedBox(height: 20),
              _buildSpinButton(vm),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMyNumbers(DrawViewModel vm) {
    if (!vm.hasBet) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.emeraldBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.emeraldBorder),
        ),
        child: const Column(
          children: [
            Icon(Icons.info_outline, size: 32, color: AppColors.emerald),
            SizedBox(height: 8),
            Text('No active bet', style: TextStyle(fontSize: 14)),
            SizedBox(height: 4),
            Text('Place a bet in the Pick tab first', style: TextStyle(fontSize: 12, color: AppColors.textSub)),
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
          const Text('My Numbers', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.emeraldDark)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            children: vm.currentBet.map((number) => Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.emerald,
                boxShadow: const [BoxShadow(color: Color(0x4D0D6B47), blurRadius: 8, offset: Offset(0, 2))],
              ),
              child: Center(child: Text(number.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDrums(DrawViewModel vm) {
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(6, (index) {
          final number = vm.lastDrawNumbers != null && index < vm.lastDrawNumbers!.length 
              ? vm.lastDrawNumbers![index] 
              : null;
          final isWinner = number != null && vm.currentBet.contains(number);
          
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 75,
              decoration: BoxDecoration(
                color: number != null ? (isWinner ? const Color(0xFFFDF6E3) : AppColors.emeraldBg) : AppColors.card,
                border: Border.all(
                  color: isWinner ? const Color(0xFFD4A017) : (number != null ? AppColors.emerald : AppColors.emeraldBorder),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: vm.isSpinning && number == null
                    ? const SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        number?.toString() ?? '?',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isWinner ? const Color(0xFFB8860B) : AppColors.emerald,
                        ),
                      ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildResult(DrawViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: vm.isWin ? const Color(0xFFFDF6E3) : AppColors.emeraldBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: vm.isWin ? const Color(0xFFD4A017) : AppColors.emeraldBorder),
      ),
      child: Column(
        children: [
          Text(
            vm.resultMessage ?? '',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: vm.isWin ? const Color(0xFFB8860B) : AppColors.emerald,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'You matched ${vm.matchCount} of 6 numbers',
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSpinButton(DrawViewModel vm) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: vm.isSpinning || !vm.hasBet ? null : vm.performDraw,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.emerald,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(
          vm.isSpinning ? 'DRAWING...' : 'SPIN THE DRAW',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}