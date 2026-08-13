import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:key_handover_flutter/core/theme/app_colors.dart';
import 'package:key_handover_flutter/core/constants/key_status.dart';
import 'package:key_handover_flutter/core/utils/extensions.dart';
import 'package:key_handover_flutter/features/keys/data/models/key_model.dart';
import 'package:key_handover_flutter/features/keys/data/repositories/key_repository.dart';
import 'package:key_handover_flutter/features/take_key/presentation/screens/take_key_screen.dart';
import 'package:key_handover_flutter/shared/widgets/return_dialog.dart';
import 'package:key_handover_flutter/shared/widgets/status_badge.dart';
import 'package:url_launcher/url_launcher.dart';

class KeyDetailsScreen extends StatefulWidget {
  final KeyModel keyModel;

  const KeyDetailsScreen({super.key, required this.keyModel});

  @override
  State<KeyDetailsScreen> createState() => _KeyDetailsScreenState();
}

class _KeyDetailsScreenState extends State<KeyDetailsScreen> {
  late KeyModel _keyModel;
  final KeyRepository _keyRepo = KeyRepository();

  @override
  void initState() {
    super.initState();
    _keyModel = widget.keyModel;
  }

  Future<void> _refreshKey() async {
    final updatedKey = await _keyRepo.read(_keyModel.id!);
    if (mounted) {
      setState(() {
        _keyModel = updatedKey;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyName = _keyModel.name;
    final keyId = _keyModel.keyId;
    final status = _keyModel.status;
    final holderName = _keyModel.holderName ?? 'Unknown';
    final expectedReturn = _keyModel.expectedReturn ?? 'Not set';
    final borrowedAt = _keyModel.borrowedAt ?? 'Not set';

    return Scaffold(
      appBar: AppBar(title: const Text('Key Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        keyId,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        keyName,
                        style: context.textTheme.titleLarge?.copyWith(
                          fontSize: 26,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusBadge(status: status),
              ],
            ),

            const SizedBox(height: 32),

            // Holder Info Section (if taken)
            if (status == KeyStatus.taken || status == KeyStatus.overdue) ...[
              Text('Current Holder', style: context.textTheme.titleMedium),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primaryLight.withValues(
                        alpha: 0.2,
                      ),
                      child: Text(
                        'SJ',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            holderName,
                            style: context.textTheme.titleMedium,
                          ),
                          if (_keyModel.holderDept != null &&
                              _keyModel.holderDept!.isNotEmpty)
                            const SizedBox(height: 4),
                          if (_keyModel.holderDept != null &&
                              _keyModel.holderDept!.isNotEmpty)
                            Text(
                              _keyModel.holderDept!,
                              style: context.textTheme.bodySmall,
                            ),
                        ],
                      ),
                    ),
                    if (_keyModel.holderPhone != null &&
                        _keyModel.holderPhone!.isNotEmpty)
                      IconButton(
                        onPressed: () async {
                          final phone = _keyModel.holderPhone!;
                          final Uri url = Uri.parse('tel:$phone');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Could not launch phone dialer')),
                              );
                            }
                          }
                        },
                        icon: const Icon(
                          CupertinoIcons.phone,
                          color: AppColors.primary,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.primary.withValues(
                            alpha: 0.1,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Timeline Section
            Text('Timeline', style: context.textTheme.titleMedium),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildTimelineRow(
                    context,
                    'Borrowed At',
                    borrowedAt,
                    CupertinoIcons.arrow_uturn_right,
                    AppColors.taken,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(),
                  ),
                  _buildTimelineRow(
                    context,
                    'Expected Return',
                    expectedReturn,
                    CupertinoIcons.arrow_uturn_left,
                    AppColors.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FilledButton(
            onPressed: () async {
              if (status == KeyStatus.available) {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => TakeKeyScreen(keyModel: _keyModel),
                  ),
                );
                _refreshKey();
              } else {
                await confirmReturnDialog(context, _keyModel);
                _refreshKey();
              }
            },
            child: Text(
              status == KeyStatus.available ? 'Take Key' : 'Return Key',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: context.textTheme.bodySmall),
              const SizedBox(height: 4),
              Text(value, style: context.textTheme.titleSmall),
            ],
          ),
        ),
      ],
    );
  }
}
