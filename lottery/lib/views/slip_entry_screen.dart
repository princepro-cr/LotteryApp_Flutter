import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/lottery_view_model.dart';

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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Create Lottery Slip',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Column(
        children: [
          // Progress Section
          _buildProgressSection(context),
          
          // Selected Numbers Display
          _buildNumbersDisplay(context),
          
          // Number Grid
          _buildNumberGrid(context),
          
          // Action Buttons
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.deepPurple[400]!, Colors.deepPurple[600]!],
        ),
      ),
      child: Column(
        children: [
          // Progress Bar
          LinearProgressIndicator(
            value: _currentIndex / 6,
            backgroundColor: Colors.white.withOpacity(0.3),
            color: Colors.amber,
            borderRadius: BorderRadius.circular(10),
            minHeight: 8,
          ),
          const SizedBox(height: 20),
          // Progress Text
          Text(
            'Select Number ${_currentIndex + 1} of 6',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Choose unique numbers from 1 to 49',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumbersDisplay(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Your Selected Numbers',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(6, (index) {
              final isCurrent = index == _currentIndex;
              final number = _selectedNumbers[index];
              
              return Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isCurrent ? Colors.amber : 
                         number != null ? Colors.deepPurple : Colors.grey[200],
                  shape: BoxShape.circle,
                  border: isCurrent ? Border.all(color: Colors.orange, width: 3) : null,
                ),
                child: Center(
                  child: Text(
                    number?.toString() ?? '?',
                    style: TextStyle(
                      fontSize: 18,
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

  Widget _buildNumberGrid(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // Quick Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.backspace, size: 16),
                    label: const Text('Remove Last'),
                    onPressed: _currentIndex > 0 ? _removeLastNumber : null,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.clear, size: 16),
                    label: const Text('Clear All'),
                    onPressed: _currentIndex > 0 ? _clearSelection : null,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Number Grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  childAspectRatio: 1.0,
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
                          color: isSelected ? Colors.deepPurple : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? Colors.deepPurple : Colors.grey[300]!,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected ? [
                            BoxShadow(
                              color: Colors.deepPurple.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ] : null,
                        ),
                        child: Center(
                          child: Text(
                            number.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.deepPurple,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
                padding: const EdgeInsets.symmetric(vertical: 16),
                foregroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                side: BorderSide(color: Colors.deepPurple.withOpacity(0.5)),
              ),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 16),
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
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $e'),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _canSubmit() ? Colors.green : Colors.grey[400],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Submit Slip',
                    style: TextStyle(fontWeight: FontWeight.bold),
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