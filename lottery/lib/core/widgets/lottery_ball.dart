import 'package:LuckyDip/core/app_colors.dart';
import 'package:flutter/material.dart';
 
class LotteryBall extends StatelessWidget {
  final int number;
  final double size;
  final bool isSelected;
  final bool isHot;
  final bool isMatch;
  final VoidCallback? onTap;

  const LotteryBall({
    super.key,
    required this.number,
    this.size = 36,
    this.isSelected = false,
    this.isHot = false,
    this.isMatch = false,
    this.onTap,
  });

  Color get _backgroundColor {
    if (isMatch) return AppColors.gold;
    if (isSelected) return AppColors.emerald;
    if (isHot) return AppColors.goldBg;
    return AppColors.card;
  }

  Color get _borderColor {
    if (isMatch) return AppColors.gold;
    if (isSelected) return AppColors.emerald;
    if (isHot) return AppColors.gold;
    return AppColors.emeraldBorder;
  }

  Color get _textColor {
    if (isMatch || isSelected) return Colors.white;
    if (isHot) return AppColors.goldDark;
    return AppColors.text;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: _backgroundColor,
          shape: BoxShape.circle,
          border: Border.all(color: _borderColor, width: 1.5),
          boxShadow: (isSelected || isMatch)
              ? [
                  BoxShadow(
                    color: (isMatch ? AppColors.gold : AppColors.emerald)
                        .withOpacity(0.3),
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
              color: _textColor,
              fontWeight: FontWeight.w700,
              fontSize: size * 0.4,
            ),
          ),
        ),
      ),
    );
  }
}