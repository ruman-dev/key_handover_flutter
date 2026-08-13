import 'package:flutter/material.dart';
import 'package:key_handover_flutter/core/theme/app_colors.dart';
import 'package:key_handover_flutter/core/utils/extensions.dart';

void confirmReturnDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Return key?'),
        content: Text(
          'Mark this key as returned by {record.personName}?',
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
              // await repo.returnKey(record);
              if (context.mounted) Navigator.of(context).pop();
            },
            child: Text(
              'Confirm',
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      );
    },
  );
}
