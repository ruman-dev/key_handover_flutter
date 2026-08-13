import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:key_handover_flutter/core/theme/app_colors.dart';
import 'package:key_handover_flutter/core/utils/extensions.dart';

import 'package:key_handover_flutter/core/constants/key_status.dart';
import 'package:key_handover_flutter/features/history/data/models/history_model.dart';
import 'package:key_handover_flutter/features/history/data/repositories/history_repository.dart';
import 'package:key_handover_flutter/features/keys/data/models/key_model.dart';
import 'package:key_handover_flutter/features/keys/data/repositories/key_repository.dart';

class TakeKeyScreen extends StatefulWidget {
  final KeyModel keyModel;

  const TakeKeyScreen({super.key, required this.keyModel});

  @override
  State<TakeKeyScreen> createState() => _TakeKeyScreenState();
}

class _TakeKeyScreenState extends State<TakeKeyScreen> {
  DateTime? _handoverDateTime;
  DateTime? _expectedDateTime;

  late final TextEditingController _nameController;
  late final TextEditingController _deptController;
  late final TextEditingController _phoneController;
  late final TextEditingController _handoverTimeController;
  late final TextEditingController _expectedReturnTimeController;
  late final TextEditingController _timeController;

  final KeyRepository _keyRepo = KeyRepository();
  final HistoryRepository _historyRepo = HistoryRepository();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _deptController = TextEditingController();
    _phoneController = TextEditingController();
    _timeController = TextEditingController();
    _handoverTimeController = TextEditingController();
    _expectedReturnTimeController = TextEditingController();

    // Default handover time to now
    _handoverDateTime = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handoverTimeController.text = _formatDateTime(
        _handoverDateTime!,
        TimeOfDay.fromDateTime(_handoverDateTime!),
        context,
      );
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _deptController.dispose();
    _phoneController.dispose();
    _timeController.dispose();
    _handoverTimeController.dispose();
    _expectedReturnTimeController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime(bool isHandover) async {
    final DateTime now = DateTime.now();
    final currentSelected = isHandover ? _handoverDateTime : _expectedDateTime;

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentSelected ?? now,
      firstDate: DateTime.now(),
      lastDate: now.add(const Duration(days: 365)),
    );

    if (pickedDate == null || !mounted) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: currentSelected != null
          ? TimeOfDay.fromDateTime(currentSelected)
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
      if (isHandover) {
        _handoverDateTime = combined;
        _handoverTimeController.text = _formatDateTime(
          combined,
          pickedTime,
          context,
        );
      } else {
        _expectedDateTime = combined;
        _expectedReturnTimeController.text = _formatDateTime(
          combined,
          pickedTime,
          context,
        );
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
    final keyName = widget.keyModel.name;
    final keyId = widget.keyModel.keyId;

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
                      Icons.key_outlined,
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

            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                hintText: 'Enter your name',
                prefixIcon: Icon(CupertinoIcons.person),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _deptController,
              decoration: const InputDecoration(
                labelText: 'Department / Role (Optional)',
                hintText: 'e.g., Engineering',
                prefixIcon: Icon(CupertinoIcons.briefcase),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number (Optional)',
                hintText: 'Enter contact number',
                prefixIcon: Icon(CupertinoIcons.phone),
              ),
            ),

            const SizedBox(height: 32),

            Text('Handover Details', style: context.textTheme.titleMedium),
            const SizedBox(height: 16),

            // Expected Return Dropdown / Input Mock
            TextField(
              controller: _handoverTimeController,
              readOnly: true,
              onTap: () => _pickDateTime(true),
              decoration: const InputDecoration(
                labelText: 'Handover Time',
                hintText: 'Select a time',
                prefixIcon: Icon(CupertinoIcons.clock),
                suffixIcon: Icon(CupertinoIcons.chevron_down),
              ),
            ),
            const SizedBox(height: 16),
            // Expected Return Dropdown / Input Mock
            TextField(
              controller: _expectedReturnTimeController,
              readOnly: true,
              onTap: () => _pickDateTime(false),
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
            onPressed: () async {
              if (_nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a name')),
                );
                return;
              }

              if (_expectedDateTime != null && _handoverDateTime != null && _expectedDateTime!.isBefore(_handoverDateTime!)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Expected return time must be after handover time')),
                );
                return;
              }

              // Update Key
              final updatedKey = widget.keyModel.copyWith(
                status: KeyStatus.taken,
                holderName: _nameController.text.trim(),
                holderDept: _deptController.text.trim(),
                holderPhone: _phoneController.text.trim(),
                borrowedAt: _handoverTimeController.text,
                expectedReturn: _expectedReturnTimeController.text,
              );
              await _keyRepo.update(updatedKey);

              // Add History Record
              final historyRecord = HistoryModel(
                keyName: widget.keyModel.name,
                personName: _nameController.text.trim(),
                takenTime: _handoverTimeController.text,
                returnedTime: 'Pending...',
                status: KeyStatus.taken,
              );
              await _historyRepo.create(historyRecord);

              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: const Text('Confirm'),
          ),
        ),
      ),
    );
  }
}
