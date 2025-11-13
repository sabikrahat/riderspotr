import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/extensions.dart';
import '../../../models/user/user_simple_model.dart';

class SimpleUserTile extends StatelessWidget {
  const SimpleUserTile({
    super.key,
    required this.user,
    this.onTap,
  });

  final UserSimpleModel user;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 16,
              backgroundImage: user.profilePictureUrl == null
                  ? AssetImage('assets/images/user-placeholder.png')
                  : FastCachedImageProvider(user.profilePictureUrl!)
                        as ImageProvider,
            ),
            Gap(10),
            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    user.fullName.isEmpty ? 'Full Name' : user.fullName,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "@${user.username ?? 'username'}",
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Arrow button
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }
}
