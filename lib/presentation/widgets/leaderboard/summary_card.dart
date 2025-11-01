import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/extensions.dart';
import '../../providers/auth/user_provider.dart';
import '../../providers/leaderboard/user_rank_provider.dart';

class LeaderboardSummaryCard extends ConsumerWidget {
  const LeaderboardSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.06),
            Colors.white.withValues(alpha: 0.02),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ref
                .watch(userProvider)
                .when(
                  loading: () => _Tile(
                    icon: Icons.electric_bolt_rounded,
                    title: 'Your Points',
                    value: '...',
                  ),
                  error: (_, __) => _Tile(
                    icon: Icons.electric_bolt_rounded,
                    title: 'Your Points',
                    value: 'N/A',
                  ),
                  data: (user) => _Tile(
                    icon: Icons.electric_bolt_rounded,
                    title: 'Your Points',
                    value: '${user?.stats?.totalXp ?? 0} XP',
                  ),
                ),
          ),
          Expanded(
            child: ref
                .watch(userRankProvider)
                .when(
                  loading: () => _Tile(
                    icon: Icons.language,
                    title: 'Global',
                    value: '...',
                  ),
                  error: (_, __) => _Tile(
                    icon: Icons.language,
                    title: 'Global',
                    value: 'N/A',
                  ),
                  data: (rank) => _Tile(
                    icon: Icons.language,
                    title: 'Global',
                    value: '#$rank',
                  ),
                ),
          ),
          Expanded(
            child: ref
                .watch(userProvider)
                .when(
                  loading: () => _Tile(
                    icon: Icons.directions_car_rounded,
                    title: 'Legendaries',
                    value: '...',
                  ),
                  error: (_, __) => _Tile(
                    icon: Icons.directions_car_rounded,
                    title: 'Legendaries',
                    value: 'N/A',
                  ),
                  data: (user) => _Tile(
                    icon: Icons.directions_car_rounded,
                    title: 'Legendaries',
                    value: '#${user?.stats?.legendarySpots ?? 0}',
                  ),
                ),
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.white.withValues(alpha: 0.8),
          size: 28,
        ),
        Gap(12),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w300,
            letterSpacing: -0.5,
          ),
        ),
        Gap(6),
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.4),
            fontSize: 11,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}
