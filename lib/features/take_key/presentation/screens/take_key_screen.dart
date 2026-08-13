import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:key_handover_flutter/core/theme/app_colors.dart';
import 'package:key_handover_flutter/core/utils/extensions.dart';

class TakeKeyScreen extends StatefulWidget {
  const TakeKeyScreen({super.key});

  @override
  State<TakeKeyScreen> createState() => _TakeKeyScreenState();
}

class _TakeKeyScreenState extends State<TakeKeyScreen> {
  DateTime? _selectedDateTime;
  late final TextEditingController _timeController;

  @override
  void initState() {
    super.initState();
    _timeController = TextEditingController();
  }

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final DateTime now = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? now,
      firstDate: DateTime.now(),
      lastDate: now.add(const Duration(days: 365)),
    );

    if (pickedDate == null || !mounted) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedDateTime != null
          ? TimeOfDay.fromDateTime(_selectedDateTime!)
          : TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    final DateTime combined = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      _selectedDateTime = combined;
      if (mounted) {
        _timeController.text = _formatDateTime(combined, pickedTime, context);
      }
    });
  }

  String _formatDateTime(DateTime date, TimeOfDay time, BuildContext context) {
    final now = DateTime.now();
    final timeStr = time.format(context);

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today, $timeStr';
    }

    final tomorrow = now.add(const Duration(days: 1));
    if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return 'Tomorrow, $timeStr';
    }

    return DateFormat("MMM dd, yyyy, hh:mm a").format(date);
  }

  @override
  Widget build(BuildContext context) {
    // Dummy Data
    const keyName = 'Main Entrance Door';
    const keyId = 'KEY-A01';

    return Scaffold(
      appBar: AppBar(title: const Text('Take Key')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Key Info Card (Minimal)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      CupertinoIcons.tag,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          keyId,
                          style: context.textTheme.labelMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(keyName, style: context.textTheme.titleMedium),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Form Section
            Text('Holder Details', style: context.textTheme.titleMedium),
            const SizedBox(height: 16),

            const TextField(
              decoration: InputDecoration(
                labelText: 'Full Name',
                hintText: 'Enter your name',
                prefixIcon: Icon(CupertinoIcons.person),
              ),
            ),
            const SizedBox(height: 16),

            const TextField(
              decoration: InputDecoration(
                labelText: 'Department / Role',
                hintText: 'e.g., Engineering',
                prefixIcon: Icon(CupertinoIcons.briefcase),
              ),
            ),
            const SizedBox(height: 16),

            const TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                hintText: 'Enter contact number',
                prefixIcon: Icon(CupertinoIcons.phone),
              ),
            ),

            const SizedBox(height: 32),

            Text('Handover Details', style: context.textTheme.titleMedium),
            const SizedBox(height: 16),

            // Expected Return Dropdown / Input Mock
            TextField(
              controller: _timeController,
              readOnly: true,
              onTap: _pickDateTime,
              decoration: const InputDecoration(
                labelText: 'Expected Return Time',
                hintText: 'Select a time',
                prefixIcon: Icon(CupertinoIcons.time),
                suffixIcon: Icon(CupertinoIcons.chevron_down),
              ),
            ),

            const SizedBox(height: 48),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Confirm'),
          ),
        ),
      ),
    );
  }
}
