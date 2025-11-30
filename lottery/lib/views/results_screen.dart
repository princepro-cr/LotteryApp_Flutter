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
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Draw Results'),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: ResponsiveHelper.getPadding(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.emoji_events_outlined, size: 80, color: AppColors.textDisabled),
                SizedBox(height: 20),
                Text(
                  'No Draw Results',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Perform a draw to see results here',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                  ),
                  child: const Text('Back to Home'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
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
    final totalWon = draw.results.fold<double>(0, (sum, result) {
      final prize = _getPrizeAmount(result.prize);
      return sum + prize;
    });
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 20.0 : 24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.success, Color(0xFF2E7D32)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.emoji_events,
              size: isSmallScreen ? 28.0 : 32.0,
              color: AppColors.white,
            ),
          ),
          SizedBox(height: isSmallScreen ? 12.0 : 16.0),
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
            spacing: isSmallScreen ? 10.0 : 12.0,
            children: draw.winningNumbers.map((number) {
              return Container(
                width: isSmallScreen ? 44.0 : 52.0,
                height: isSmallScreen ? 44.0 : 52.0,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    number.toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16.0 : 18.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: isSmallScreen ? 12.0 : 16.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.celebration, size: 16, color: AppColors.white),
                SizedBox(width: 8),
                Text(
                  'Total Won: R${totalWon.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: isSmallScreen ? 14.0 : 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isSmallScreen ? 8.0 : 12.0),
          Text(
            'Drawn: ${_formatDateTime(draw.drawnAt)}',
            style: TextStyle(
              color: AppColors.white.withOpacity(0.8),
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
      padding: EdgeInsets.all(isSmallScreen ? 16.0 : 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.assignment, color: AppColors.primary, size: isSmallScreen ? 18.0 : 20.0),
              ),
              SizedBox(width: isSmallScreen ? 8.0 : 12.0),
              Text(
                'Your Results (${draw.results.length} slips)',
                style: TextStyle(
                  fontSize: isSmallScreen ? 18.0 : 20.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 16.0 : 20.0),
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
    final prizeAmount = _getPrizeAmount(result.prize);
    
    return Card(
      elevation: 3,
      margin: EdgeInsets.only(bottom: isSmallScreen ? 12.0 : 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 16.0 : 20.0),
        child: Row(
          children: [
            // Match Count Badge
            Container(
              width: isSmallScreen ? 50.0 : 60.0,
              height: isSmallScreen ? 50.0 : 60.0,
              decoration: BoxDecoration(
                gradient: _getPrizeGradient(result.prize),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _getPrizeColor(result.prize).withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      result.matchedNumbers.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 18.0 : 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'match',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: isSmallScreen ? 9.0 : 10.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: isSmallScreen ? 16.0 : 20.0),
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
                      fontSize: isSmallScreen ? 14.0 : 16.0,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 4.0 : 6.0),
                  Text(
                    result.slip.numbers.map((n) => n.toString().padLeft(2, '0')).join(' - '),
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: isSmallScreen ? 12.0 : 14.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 4.0 : 6.0),
                  Row(
                    children: [
                      Icon(Icons.emoji_events, size: 14, color: _getPrizeColor(result.prize)),
                      SizedBox(width: 4),
                      Text(
                        'R${prizeAmount.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 12.0 : 14.0,
                          fontWeight: FontWeight.bold,
                          color: _getPrizeColor(result.prize),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Prize Badge
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 12.0 : 16.0, 
                vertical: isSmallScreen ? 6.0 : 8.0
              ),
              decoration: BoxDecoration(
                color: _getPrizeColor(result.prize).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _getPrizeColor(result.prize).withOpacity(0.3)),
              ),
              child: Text(
                result.prize,
                style: TextStyle(
                  fontSize: isSmallScreen ? 11.0 : 12.0,
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
      padding: EdgeInsets.all(isSmallScreen ? 20.0 : 24.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.home, size: isSmallScreen ? 20.0 : 22.0),
          label: Text(
            'Back to Home',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 16.0 : 18.0,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 16.0 : 18.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
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

  Gradient _getPrizeGradient(String prize) {
    final color = _getPrizeColor(prize);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [color, Color.alphaBlend(color.withOpacity(0.7), color)],
    );
  }

  double _getPrizeAmount(String prize) {
    switch (prize) {
      case 'Jackpot!':
        return 10000;
      case 'Second Prize':
        return 5000;
      case 'Third Prize':
        return 1000;
      case 'Fourth Prize':
        return 100;
      default:
        return 0;
    }
  }
}