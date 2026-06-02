import 'package:LuckyDip/core/app_constants.dart';
import 'package:flutter/material.dart';
import 'lottery_ball.dart';
 
class NumberGrid extends StatelessWidget {
  final List<int> selectedNumbers;
  final List<int> hotNumbers;
  final Function(int) onNumberTap;

  const NumberGrid({
    super.key,
    required this.selectedNumbers,
    required this.hotNumbers,
    required this.onNumberTap,
  });

  @override
  Widget build(BuildContext context) {
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
        final isSelected = selectedNumbers.contains(number);
        final isHot = hotNumbers.contains(number);
        
        return LotteryBall(
          number: number,
          isSelected: isSelected,
          isHot: isHot,
          onTap: () => onNumberTap(number),
        );
      },
    );
  }
}