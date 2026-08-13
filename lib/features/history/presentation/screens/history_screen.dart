import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:key_handover_flutter/core/theme/app_colors.dart';
import 'package:key_handover_flutter/core/utils/extensions.dart';
import 'package:key_handover_flutter/features/history/data/models/history_model.dart';
import 'package:key_handover_flutter/features/history/data/repositories/history_repository.dart';
import 'package:key_handover_flutter/features/history/presentation/widgets/history_card.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _searchController = TextEditingController();
  var isSearching = false;

  final HistoryRepository _repository = HistoryRepository();
  List<HistoryModel> _records = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords([String query = '']) async {
    setState(() => _isLoading = true);
    final results = query.isEmpty
        ? await _repository.readAll()
        : await _repository.search(query);
    if (mounted) {
      setState(() {
        _records = results;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
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
                                _loadRecords();
                              },
                              icon: const Icon(CupertinoIcons.xmark_circle),
                              color: AppColors.textSecondary,
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        isSearching = value.isNotEmpty;
                      });
                      _loadRecords(value);
                    },
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _records.isEmpty
                        ? _buildEmptyState(context)
                        : ListView.separated(
                            itemCount: _records.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              return HistoryCard(record: _records[index]);
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
