import 'package:flutter/material.dart';
import 'package:key_handover_flutter/core/constants/key_status.dart';
import 'package:key_handover_flutter/core/theme/app_colors.dart';
import 'package:key_handover_flutter/core/utils/extensions.dart';
import 'package:key_handover_flutter/shared/widgets/status_badge.dart';

class KeyTileWidget extends StatelessWidget {
  const KeyTileWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.status = KeyStatus.available,
    required this.onTap,
  });

  final String title;
  final String? subtitle;
  final KeyStatus? status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.border),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.key_outlined, color: AppColors.primary),
        ),
        title: Text(
          title,
          style: context.textTheme.titleMedium?.copyWith(fontSize: 18),
        ),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        trailing: StatusBadge(status: status),
      ),
    );
  }
}
