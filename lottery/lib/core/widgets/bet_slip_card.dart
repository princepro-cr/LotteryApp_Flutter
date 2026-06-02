import 'package:LuckyDip/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'lottery_ball.dart';
 
class BetSlipCard extends StatelessWidget {
  final List<int> numbers;
  final VoidCallback? onClear;
  final bool isCompact;

  const BetSlipCard({
    super.key,
    required this.numbers,
    this.onClear,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
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
              Text(
                'Your Numbers',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.emeraldDark,
                  letterSpacing: 0.5,
                ),
              ),
              if (onClear != null)
                GestureDetector(
                  onTap: onClear,
                  child: const Icon(Icons.clear, size: 18, color: AppColors.emerald),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: numbers.map((number) {
              return LotteryBall(
                number: number,
                size: isCompact ? 36 : 40,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}