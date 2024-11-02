import 'package:flutter/material.dart';
import 'package:good_deeds/apis/auth.dart';
import 'package:good_deeds/constants/colors.dart';
import 'package:good_deeds/screens/auth/login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                _authService.signOut();
                Navigator.popAndPushNamed(context, LoginScreen.routeName);
              },
              child: const Text("Logout"),
            )
          ],
        ),
      ),
    );
  }
}
