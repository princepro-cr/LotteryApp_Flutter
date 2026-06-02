import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/stats_viewmodel.dart';
import '../core/app_colors.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StatsViewModel>(
      builder: (context, vm, child) {
        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your Stats', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildStatsCards(vm),
              const SizedBox(height: 24),
              const Text('Hot Numbers (Global)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildHotNumbersChart(vm),
              const SizedBox(height: 24),
              const Text('Your Favourite Picks', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildFavoriteNumbersChart(vm),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsCards(StatsViewModel vm) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.emeraldBorder),
            ),
            child: Column(
              children: [
                Text(vm.userStats['drawsPlayed']?.toString() ?? '0', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.emerald)),
                const SizedBox(height: 2),
                const Text('Draws Played', style: TextStyle(fontSize: 11, color: AppColors.textSub)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.emeraldBorder),
            ),
            child: Column(
              children: [
                Text(vm.userStats['wins']?.toString() ?? '0', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.emerald)),
                const SizedBox(height: 2),
                const Text('Wins', style: TextStyle(fontSize: 11, color: AppColors.textSub)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHotNumbersChart(StatsViewModel vm) {
    final data = vm.getTopHotNumbers();
    
    if (data.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.emeraldBorder),
        ),
        child: const Center(child: Text('No draw data yet', style: TextStyle(fontSize: 12, color: AppColors.textSub))),
      );
    }

    final maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.emeraldBorder),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.map((entry) {
                final height = (entry.value / maxValue) * 80;
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(entry.value.toString(), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.emerald)),
                      const SizedBox(height: 2),
                      Container(height: height, decoration: const BoxDecoration(color: AppColors.emeraldBorder, borderRadius: BorderRadius.vertical(top: Radius.circular(4)))),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: data.map((entry) {
              return Expanded(
                child: Text(entry.key.toString(), textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textSub)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteNumbersChart(StatsViewModel vm) {
    final data = vm.getTopFavoriteNumbers();
    
    if (data.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.emeraldBorder),
        ),
        child: const Center(child: Text('Place bets to see your picks', style: TextStyle(fontSize: 12, color: AppColors.textSub))),
      );
    }

    final maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.emeraldBorder),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.map((entry) {
                final height = (entry.value / maxValue) * 80;
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(entry.value.toString(), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.emerald)),
                      const SizedBox(height: 2),
                      Container(height: height, decoration: const BoxDecoration(color: AppColors.emeraldBorder, borderRadius: BorderRadius.vertical(top: Radius.circular(4)))),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: data.map((entry) {
              return Expanded(
                child: Text(entry.key.toString(), textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textSub)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}