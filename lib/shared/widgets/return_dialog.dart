import 'package:flutter/material.dart';
import 'package:key_handover_flutter/core/constants/key_status.dart';
import 'package:key_handover_flutter/core/theme/app_colors.dart';
import 'package:key_handover_flutter/core/utils/extensions.dart';
import 'package:key_handover_flutter/features/history/data/repositories/history_repository.dart';
import 'package:key_handover_flutter/features/keys/data/models/key_model.dart';
import 'package:key_handover_flutter/features/keys/data/repositories/key_repository.dart';

Future<void> confirmReturnDialog(
  BuildContext context,
  KeyModel keyModel,
) async {
  final keyRepo = KeyRepository();
  final historyRepo = HistoryRepository();

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Return key?'),
        content: Text(
          'Mark this key as returned by ${keyModel.holderName ?? "Someone"}?',
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary.withValues(alpha: .8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();

              // 1. Update Key
              final updatedKey = keyModel.copyWith(
                status: KeyStatus.available,
                holderName: null,
                holderDept: null,
                holderPhone: null,
                borrowedAt: null,
                expectedReturn: null,
              );
              await keyRepo.update(updatedKey);

              // 2. Update History
              final pendingRecord = await historyRepo.findPendingRecord(
                keyModel.name,
              );
              if (pendingRecord != null) {
                final returnedTimeStr = DateTime.now().toIso8601String();
                final updatedRecord = pendingRecord.copyWith(
                  status: KeyStatus.available,
                  returnedTime: returnedTimeStr,
                );
                await historyRepo.update(updatedRecord);
              }

              if (context.mounted) Navigator.of(context).pop();
            },
            child: Text(
              'Confirm',
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      );
    },
  );
}
