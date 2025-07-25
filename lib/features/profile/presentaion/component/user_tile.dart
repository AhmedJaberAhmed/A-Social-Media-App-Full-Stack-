import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram/features/profile/domain/profile_user.dart';
import 'package:shimmer/shimmer.dart';

import '../pages/profile_page.dart';

class UserTile extends StatelessWidget {
  final ProfileUser profileUser;
  const UserTile({super.key, required this.profileUser});

  @override
  Widget build(BuildContext context) {
    return ListTile(
    title: Text(profileUser.name),
    subtitle: Text(profileUser.email),subtitleTextStyle:
    TextStyle(color: Theme.of(context).colorScheme.primary),
      leading: // Inside your widget tree:

      ClipOval(
        child: CachedNetworkImage(
          imageUrl: profileUser.profileImageUrl,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 40,
              height: 40,
              color: Colors.white,
            ),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.person),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward,
        color: Theme.of(context).colorScheme.primary,
      ), // Icon
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(uid: profileUser.uid),
        ), // MaterialPageRoute
      ),

    );
  }
}
