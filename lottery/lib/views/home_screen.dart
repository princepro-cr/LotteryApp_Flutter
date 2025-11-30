import 'package:flutter/material.dart';
import 'package:lucky_dip/models/lottery_slip.dart';
import 'package:provider/provider.dart';
import 'package:flutter/animation.dart';
import 'package:confetti/confetti.dart';
import '../view_models/lottery_view_model.dart';
import '../theme/app_colors.dart';
import '../utils/responsive_helper.dart';
import 'slip_entry_screen.dart';
import 'results_screen.dart';
import 'stats_screen.dart';
import 'quick_pick_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late ConfettiController _confettiController;
  bool _showWelcome = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
    
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _showWelcome = false);
    });
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _celebrate() {
    _confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context, isSmallScreen),
      body: Stack(
        children: [
          SafeArea(
            child: Consumer<LotteryViewModel>(
              builder: (context, viewModel, child) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: ResponsiveHelper.getPadding(context),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Animated Header Section
                      _buildAnimatedHeader(context, viewModel),
                      
                      SizedBox(height: isSmallScreen ? 20.0 : 28.0),
                      
                      // Quick Stats Cards
                      _buildQuickStats(context, viewModel),
                      
                      SizedBox(height: isSmallScreen ? 20.0 : 28.0),
                      
                      // Quick Actions with improved design
                      _buildEnhancedQuickActions(context),
                      
                      SizedBox(height: isSmallScreen ? 20.0 : 28.0),
                      
                      // Recent Slips Section
                      if (viewModel.slips.isNotEmpty) 
                        _buildEnhancedRecentSlips(context, viewModel),
                      
                      // Motivational Section when no slips
                      if (viewModel.slips.isEmpty)
                        _buildMotivationalSection(context),
                      
                      SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
                    ],
                  ),
                );
              },
            ),
          ),
          
          // Confetti Animation
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              AppColors.primary,
              AppColors.success,
              AppColors.warning,
              AppColors.info,
            ],
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, bool isSmallScreen) {
    return AppBar(
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
        _buildNotificationBadge(context),
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
    );
  }

  Widget _buildNotificationBadge(BuildContext context) {
    final viewModel = context.watch<LotteryViewModel>();
    final hasRecentDraw = viewModel.drawHistory.isNotEmpty;
    
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            if (hasRecentDraw) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ResultsScreen()),
              );
            }
          },
        ),
        if (hasRecentDraw)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: const Text(
                '!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAnimatedHeader(BuildContext context, LotteryViewModel viewModel) {
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 20.0 : 28.0),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Animated Jackpot Amount
          _buildJackpotDisplay(context, viewModel),
          SizedBox(height: isSmallScreen ? 16.0 : 20.0),
          // Next Draw Countdown
          _buildNextDrawCountdown(context),
        ],
      ),
    );
  }

  Widget _buildJackpotDisplay(BuildContext context, LotteryViewModel viewModel) {
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);
    final totalPrizes = viewModel.drawHistory.fold<double>(0, (sum, draw) => sum + draw.totalPrizes);
    
    return Column(
      children: [
        Text(
          'Current Jackpot',
          style: TextStyle(
            color: AppColors.white.withOpacity(0.8),
            fontSize: isSmallScreen ? 14.0 : 16.0,
          ),
        ),
        SizedBox(height: isSmallScreen ? 8.0 : 12.0),
        Text(
          'R${(totalPrizes * 1.5).toStringAsFixed(0)}',
          style: TextStyle(
            color: AppColors.white,
            fontSize: isSmallScreen ? 32.0 : 40.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
        SizedBox(height: isSmallScreen ? 8.0 : 12.0),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${viewModel.slips.length} active slips',
            style: TextStyle(
              color: AppColors.white,
              fontSize: isSmallScreen ? 12.0 : 14.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNextDrawCountdown(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.schedule, color: AppColors.white, size: 16),
          const SizedBox(width: 8),
          Text(
            'Next draw: Today 20:00',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, LotteryViewModel viewModel) {
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);
    
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            'Total Spent',
            'R${viewModel.totalCost.toStringAsFixed(0)}',
            Icons.attach_money,
            AppColors.warning,
          ),
        ),
        SizedBox(width: isSmallScreen ? 12.0 : 16.0),
        Expanded(
          child: _buildStatCard(
            context,
            'Total Won',
            'R${viewModel.stats.totalWon.toStringAsFixed(0)}',
            Icons.emoji_events,
            AppColors.success,
          ),
        ),
        SizedBox(width: isSmallScreen ? 12.0 : 16.0),
        Expanded(
          child: _buildStatCard(
            context,
            'Net',
            'R${viewModel.stats.netProfit.toStringAsFixed(0)}',
            viewModel.stats.netProfit >= 0 ? Icons.trending_up : Icons.trending_down,
            viewModel.stats.netProfit >= 0 ? AppColors.success : AppColors.error,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedQuickActions(BuildContext context) {
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);
    final crossAxisCount = ResponsiveHelper.getGridCrossAxisCount(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: isSmallScreen ? 18.0 : 20.0,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(height: isSmallScreen ? 16.0 : 20.0),
        GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: isSmallScreen ? 12.0 : 16.0,
            mainAxisSpacing: isSmallScreen ? 12.0 : 16.0,
            childAspectRatio: 1.1,
          ),
          children: [
            _buildEnhancedActionCard(
              context,
              Icons.add_circle_outlined,
              'Manual Entry',
              'Choose your lucky numbers',
              AppColors.primary,
              Icons.arrow_forward,
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SlipEntryScreen())),
            ),
            _buildEnhancedActionCard(
              context,
              Icons.shuffle_outlined,
              'Quick Pick',
              'Generate random slips',
              AppColors.info,
              Icons.auto_awesome,
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QuickPickScreen())),
            ),
            _buildEnhancedActionCard(
              context,
              Icons.celebration_outlined,
              'Draw Now',
              'Check your luck instantly',
              AppColors.success,
              Icons.rocket_launch,
              () => _performDraw(context),
            ),
            if (crossAxisCount > 3) _buildEnhancedActionCard(
              context,
              Icons.analytics_outlined,
              'Statistics',
              'View your performance',
              AppColors.warning,
              Icons.trending_up,
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StatsScreen())),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEnhancedActionCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color color,
    IconData actionIcon,
    VoidCallback onTap,
  ) {
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.all(isSmallScreen ? 16.0 : 20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: isSmallScreen ? 20.0 : 24.0, color: color),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14.0 : 16.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 10.0 : 12.0,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(actionIcon, size: isSmallScreen ? 14.0 : 16.0, color: color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedRecentSlips(BuildContext context, LotteryViewModel viewModel) {
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Lottery Slips',
                style: TextStyle(
                  fontSize: isSmallScreen ? 18.0 : 20.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Row(
                children: [
                  Text(
                    '${viewModel.slips.length} total',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12.0 : 14.0,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildClearAllButton(context, viewModel),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: isSmallScreen ? 12.0 : 16.0),
        ...viewModel.slips.reversed.take(3).map((slip) {
          return _buildEnhancedSlipItem(context, slip, viewModel.slips.indexOf(slip) + 1, viewModel);
        }).toList(),
        if (viewModel.slips.length > 3)
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Center(
              child: TextButton(
                onPressed: () {
                  _showAllSlipsDialog(context, viewModel);
                },
                child: Text(
                  'View all ${viewModel.slips.length} slips',
                  style: const TextStyle(color: AppColors.primary),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEnhancedSlipItem(BuildContext context, LotterySlip slip, int number, LotteryViewModel viewModel) {
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          leading: Container(
            width: isSmallScreen ? 36.0 : 40.0,
            height: isSmallScreen ? 36.0 : 40.0,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: isSmallScreen ? 12.0 : 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          title: Text(
            slip.formattedNumbers,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: isSmallScreen ? 12.0 : 14.0,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          subtitle: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getTypeColor(slip.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _getTypeColor(slip.type).withOpacity(0.3)),
                ),
                child: Text(
                  slip.type,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 9.0 : 10.0,
                    color: _getTypeColor(slip.type),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatTime(slip.createdAt),
                style: TextStyle(
                  fontSize: isSmallScreen ? 10.0 : 12.0, 
                  color: AppColors.textSecondary
                ),
              ),
            ],
          ),
          trailing: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delete_outline, 
                size: isSmallScreen ? 16.0 : 18.0, 
                color: AppColors.error
              ),
            ),
            onPressed: () => _showDeleteConfirmationDialog(context, viewModel, slip.id),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
    );
  }

  Widget _buildMotivationalSection(BuildContext context) {
    final isSmallScreen = ResponsiveHelper.isSmallScreen(context);
    
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(isSmallScreen ? 20.0 : 24.0),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.auto_awesome, 
            size: isSmallScreen ? 40.0 : 48.0, 
            color: AppColors.primary.withOpacity(0.5)
          ),
          SizedBox(height: isSmallScreen ? 12.0 : 16.0),
          Text(
            'Ready to Win Big?',
            style: TextStyle(
              fontSize: isSmallScreen ? 16.0 : 18.0,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: isSmallScreen ? 6.0 : 8.0),
          Text(
            'Add your first lottery slip and get a chance to win amazing prizes!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmallScreen ? 12.0 : 14.0,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: isSmallScreen ? 12.0 : 16.0),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SlipEntryScreen()),
              );
            },
            icon: const Icon(Icons.add),
            label: Text(
              'Create First Slip',
              style: TextStyle(fontSize: isSmallScreen ? 14.0 : 16.0),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 20.0 : 24.0,
                vertical: isSmallScreen ? 12.0 : 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClearAllButton(BuildContext context, LotteryViewModel viewModel) {
    return InkWell(
      onTap: () => _showClearConfirmationDialog(context, viewModel),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.clear_all, size: 14, color: AppColors.error),
            const SizedBox(width: 4),
            Text(
              'Clear All',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAllSlipsDialog(BuildContext context, LotteryViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('All Lottery Slips'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: viewModel.slips.length,
            itemBuilder: (context, index) {
              final slip = viewModel.slips[index];
              return _buildEnhancedSlipItem(context, slip, index + 1, viewModel);
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'manual':
        return AppColors.primary;
      case 'quick pick':
        return AppColors.info;
      default:
        return AppColors.textSecondary;
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _performDraw(BuildContext context) async {
    final viewModel = context.read<LotteryViewModel>();
    if (viewModel.slips.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please add at least one slip first'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    try {
      await viewModel.performDraw();
      _celebrate(); // Play confetti
      await Future.delayed(const Duration(milliseconds: 500));
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