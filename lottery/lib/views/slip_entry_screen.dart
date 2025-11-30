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

class _SlipEntryScreenState extends State<SlipEntryScreen> {
  final List<int?> _selectedNumbers = List.filled(6, null);
  int _currentIndex = 0;

  void _selectNumber(int number) {
    setState(() {
      if (!_selectedNumbers.contains(number)) {
        _selectedNumbers[_currentIndex] = number;
        if (_currentIndex < 5) {
          _currentIndex++;
        }
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedNumbers.fillRange(0, 6, null);
      _currentIndex = 0;
    });
  }

  void _removeLastNumber() {
    setState(() {
      if (_currentIndex > 0) {
        _currentIndex--;
        _selectedNumbers[_currentIndex] = null;
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Create Lottery Slip',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: isSmallScreen ? 18.0 : 20.0),
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
      padding: EdgeInsets.all(isSmallScreen ? 16.0 : 20.0),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress Bar
          LinearProgressIndicator(
            value: _currentIndex / 6,
            backgroundColor: Colors.white.withOpacity(0.3),
            color: Colors.amber,
            borderRadius: BorderRadius.circular(10),
            minHeight: isSmallScreen ? 6.0 : 8.0,
          ),
          SizedBox(height: isSmallScreen ? 16.0 : 20.0),
          // Progress Text
          Text(
            'Select Number ${_currentIndex + 1} of 6',
            style: TextStyle(
              color: Colors.white,
              fontSize: isSmallScreen ? 18.0 : 20.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isSmallScreen ? 4.0 : 8.0),
          Text(
            'Choose unique numbers from 1 to 49',
            style: TextStyle(
              color: Colors.white70,
              fontSize: isSmallScreen ? 12.0 : 14.0,
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
      margin: EdgeInsets.all(isSmallScreen ? 12.0 : 20.0),
      padding: EdgeInsets.all(isSmallScreen ? 16.0 : 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppColors.cardShadow],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Your Selected Numbers',
            style: TextStyle(
              fontSize: isSmallScreen ? 14.0 : 16.0,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: isSmallScreen ? 12.0 : 16.0),
          Wrap(
            spacing: isSmallScreen ? 8.0 : 12.0,
            runSpacing: isSmallScreen ? 8.0 : 12.0,
            children: List.generate(6, (index) {
              final isCurrent = index == _currentIndex;
              final number = _selectedNumbers[index];
              
              return Container(
                width: isSmallScreen ? 40.0 : 50.0,
                height: isSmallScreen ? 40.0 : 50.0,
                decoration: BoxDecoration(
                  color: isCurrent ? Colors.amber : 
                         number != null ? AppColors.primary : Colors.grey[200],
                  shape: BoxShape.circle,
                  border: isCurrent ? Border.all(color: Colors.orange, width: 2) : null,
                ),
                child: Center(
                  child: Text(
                    number?.toString() ?? '?',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14.0 : 18.0,
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
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12.0 : 16.0),
      child: Column(
        children: [
          // Quick Actions
          _buildQuickActions(context),
          
          SizedBox(height: isSmallScreen ? 12.0 : 16.0),
          
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
          child: OutlinedButton.icon(
            icon: Icon(Icons.backspace, size: isSmallScreen ? 14.0 : 16.0),
            label: Text('Remove Last', style: TextStyle(fontSize: isSmallScreen ? 12.0 : 14.0)),
            onPressed: _currentIndex > 0 ? _removeLastNumber : null,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        SizedBox(width: isSmallScreen ? 8.0 : 12.0),
        Expanded(
          child: OutlinedButton.icon(
            icon: Icon(Icons.clear, size: isSmallScreen ? 14.0 : 16.0),
            label: Text('Clear All', style: TextStyle(fontSize: isSmallScreen ? 12.0 : 14.0)),
            onPressed: _currentIndex > 0 ? _clearSelection : null,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.warning,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
        crossAxisSpacing: isSmallScreen ? 4.0 : 6.0,
        mainAxisSpacing: isSmallScreen ? 4.0 : 6.0,
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
            borderRadius: BorderRadius.circular(8),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey[300]!,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected ? [AppColors.buttonShadow] : null,
              ),
              child: Center(
                child: Text(
                  number.toString(),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14.0 : 16.0,
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
      padding: EdgeInsets.all(isSmallScreen ? 16.0 : 20.0),
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
                padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12.0 : 16.0),
                foregroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
              ),
              child: Text('Cancel', style: TextStyle(fontSize: isSmallScreen ? 14.0 : 16.0)),
            ),
          ),
          SizedBox(width: isSmallScreen ? 12.0 : 16.0),
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
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12.0 : 16.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: isSmallScreen ? 18.0 : 20.0),
                  SizedBox(width: isSmallScreen ? 6.0 : 8.0),
                  Text(
                    'Submit Slip',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 14.0 : 16.0,
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