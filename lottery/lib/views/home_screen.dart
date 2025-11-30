import 'package:flutter/material.dart';
import 'package:lucky_dip/models/lottery_slip.dart';
import 'package:provider/provider.dart';
import '../view_models/lottery_view_model.dart';
import '../theme/app_colors.dart';
import '../utils/responsive_helper.dart';
import 'slip_entry_screen.dart';
import 'results_screen.dart';
import 'stats_screen.dart';
import 'quick_pick_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Lucky Dip Lottery',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isSmallScreen ? 20.0 : 24.0,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isSmallScreen ? Icons.bar_chart : Icons.leaderboard),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StatsScreen()),
              );
            },
            tooltip: 'View Statistics',
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<LotteryViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: ResponsiveHelper.getPadding(context),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenHeight - MediaQuery.of(context).padding.vertical,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Statistics Overview Card
                    _buildStatsOverview(context, viewModel),
                    
                    SizedBox(height: isSmallScreen ? 16.0 : 24.0),
                    
                    // Quick Actions Grid
                    _buildQuickActions(context),
                    
                    SizedBox(height: isSmallScreen ? 16.0 : 24.0),
                    
                    // Recent Slips Section - Only show if we have slips
                    if (viewModel.slips.isNotEmpty) 
                      _buildRecentSlips(context, viewModel),
                    
                    // Add some bottom padding
                    SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatsOverview(BuildContext context, LotteryViewModel viewModel) {
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppColors.cardShadow],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_awesome,
            size: isSmallScreen ? 32.0 : 40.0,
            color: AppColors.white,
          ),
          SizedBox(height: isSmallScreen ? 8.0 : 12.0),
          Text(
            'Lottery Dashboard',
            style: TextStyle(
              color: AppColors.white,
              fontSize: isSmallScreen ? 18.0 : 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isSmallScreen ? 12.0 : 16.0),
          _buildStatsGrid(context, viewModel),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, LotteryViewModel viewModel) {
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(
          context,
          'Slips',
          viewModel.slips.length.toString(),
          Icons.confirmation_number,
        ),
        _buildStatItem(
          context,
          'Cost',
          '\$${viewModel.totalCost.toStringAsFixed(0)}',
          Icons.attach_money,
        ),
        _buildStatItem(
          context,
          'Draws',
          viewModel.drawHistory.length.toString(),
          Icons.celebration,
        ),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, IconData icon) {
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isSmallScreen ? 40.0 : 50.0,
          height: isSmallScreen ? 40.0 : 50.0,
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.white, size: isSmallScreen ? 20.0 : 24.0),
        ),
        SizedBox(height: isSmallScreen ? 4.0 : 8.0),
        Text(
          value,
          style: TextStyle(
            color: AppColors.white,
            fontSize: isSmallScreen ? 14.0 : 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColors.white.withOpacity(0.8),
            fontSize: isSmallScreen ? 10.0 : 12.0,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);
    final crossAxisCount = isSmallScreen ? 2 : 3;
    final childAspectRatio = isSmallScreen ? 1.2 : 1.4;

    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: isSmallScreen ? 12.0 : 16.0,
        mainAxisSpacing: isSmallScreen ? 12.0 : 16.0,
        childAspectRatio: childAspectRatio,
      ),
      children: [
        _buildActionCard(
          context,
          Icons.add_circle,
          'Manual Entry',
          'Choose your numbers',
          AppColors.primary,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SlipEntryScreen()),
            );
          },
        ),
        _buildActionCard(
          context,
          Icons.shuffle,
          'Quick Pick',
          'Generate random slips',
          AppColors.primaryDark,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QuickPickScreen()),
            );
          },
        ),
        _buildActionCard(
          context,
          Icons.celebration,
          'Draw Now',
          'Check your luck',
          AppColors.success,
          () {
            final viewModel = context.read<LotteryViewModel>();
            if (viewModel.slips.isNotEmpty) {
              _performDraw(context, viewModel);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Please add at least one slip first'),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
        ),
        if (!isSmallScreen) _buildActionCard(
          context,
          Icons.history,
          'Past Results',
          'View draw history',
          AppColors.info,
          () {
            if (context.read<LotteryViewModel>().drawHistory.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StatsScreen()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('No draw history available'),
                  backgroundColor: AppColors.warning,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) {
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: isSmallScreen ? 28.0 : 32.0, color: color),
              SizedBox(height: isSmallScreen ? 6.0 : 8.0),
              Text(
                title,
                style: TextStyle(
                  fontSize: isSmallScreen ? 12.0 : 14.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: isSmallScreen ? 2.0 : 4.0),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: isSmallScreen ? 9.0 : 10.0,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentSlips(BuildContext context, LotteryViewModel viewModel) {
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);
    final maxHeight = MediaQuery.of(context).size.height * 0.4;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Slips (${viewModel.slips.length})',
                style: TextStyle(
                  fontSize: isSmallScreen ? 14.0 : 16.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton.icon(
                onPressed: () => _showClearConfirmationDialog(context, viewModel),
                icon: Icon(Icons.clear_all, size: isSmallScreen ? 14.0 : 16.0),
                label: Text('Clear All', style: TextStyle(fontSize: isSmallScreen ? 12.0 : 14.0)),
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
              ),
            ],
          ),
        ),
        SizedBox(height: isSmallScreen ? 8.0 : 12.0),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: maxHeight,
            minHeight: 100,
          ),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: viewModel.slips.length,
                itemBuilder: (context, index) {
                  final slip = viewModel.slips[index];
                  return _buildSlipItem(context, slip, index + 1, viewModel);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSlipItem(BuildContext context, LotterySlip slip, int number, LotteryViewModel viewModel) {
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryExtraLight),
      ),
      child: ListTile(
        leading: Container(
          width: isSmallScreen ? 32.0 : 36.0,
          height: isSmallScreen ? 32.0 : 36.0,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: TextStyle(
                color: AppColors.white,
                fontSize: isSmallScreen ? 10.0 : 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(
          slip.formattedNumbers,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: isSmallScreen ? 10.0 : 12.0,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          '${slip.type} • ${_formatTime(slip.createdAt)}',
          style: TextStyle(
            fontSize: isSmallScreen ? 8.0 : 10.0,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline, size: isSmallScreen ? 16.0 : 18.0),
          onPressed: () => _showDeleteConfirmationDialog(context, viewModel, slip.id),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _performDraw(BuildContext context, LotteryViewModel viewModel) async {
    try {
      await viewModel.performDraw();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ResultsScreen()),
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

  void _showDeleteConfirmationDialog(BuildContext context, LotteryViewModel viewModel, int slipId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Slip'),
        content: const Text('Are you sure you want to delete this lottery slip?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              viewModel.removeSlip(slipId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Slip deleted successfully'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showClearConfirmationDialog(BuildContext context, LotteryViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Slips'),
        content: const Text('Are you sure you want to delete all lottery slips? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              viewModel.clearSlips();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('All slips cleared successfully'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}