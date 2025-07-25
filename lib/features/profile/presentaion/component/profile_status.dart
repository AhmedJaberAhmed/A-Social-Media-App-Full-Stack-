import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  final int postCount;
  final int followerCount;
  final int followingCount;
  final void Function()? onTap;

  const ProfileStats({
    super.key,
    required this.postCount,
    required this.followerCount,
    required this.followingCount,required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final countTextStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.inversePrimary,
    );

    final labelTextStyle = TextStyle(
      fontSize: 14,
      color: Theme.of(context).colorScheme.primary,
    );

    Widget buildStat(int count, String label) {
      return Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(count.toString(),
                style: countTextStyle, textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(label, style: labelTextStyle, textAlign: TextAlign.center),
          ],
        ),
      );
    }

    return GestureDetector(onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildStat(postCount, 'Posts'),
            buildStat(followerCount, 'Followers'),
            buildStat(followingCount, 'Following'),
          ],
        ),
      ),
    );
  }
}
