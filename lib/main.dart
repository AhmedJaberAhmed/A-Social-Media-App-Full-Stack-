import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/features/posts/data/repos/post_repo_imp.dart';
import 'package:instagram/themes/light_mode.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'features/authentication/presentaion/cubits/auth_cubit/auth_cubit.dart';

import 'features/authentication/data/repos/auth_repo_imp.dart';
import 'features/authentication/presentaion/cubits/auth_cubit/auth_cubit.dart';
import 'features/authentication/presentaion/pages/auth_page.dart';
import 'features/home/presentaion/home.dart';
import 'features/posts/presentaion/cubits/posts_cubit/post_cubit.dart';
import 'features/profile/data/repos/firebase_profile_repo_imp.dart';
import 'features/profile/presentaion/cubite/profile_cubit/profile_cubit.dart';
import 'features/storage/data/storage_repo_imp/storage_repo_imp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Supabase.initialize(
      url: "https://qisxgibmktqyheltktpq.supabase.co",
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFpc3hnaWJta3RxeWhlbHRrdHBxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTMyMDM4OTAsImV4cCI6MjA2ODc3OTg5MH0.O3mPyjFKEGcR37Q_UkMCa7XWfrtt5YAI9NwflIJwr1M");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(authRepo: AuthRepoImp())..checkAuth(),
        ),
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(
              storageRepo: StorageRepoImp(),
              profileRepo: FirebaseProfileRepo()),
        ),
        BlocProvider<PostCubit>(
          create: (context) =>
              PostCubit(storageRepo: StorageRepoImp(), postRepo: PostRepoImp()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        home: BlocConsumer<AuthCubit, AuthenticationState>(
          listener: (context, authState) {
            if (authState is AuthFailed) {
              final overlay = Overlay.of(context);
              if (overlay != null) {
                showTopSnackBar(
                  overlay,
                  CustomSnackBar.error(message: authState.message),
                );
              }
            }
          },
          builder: (context, authState) {
            if (authState is AuthUnauthenticated) {
              return const AuthPage();
            }

            if (authState is AuthAuthenticated) {
              return const
                  //Uploadpage();
              HomePage();
            }

            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }
}
