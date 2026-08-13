import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:key_handover_flutter/core/theme/app_colors.dart';
import 'package:key_handover_flutter/core/utils/extensions.dart';
import 'package:key_handover_flutter/features/home/presentation/widgets/key_tile_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  var isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Office Keys'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: 'Handover history',
            onPressed: () {
              // Navigator.of(
              //   context,
              // ).push(MaterialPageRoute(builder: (_) => const HistoryScreen()));
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
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: 5,
                  separatorBuilder: (_, _) => const SizedBox(height: 2),
                  itemBuilder: (context, index) {
                    return KeyTileWidget(
                      title: "Main Gate",
                      subtitle: "MG-01",
                      onTap: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (_) => KeyDetailScreen(),
                        // ),
                        // );
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
