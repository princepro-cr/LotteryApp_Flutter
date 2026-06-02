import 'package:LuckyDip/core/app_colors.dart';
import 'package:flutter/material.dart';
 
class SpinDrum extends StatefulWidget {
  final int? number;
  final bool isSpinning;
  final bool isWinner;

  const SpinDrum({
    super.key,
    this.number,
    this.isSpinning = false,
    this.isWinner = false,
  });

  @override
  State<SpinDrum> createState() => _SpinDrumState();
}

class _SpinDrumState extends State<SpinDrum> with SingleTickerProviderStateMixin {
  late AnimationController _spinController;
  late Animation<double> _spinAnimation;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _spinAnimation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(parent: _spinController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void didUpdateWidget(SpinDrum oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSpinning && !oldWidget.isSpinning) {
      _spinController.forward(from: 0);
    }
    if (!widget.isSpinning && widget.number != null) {
      _spinController.stop();
    }
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor = AppColors.emeraldBorder;
    Color bgColor = AppColors.card;
    
    if (widget.isWinner) {
      borderColor = AppColors.gold;
      bgColor = AppColors.goldBg;
    } else if (widget.number != null) {
      borderColor = AppColors.emerald;
      bgColor = AppColors.emeraldBg;
    }

    return AnimatedBuilder(
      animation: _spinAnimation,
      builder: (context, child) {
        return Container(
          width: 55,
          height: 75,
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: borderColor, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Transform.translate(
              offset: Offset(0, widget.isSpinning ? _spinAnimation.value : 0),
              child: Text(
                widget.number?.toString() ?? '?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: widget.isWinner ? AppColors.goldDark : AppColors.emerald,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}