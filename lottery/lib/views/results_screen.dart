import 'package:flutter/material.dart';
import 'package:lucky_dip/models/lottery_draw.dart';
import 'package:provider/provider.dart';
import '../view_models/lottery_view_model.dart';
import '../theme/app_colors.dart';
import '../utils/responsive_helper.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LotteryViewModel>();
    final draw = viewModel.currentDraw;

    if (draw == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Draw Results'),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No draw results available',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Draw Results',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Winning Numbers Section
            _buildWinningNumbersSection(context, draw),
            
            // Results List
            Expanded(
              child: _buildResultsSection(context, draw),
            ),
            
            // Action Button
            _buildActionButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWinningNumbersSection(BuildContext context, LotteryDraw draw) {
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.success, Colors.green[700]!],
        ),
        boxShadow: [AppColors.cardShadow],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.emoji_events,
            size: isSmallScreen ? 32.0 : 40.0,
            color: AppColors.white,
          ),
          SizedBox(height: isSmallScreen ? 8.0 : 12.0),
          Text(
            'Winning Numbers',
            style: TextStyle(
              color: AppColors.white,
              fontSize: isSmallScreen ? 20.0 : 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isSmallScreen ? 12.0 : 16.0),
          Wrap(
            spacing: isSmallScreen ? 8.0 : 12.0,
            children: draw.winningNumbers.map((number) {
              return Container(
                width: isSmallScreen ? 40.0 : 50.0,
                height: isSmallScreen ? 40.0 : 50.0,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    number.toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14.0 : 18.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: isSmallScreen ? 8.0 : 12.0),
          Text(
            'Drawn: ${_formatDateTime(draw.drawnAt)}',
            style: TextStyle(
              color: Colors.white70,
              fontSize: isSmallScreen ? 12.0 : 14.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsSection(BuildContext context, LotteryDraw draw) {
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);
    
    return Padding(
      padding: EdgeInsets.all(isSmallScreen ? 12.0 : 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.assignment, color: AppColors.primary, size: isSmallScreen ? 18.0 : 20.0),
              SizedBox(width: isSmallScreen ? 6.0 : 8.0),
              Text(
                'Your Results (${draw.results.length} slips)',
                style: TextStyle(
                  fontSize: isSmallScreen ? 16.0 : 18.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 12.0 : 16.0),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: draw.results.length,
              itemBuilder: (context, index) {
                final result = draw.results[index];
                return _buildResultCard(context, result, index + 1);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, LotteryResult result, int slipNumber) {
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);
    
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: isSmallScreen ? 8.0 : 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
        child: Row(
          children: [
            // Match Count Badge
            Container(
              width: isSmallScreen ? 40.0 : 50.0,
              height: isSmallScreen ? 40.0 : 50.0,
              decoration: BoxDecoration(
                color: _getPrizeColor(result.prize),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  result.matchedNumbers.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 14.0 : 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: isSmallScreen ? 12.0 : 16.0),
            // Slip Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Slip $slipNumber',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: isSmallScreen ? 12.0 : 14.0,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 2.0 : 4.0),
                  Text(
                    result.slip.numbers.map((n) => n.toString().padLeft(2, '0')).join(' - '),
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: isSmallScreen ? 10.0 : 12.0,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 2.0 : 4.0),
                  Text(
                    '${result.matchedNumbers} numbers matched',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 10.0 : 12.0,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Prize Badge
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 8.0 : 12.0, 
                vertical: isSmallScreen ? 4.0 : 6.0
              ),
              decoration: BoxDecoration(
                color: _getPrizeColor(result.prize).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _getPrizeColor(result.prize).withOpacity(0.3)),
              ),
              child: Text(
                result.prize,
                style: TextStyle(
                  fontSize: isSmallScreen ? 10.0 : 12.0,
                  fontWeight: FontWeight.bold,
                  color: _getPrizeColor(result.prize),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);
    
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16.0 : 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.home, size: isSmallScreen ? 18.0 : 20.0),
          label: Text(
            'Back to Home',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 14.0 : 16.0,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12.0 : 16.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Color _getPrizeColor(String prize) {
    switch (prize) {
      case 'Jackpot!':
        return Colors.amber;
      case 'Second Prize':
        return Colors.blue;
      case 'Third Prize':
        return AppColors.success;
      case 'Fourth Prize':
        return AppColors.primary;
      default:
        return Colors.grey;
    }
  }
}