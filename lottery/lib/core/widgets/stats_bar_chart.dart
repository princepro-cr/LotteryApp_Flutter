import 'package:LuckyDip/core/app_colors.dart';
import 'package:flutter/material.dart';
 
class StatsBarChart extends StatelessWidget {
  final List<MapEntry<int, int>> data;
  final String emptyMessage;

  const StatsBarChart({
    super.key,
    required this.data,
    this.emptyMessage = 'No data available',
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Container(
        height: 120,
        alignment: Alignment.center,
        child: Text(
          emptyMessage,
          style: const TextStyle(fontSize: 12, color: AppColors.textSub),
        ),
      );
    }

    final maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return Column(
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
                    Text(
                      entry.value.toString(),
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: AppColors.emerald,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      height: height,
                      decoration: const BoxDecoration(
                        color: AppColors.emeraldBorder,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ),
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
              child: Text(
                entry.key.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSub,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}