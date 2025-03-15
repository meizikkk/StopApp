import 'package:flutter/material.dart';

import '../models/daily_check_record.dart';
import '../models/daily_check_state.dart';

class DailyCheckScreen extends StatefulWidget {
  const DailyCheckScreen({super.key});

  @override
  State<DailyCheckScreen> createState() => _DailyCheckScreenState();
}

class _DailyCheckScreenState extends State<DailyCheckScreen> {
  bool _hasWatchedContent = false;
  bool _hasRelapsed = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTodayRecord();
  }

  Future<void> _loadTodayRecord() async {
    final record = await DailyCheckState.getTodayRecord();
    if (record != null) {
      setState(() {
        _hasWatchedContent = record.hasWatchedContent;
        _hasRelapsed = record.hasRelapsed;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submit() async {
    final record = DailyCheckRecord(
      hasWatchedContent: _hasWatchedContent,
      hasRelapsed: _hasRelapsed,
      checkTime: DateTime.now(),
    );
    await DailyCheckState.saveRecord(record);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('每日打卡'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCheckSection(
              title: '今天是否观看不健康内容？',
              value: _hasWatchedContent,
              onChanged: (value) => setState(() => _hasWatchedContent = value),
              positiveText: '是',
              negativeText: '否',
              color: Colors.orange,
            ),
            const SizedBox(height: 20),
            _buildCheckSection(
              title: '今天是否破戒？',
              value: _hasRelapsed,
              onChanged: (value) => setState(() => _hasRelapsed = value),
              positiveText: '是，重新开始',
              negativeText: '否，继续保持',
              color: Colors.red,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('完成打卡'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckSection({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required String positiveText,
    required String negativeText,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: value ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildChoiceButton(
                title: negativeText,
                isSelected: !value,
                onTap: () => onChanged(false),
                color: Colors.blue,
              ),
              const SizedBox(width: 12),
              _buildChoiceButton(
                title: positiveText,
                isSelected: value,
                onTap: () => onChanged(true),
                color: color,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
            border: Border.all(
              color: isSelected ? color : Colors.grey,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? color : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}