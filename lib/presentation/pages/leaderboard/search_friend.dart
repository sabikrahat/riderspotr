import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:ridespotr/presentation/widgets/shared/search_text_field.dart';

import '../../../core/extensions.dart';
import '../../providers/leaderboard/search_friend_provider.dart';
import '../../widgets/shared/back.dart';
import '../../widgets/shared/carbon_background.dart';
import '../../widgets/shared/page_padding.dart';
import '../../widgets/shared/user_tile.dart';
import '../profile/user_profile_screen.dart';

class SearchFriendScreen extends ConsumerStatefulWidget {
  const SearchFriendScreen({super.key});

  static const String routeName = '/search-friend';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchFriendScreenState();
}

class _SearchFriendScreenState extends ConsumerState<SearchFriendScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  String get _searchText => _searchController.text;

  Future<void> search() async {
    setState(() {
      _isSearching = true;
    });
    await ref.read(searchFriendProvider.notifier).refresh(_searchText);
    setState(() {
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Back(),
        title: Text(
          'SEARCH FRIEND',
          style: context.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w300,
          ),
        ),
        centerTitle: true,
      ),
      body: ref
          .watch(searchFriendProvider)
          .when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
            data: (_) {
              final notifier = ref.read(searchFriendProvider.notifier);
              return CarbonBackground(
                imgPath: 'assets/carbon/leaderboard-bg.jpg',
                heightPercent: 0.3,
                child: SafeArea(
                  child: PagePadding(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap(16),
                          // Search Bar
                          Row(
                            children: [
                              Expanded(
                                child: SearchTextField(
                                  controller: _searchController,
                                  hintText: 'Search by username...',
                                  onChanged: (value) {
                                    // Search as you type could be added here
                                  },
                                ),
                              ),
                              Gap(12),
                              GestureDetector(
                                onTap: _isSearching
                                    ? null
                                    : () async => await search(),
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.white.withValues(alpha: 0.08),
                                        Colors.white.withValues(alpha: 0.03),
                                      ],
                                    ),
                                  ),
                                  child: _isSearching
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Icon(
                                          Icons.search,
                                          color: Colors.white.withValues(
                                            alpha: 0.8,
                                          ),
                                          size: 20,
                                        ),
                                ),
                              ),
                            ],
                          ),
                          Gap(32),
                          Text(
                            'Suggested Friends',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                          Gap(16),
                          if (notifier.users.isEmpty) ...[
                            Gap(32),
                            Center(
                              child: Text(
                                'No users found.',
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Gap(32),
                          ],
                          ...List.generate(
                            notifier.users.length,
                            (i) {
                              final user = notifier.users[i];
                              return UserTile(
                                user: user,
                                onTap: () async {
                                  await context.push(
                                    UserProfileScreen.routeName,
                                    extra: user.id,
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
    );
  }
}
