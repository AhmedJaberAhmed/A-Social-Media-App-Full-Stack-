import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool isFollowing;

  const FollowButton({
    super.key,
    required this.onPressed,
    required this.isFollowing,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220, // Wider button
      height: 48, // Taller button
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: isFollowing ? Colors.white : Colors.blue,
          foregroundColor: isFollowing ? Colors.black : Colors.white,
          side: isFollowing ? const BorderSide(color: Colors.black) : BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // More rounded
          ),
        ),
        child: Text(
          isFollowing ? 'Following' : 'Follow',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16, // Slightly larger text
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
