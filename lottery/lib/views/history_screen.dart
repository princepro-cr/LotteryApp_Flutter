import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/history_viewmodel.dart';
import '../core/app_colors.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryViewModel>(
      builder: (context, vm, child) {
        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (vm.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 64, color: AppColors.emeraldBorder),
                SizedBox(height: 16),
                Text('No bets yet', style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Text('Place your first bet in the Pick tab', style: TextStyle(fontSize: 12, color: AppColors.textSub)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: vm.refresh,
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: vm.bets.length,
            itemBuilder: (context, index) => _buildHistoryItem(vm, index),
          ),
        );
      },
    );
  }

  Widget _buildHistoryItem(HistoryViewModel vm, int index) {
    final bet = vm.bets[index];
    final isPending = bet.drawnNumbers == null;
    final isWin = bet.isWin;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.emeraldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(vm.formatDate(bet.datePlaced), style: const TextStyle(fontSize: 12, color: AppColors.textSub)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: isPending ? AppColors.emeraldBg : (isWin ? const Color(0xFFFDF6E3) : AppColors.emeraldBg),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isPending ? 'Pending' : (isWin ? 'Win' : 'No win'),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isPending ? AppColors.emerald : (isWin ? const Color(0xFFB8860B) : AppColors.red),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            children: bet.numbers.map((number) => Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: bet.drawnNumbers != null && bet.drawnNumbers!.contains(number) 
                    ? AppColors.emerald 
                    : AppColors.background,
                border: Border.all(color: AppColors.emeraldBorder),
              ),
              child: Center(child: Text(number.toString(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
            )).toList(),
          ),
          if (bet.drawnNumbers != null) ...[
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 6),
            const Text('DRAWN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textSub)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              children: bet.drawnNumbers!.map((number) => Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: bet.numbers.contains(number) ? AppColors.emerald : AppColors.background,
                  border: Border.all(color: AppColors.emeraldBorder),
                ),
                child: Center(child: Text(number.toString(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }
}