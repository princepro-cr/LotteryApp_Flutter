import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/lottery_view_model.dart';
import '../theme/app_colors.dart';
import '../utils/responsive_helper.dart';

class QuickPickScreen extends StatefulWidget {
  const QuickPickScreen({super.key});

  @override
  State<QuickPickScreen> createState() => _QuickPickScreenState();
}

class _QuickPickScreenState extends State<QuickPickScreen> with SingleTickerProviderStateMixin {
  int _slipCount = 1;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _animateCountChange() {
    _animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Quick Pick',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isSmallScreen ? 18.0 : 20.0,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: ResponsiveHelper.getPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Section
              _buildHeaderSection(context),
              
              SizedBox(height: isSmallScreen ? 24.0 : 32.0),
              
              // Slip Count Selector
              _buildCountSelector(),
              
              SizedBox(height: isSmallScreen ? 24.0 : 32.0),
              
              // Cost Calculation
              _buildCostSection(),
              
              const Spacer(),
              
              // Action Buttons
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);
    
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 20.0 : 24.0),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shuffle,
              size: isSmallScreen ? 32.0 : 40.0,
              color: AppColors.white,
            ),
          ),
          SizedBox(height: isSmallScreen ? 12.0 : 16.0),
          Text(
            'Quick Pick Generator',
            style: TextStyle(
              fontSize: isSmallScreen ? 18.0 : 22.0,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          SizedBox(height: isSmallScreen ? 6.0 : 8.0),
          Text(
            'Generate random lottery slips instantly. Each slip costs R12.',
            style: TextStyle(
              fontSize: isSmallScreen ? 12.0 : 14.0,
              color: AppColors.white.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCountSelector() {
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 20.0 : 24.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.confirmation_number, color: AppColors.primary, size: 20),
                SizedBox(width: isSmallScreen ? 8.0 : 12.0),
                Text(
                  'Number of Slips',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16.0 : 18.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: isSmallScreen ? 16.0 : 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCountButton(Icons.remove, () {
                  setState(() {
                    if (_slipCount > 1) _slipCount--;
                    _animateCountChange();
                  });
                }),
                SizedBox(width: isSmallScreen ? 16.0 : 20.0),
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: isSmallScreen ? 70.0 : 80.0,
                    height: isSmallScreen ? 70.0 : 80.0,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _slipCount.toString(),
                        style: TextStyle(
                          fontSize: isSmallScreen ? 22.0 : 26.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: isSmallScreen ? 16.0 : 20.0),
                _buildCountButton(Icons.add, () {
                  setState(() {
                    if (_slipCount < 10) _slipCount++;
                    _animateCountChange();
                  });
                }),
              ],
            ),
            SizedBox(height: isSmallScreen ? 12.0 : 16.0),
            Text(
              'Select between 1 and 10 slips',
              style: TextStyle(
                fontSize: isSmallScreen ? 11.0 : 12.0,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountButton(IconData icon, VoidCallback onPressed) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.white, size: 20),
        ),
      ),
    );
  }

  Widget _buildCostSection() {
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);
    final totalCost = _slipCount * 12;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 20.0 : 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.attach_money, size: 16, color: AppColors.textSecondary),
                    SizedBox(width: 6),
                    Text(
                      'Total Cost',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14.0 : 16.0,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  '$_slipCount slip${_slipCount > 1 ? 's' : ''} × R12.00',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 11.0 : 12.0,
                    color: AppColors.textDisabled,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'R${totalCost.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 22.0 : 26.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 11.0 : 12.0,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);
    
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              final viewModel = context.read<LotteryViewModel>();
              viewModel.addQuickPicks(_slipCount);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$_slipCount quick pick slip${_slipCount > 1 ? 's' : ''} added successfully!'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 16.0 : 18.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              shadowColor: AppColors.primary.withOpacity(0.3),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.auto_awesome, size: isSmallScreen ? 18.0 : 20.0),
                SizedBox(width: isSmallScreen ? 8.0 : 12.0),
                Text(
                  'Generate Slips',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isSmallScreen ? 16.0 : 18.0,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: isSmallScreen ? 12.0 : 16.0),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 14.0 : 16.0),
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              side: BorderSide(color: AppColors.primary, width: 2),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(fontSize: isSmallScreen ? 16.0 : 18.0),
            ),
          ),
        ),
      ],
    );
  }
}