import 'package:flutter/material.dart';
import 'package:key_handover_flutter/core/constants/key_status.dart';
import 'package:key_handover_flutter/core/theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, this.status});

  final KeyStatus? status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _statusColor),
        color: _statusColor.withValues(alpha: .1),
      ),
      child: Text(
        "${status?.name.substring(0, 1).toUpperCase()}${status?.name.substring(1)}",
        style: TextStyle(
          color: _statusColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color get _statusColor {
    switch (status) {
      case KeyStatus.available:
        return AppColors.available;
      case KeyStatus.taken:
        return AppColors.taken;
      case KeyStatus.overdue:
        return AppColors.overdue;
      default:
        return AppColors.available;
    }
  }
}
