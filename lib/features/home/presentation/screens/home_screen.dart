import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:key_handover_flutter/core/theme/app_colors.dart';
import 'package:key_handover_flutter/core/utils/extensions.dart';
import 'package:key_handover_flutter/features/history/presentation/screens/history_screen.dart';
import 'package:key_handover_flutter/features/home/presentation/widgets/key_tile_widget.dart';
import 'package:key_handover_flutter/features/key_details/presentation/screens/key_details_screen.dart';

import 'package:key_handover_flutter/features/keys/data/models/key_model.dart';
import 'package:key_handover_flutter/features/keys/data/repositories/key_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  var isSearching = false;

  final KeyRepository _repository = KeyRepository();
  List<KeyModel> _keys = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadKeys();
  }

  Future<void> _loadKeys([String query = '']) async {
    setState(() => _isLoading = true);
    final results = query.isEmpty 
        ? await _repository.readAll()
        : await _repository.search(query);
    if (mounted) {
      setState(() {
        _keys = results;
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
      appBar: AppBar(
        title: const Text('Key Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: 'Handover history',
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const HistoryScreen()));
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            _loadKeys();
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
                  _loadKeys(value);
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _isLoading 
                  ? const Center(child: CircularProgressIndicator())
                  : _keys.isEmpty 
                    ? const Center(child: Text("No keys found"))
                    : ListView.separated(
                        itemCount: _keys.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 2),
                        itemBuilder: (context, index) {
                          final keyModel = _keys[index];
                          return KeyTileWidget(
                            title: keyModel.name,
                            subtitle: keyModel.keyId,
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => KeyDetailsScreen(keyModel: keyModel),
                                ),
                              );
                              _loadKeys(); // Refresh when returning
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
