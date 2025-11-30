import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/lottery_view_model.dart';
import '../theme/app_colors.dart';
import '../utils/responsive_helper.dart';

class SlipEntryScreen extends StatefulWidget {
  const SlipEntryScreen({super.key});

  @override
  State<SlipEntryScreen> createState() => _SlipEntryScreenState();
}

class _SlipEntryScreenState extends State<SlipEntryScreen> with SingleTickerProviderStateMixin {
  final List<int?> _selectedNumbers = List.filled(6, null);
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _progressAnimation = Tween<double>(begin: 0, end: _currentIndex / 6).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectNumber(int number) {
    setState(() {
      if (!_selectedNumbers.contains(number)) {
        _selectedNumbers[_currentIndex] = number;
        if (_currentIndex < 5) {
          _currentIndex++;
        }
        _progressAnimation = Tween<double>(begin: 0, end: _currentIndex / 6).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
        );
        _animationController.forward(from: 0);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedNumbers.fillRange(0, 6, null);
      _currentIndex = 0;
      _progressAnimation = Tween<double>(begin: 0, end: 0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      );
      _animationController.forward(from: 0);
    });
  }

  void _removeLastNumber() {
    setState(() {
      if (_currentIndex > 0) {
        _currentIndex--;
        _selectedNumbers[_currentIndex] = null;
        _progressAnimation = Tween<double>(begin: 0, end: _currentIndex / 6).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
        );
        _animationController.forward(from: 0);
      }
    });
  }

  bool _isNumberSelected(int number) {
    return _selectedNumbers.contains(number);
  }

  bool _canSubmit() {
    return _selectedNumbers.every((number) => number != null) &&
        _selectedNumbers.toSet().length == 6;
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Create Lottery Slip',
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: isSmallScreen ? 18.0 : 20.0
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Section
            _buildProgressSection(context),
            
            // Selected Numbers Display
            _buildNumbersDisplay(context),
            
            // Number Grid
            Expanded(
              child: _buildNumberGridSection(context),
            ),
            
            // Action Buttons
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 20.0 : 24.0),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress Indicator
          Stack(
            children: [
              Container(
                height: isSmallScreen ? 8.0 : 10.0,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return Container(
                    height: isSmallScreen ? 8.0 : 10.0,
                    width: MediaQuery.of(context).size.width * 0.8 * _progressAnimation.value,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.amber, Colors.orange],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 16.0 : 20.0),
          Text(
            'Select Number ${_currentIndex + 1} of 6',
            style: TextStyle(
              color: Colors.white,
              fontSize: isSmallScreen ? 20.0 : 22.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isSmallScreen ? 6.0 : 8.0),
          Text(
            'Choose unique numbers from 1 to 49',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: isSmallScreen ? 14.0 : 16.0,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNumbersDisplay(BuildContext context) {
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);
    
    return Container(
      margin: EdgeInsets.all(isSmallScreen ? 16.0 : 20.0),
      padding: EdgeInsets.all(isSmallScreen ? 20.0 : 24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.confirmation_number, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'Your Selected Numbers',
                style: TextStyle(
                  fontSize: isSmallScreen ? 16.0 : 18.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 16.0 : 20.0),
          Wrap(
            spacing: isSmallScreen ? 10.0 : 12.0,
            runSpacing: isSmallScreen ? 10.0 : 12.0,
            children: List.generate(6, (index) {
              final isCurrent = index == _currentIndex;
              final number = _selectedNumbers[index];
              
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: isSmallScreen ? 48.0 : 56.0,
                height: isSmallScreen ? 48.0 : 56.0,
                decoration: BoxDecoration(
                  color: isCurrent ? Colors.amber : 
                         number != null ? AppColors.primary : Colors.grey[200],
                  shape: BoxShape.circle,
                  border: isCurrent ? Border.all(color: Colors.orange, width: 3) : null,
                  boxShadow: [
                    if (number != null || isCurrent)
                      BoxShadow(
                        color: (isCurrent ? Colors.amber : AppColors.primary).withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                  ],
                ),
                child: Center(
                  child: Text(
                    number?.toString() ?? '?',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16.0 : 18.0,
                      fontWeight: FontWeight.bold,
                      color: number != null ? Colors.white : Colors.grey[600],
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

  Widget _buildNumberGridSection(BuildContext context) {
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 16.0 : 20.0),
      child: Column(
        children: [
          // Quick Actions
          _buildQuickActions(context),
          
          SizedBox(height: isSmallScreen ? 16.0 : 20.0),
          
          // Number Grid
          Expanded(
            child: _buildNumberGrid(context),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);
    
    return Row(
      children: [
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _currentIndex > 0 ? _removeLastNumber : null,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12.0 : 14.0),
                decoration: BoxDecoration(
                  color: _currentIndex > 0 ? AppColors.error.withOpacity(0.1) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _currentIndex > 0 ? AppColors.error.withOpacity(0.3) : Colors.grey[300]!,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.backspace, 
                      size: isSmallScreen ? 16.0 : 18.0,
                      color: _currentIndex > 0 ? AppColors.error : Colors.grey[400],
                    ),
                    SizedBox(width: isSmallScreen ? 6.0 : 8.0),
                    Text(
                      'Remove Last',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12.0 : 14.0,
                        color: _currentIndex > 0 ? AppColors.error : Colors.grey[400],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: isSmallScreen ? 12.0 : 16.0),
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _currentIndex > 0 ? _clearSelection : null,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12.0 : 14.0),
                decoration: BoxDecoration(
                  color: _currentIndex > 0 ? AppColors.warning.withOpacity(0.1) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _currentIndex > 0 ? AppColors.warning.withOpacity(0.3) : Colors.grey[300]!,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.clear, 
                      size: isSmallScreen ? 16.0 : 18.0,
                      color: _currentIndex > 0 ? AppColors.warning : Colors.grey[400],
                    ),
                    SizedBox(width: isSmallScreen ? 6.0 : 8.0),
                    Text(
                      'Clear All',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12.0 : 14.0,
                        color: _currentIndex > 0 ? AppColors.warning : Colors.grey[400],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberGrid(BuildContext context) {
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);
    final crossAxisCount = isSmallScreen ? 7 : 8;
    final childAspectRatio = isSmallScreen ? 1.0 : 1.1;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: isSmallScreen ? 6.0 : 8.0,
        mainAxisSpacing: isSmallScreen ? 6.0 : 8.0,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: 49,
      itemBuilder: (context, index) {
        final number = index + 1;
        final isSelected = _isNumberSelected(number);
        
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _selectNumber(number),
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey[300]!,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ] : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  )
                ],
              ),
              child: Center(
                child: Text(
                  number.toString(),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16.0 : 18.0,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);
    
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 20.0 : 24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 16.0 : 18.0),
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
          SizedBox(width: isSmallScreen ? 16.0 : 20.0),
          Expanded(
            child: ElevatedButton(
              onPressed: _canSubmit()
                  ? () {
                      try {
                        final viewModel = context.read<LotteryViewModel>();
                        viewModel.addSlip(_selectedNumbers.cast<int>());
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Lottery slip added successfully!'),
                            backgroundColor: AppColors.success,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $e'),
                            backgroundColor: AppColors.error,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _canSubmit() ? AppColors.success : Colors.grey[400],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 16.0 : 18.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: _canSubmit() ? 4 : 0,
                shadowColor: _canSubmit() ? AppColors.success.withOpacity(0.3) : Colors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle, 
                    size: isSmallScreen ? 20.0 : 22.0,
                    color: Colors.white,
                  ),
                  SizedBox(width: isSmallScreen ? 8.0 : 12.0),
                  Text(
                    'Submit Slip',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 16.0 : 18.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}