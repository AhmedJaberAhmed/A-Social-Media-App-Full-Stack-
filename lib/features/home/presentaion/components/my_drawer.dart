import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authentication/presentaion/cubits/auth_cubit/auth_cubit.dart';
import '../../../profile/presentaion/pages/profile_page.dart';
import 'my_drawer_tile.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Icon(
                  color: Theme.of(context).colorScheme.primary,
                  Icons.person,
                  size: 80,
                ),
              ),
              Divider(
                color: Theme.of(context).colorScheme.secondary,
              ),
              MyDrawerTile(
                  title: "H O M E",
                  icon: Icons.home,
                  onTap: () {
                    Navigator.of(context).pop();
                  }),
              MyDrawerTile(
                  title: "P R O F I L E",
                  icon: Icons.person,
                  onTap: () {
                    Navigator.of(context).pop();

                    final user = context.read<AuthCubit>().currentUser;
                    String uid = user!.uid;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePage(uid: uid)),
                    );
                  }),
              MyDrawerTile(
                  title: "S E A R C H", icon: Icons.search, onTap: () {}),
              MyDrawerTile(
                  title: "S E T T I N G S", icon: Icons.settings, onTap: () {}),
              Spacer(),
              MyDrawerTile(
                  title: "L O G O U T",
                  icon: Icons.login,
                  onTap: () {
                    context.read<AuthCubit>().logout();
                  })
            ],
          ),
        ),
      ),
    );
  }
}
