import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:key_handover_flutter/core/constants/key_status.dart';
import 'package:key_handover_flutter/core/theme/app_colors.dart';
import 'package:key_handover_flutter/core/utils/extensions.dart';
import 'package:key_handover_flutter/features/history/presentation/widgets/history_card.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _searchController = TextEditingController();
  var isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Mock Data for History Records
    final mockRecords = [
      MockHistoryRecord(
        keyName: 'Main Entrance Door (KEY-A01)',
        personName: 'Sarah Jenkins',
        takenTime: 'Oct 12, 2026, 09:15 AM',
        returnedTime: 'Oct 12, 2026, 05:00 PM',
        status: KeyStatus.available,
      ),
      MockHistoryRecord(
        keyName: 'Server Room (KEY-S02)',
        personName: 'Mike Ross',
        takenTime: 'Oct 10, 2026, 10:00 AM',
        returnedTime: 'Oct 10, 2026, 11:30 AM',
        status: KeyStatus.available,
      ),
      MockHistoryRecord(
        keyName: 'Storage Room (KEY-ST01)',
        personName: 'John Doe',
        takenTime: 'Oct 13, 2026, 08:00 AM',
        returnedTime: 'Pending...',
        status: KeyStatus.overdue,
      ),
      MockHistoryRecord(
        keyName: 'Back Gate (KEY-B04)',
        personName: 'Emily Clark',
        takenTime: 'Oct 13, 2026, 09:00 AM',
        returnedTime: 'Pending...',
        status: KeyStatus.taken,
      ),
      MockHistoryRecord(
        keyName: 'Back Gate (KEY-B04)',
        personName: 'Emily Clark',
        takenTime: 'Oct 13, 2026, 09:00 AM',
        returnedTime: 'Pending...',
        status: KeyStatus.taken,
      ),
      MockHistoryRecord(
        keyName: 'Back Gate (KEY-B04)',
        personName: 'Emily Clark',
        takenTime: 'Oct 13, 2026, 09:00 AM',
        returnedTime: 'Pending...',
        status: KeyStatus.taken,
      ),
      MockHistoryRecord(
        keyName: 'Back Gate (KEY-B04)',
        personName: 'Emily Clark',
        takenTime: 'Oct 13, 2026, 09:00 AM',
        returnedTime: 'Pending...',
        status: KeyStatus.taken,
      ),
      MockHistoryRecord(
        keyName: 'Back Gate (KEY-B04)',
        personName: 'Emily Clark',
        takenTime: 'Oct 13, 2026, 09:00 AM',
        returnedTime: 'Pending...',
        status: KeyStatus.taken,
      ),
      MockHistoryRecord(
        keyName: 'Back Gate (KEY-B04)',
        personName: 'Emily Clark',
        takenTime: 'Oct 13, 2026, 09:00 AM',
        returnedTime: 'Pending...',
        status: KeyStatus.taken,
      ),
      MockHistoryRecord(
        keyName: 'Back Gate (KEY-B04)',
        personName: 'Emily Clark',
        takenTime: 'Oct 13, 2026, 09:00 AM',
        returnedTime: 'Pending...',
        status: KeyStatus.taken,
      ),
      MockHistoryRecord(
        keyName: 'Back Gate (KEY-B04)',
        personName: 'Emily Clark',
        takenTime: 'Oct 13, 2026, 09:00 AM',
        returnedTime: 'Pending...',
        status: KeyStatus.taken,
      ),
      MockHistoryRecord(
        keyName: 'Back Gate (KEY-B04)',
        personName: 'Emily Clark',
        takenTime: 'Oct 13, 2026, 09:00 AM',
        returnedTime: 'Pending...',
        status: KeyStatus.taken,
      ),
      MockHistoryRecord(
        keyName: 'Back Gate (KEY-B04)',
        personName: 'Emily Clark',
        takenTime: 'Oct 13, 2026, 09:00 AM',
        returnedTime: 'Pending...',
        status: KeyStatus.taken,
      ),
      MockHistoryRecord(
        keyName: 'Back Gate (KEY-B04)',
        personName: 'Emily Clark',
        takenTime: 'Oct 13, 2026, 09:00 AM',
        returnedTime: 'Pending...',
        status: KeyStatus.taken,
      ),
      MockHistoryRecord(
        keyName: 'Back Gate (KEY-B04)',
        personName: 'Emily Clark',
        takenTime: 'Oct 13, 2026, 09:00 AM',
        returnedTime: 'Pending...',
        status: KeyStatus.taken,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Handover History')),
      body: mockRecords.isEmpty
          ? _buildEmptyState(context)
          : Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        CupertinoIcons.search,
                        color: AppColors.primary,
                      ),
                      hintText: "Search by key name...",
                      hintStyle: context.textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      suffixIcon: isSearching
                          ? IconButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  isSearching = false;
                                });
                              },
                              icon: Icon(CupertinoIcons.xmark_circle),
                              color: AppColors.textSecondary,
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        isSearching = value.isNotEmpty;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.separated(
                      itemCount: mockRecords.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return HistoryCard(record: mockRecords[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            CupertinoIcons.doc_text_search,
            size: 64,
            color: AppColors.border,
          ),
          const SizedBox(height: 16),
          Text(
            'No history found',
            style: context.textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class MockHistoryRecord {
  final String keyName;
  final String personName;
  final String takenTime;
  final String returnedTime;
  final KeyStatus status;

  MockHistoryRecord({
    required this.keyName,
    required this.personName,
    required this.takenTime,
    required this.returnedTime,
    required this.status,
  });
}
