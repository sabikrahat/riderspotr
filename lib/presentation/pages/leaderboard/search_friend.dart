import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/extensions.dart';
import '../../providers/leaderboard/search_friend_provider.dart';
import '../../widgets/shared/back.dart';
import '../../widgets/shared/carbon_background.dart';
import '../../widgets/shared/page_padding.dart';

class SearchFriendScreen extends ConsumerStatefulWidget {
  const SearchFriendScreen({super.key});

  static const String routeName = '/search-friend';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchFriendScreenState();
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Back(),
        title: Text('SEARCH FOR FRIEND', style: context.textTheme.headlineMedium),
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
                child: PagePadding(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _searchController,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[900],
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.grey[800]!,
                                      width: 1,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.grey[800]!,
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.grey[800]!,
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Gap(8),
                            InkWell(
                              onTap: _isSearching ? null : () async => await search(),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(11),
                                decoration: BoxDecoration(
                                  color: Colors.grey[900],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey[800]!,
                                    width: 1,
                                  ),
                                ),
                                child: _isSearching
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.search,
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                          ],
                        ),
                        Gap(16),
                        Text(
                          'Suggested Friends',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Gap(16),
                        if (notifier.users.isEmpty) ...[
                          Gap(32),
                          Center(
                            child: Text(
                              'No users found.',
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
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
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Stack(
                                  children: [
                                    user.bannerUrl == null
                                        ? Image.asset(
                                            'assets/carbon/leaderboard-bg.jpg',
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 100,
                                          )
                                        : Image.network(
                                            user.bannerUrl!,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 100,
                                          ),
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black.withValues(alpha: 0.7),
                                              Colors.black,
                                            ],
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 25,
                                              backgroundImage: user.profilePictureUrl == null
                                                  ? AssetImage(
                                                      'assets/images/user-placeholder.png',
                                                    )
                                                  : const NetworkImage(
                                                      'https://picsum.photos/200',
                                                    ),
                                            ),
                                            Gap(12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    user.fullName,
                                                    style: context.textTheme.bodyMedium?.copyWith(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    '@${user.username ?? 'username'}',
                                                    style: context.textTheme.bodyMedium?.copyWith(
                                                      color: Colors.white70,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
    );
  }
}
