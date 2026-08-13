import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:key_handover_flutter/core/constants/key_status.dart';
import 'package:key_handover_flutter/core/theme/app_colors.dart';
import 'package:key_handover_flutter/core/utils/extensions.dart';
import 'package:key_handover_flutter/features/history/data/models/history_model.dart';
import 'package:key_handover_flutter/shared/widgets/status_badge.dart';

class HistoryCard extends StatelessWidget {
  const HistoryCard({super.key, required this.record});

  final HistoryModel record;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Key & Status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.key_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            record.keyName,
                            style: context.textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                CupertinoIcons.person,
                                size: 14,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                record.personName,
                                style: context.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              StatusBadge(status: record.status),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),

          // Times
          Row(
            children: [
              Expanded(
                child: _buildTimeInfo(
                  context,
                  label: 'Taken',
                  time: record.takenTime.toFormattedDate(context),
                  icon: CupertinoIcons.arrow_uturn_right,
                  color: AppColors.taken,
                ),
              ),
              Container(width: 1, height: 30, color: AppColors.border),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: _buildTimeInfo(
                    context,
                    label: 'Returned',
                    time: record.returnedTime.toFormattedDate(context),
                    icon: CupertinoIcons.arrow_uturn_left,
                    color: record.status == KeyStatus.overdue
                        ? AppColors.overdue
                        : (record.status == KeyStatus.taken
                              ? AppColors.textPrimary
                              : AppColors.available),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInfo(
    BuildContext context, {
    required String label,
    required String time,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(label, style: context.textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: context.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
