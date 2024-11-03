import 'package:flutter/material.dart';
import 'package:good_deeds/apis/auth.dart';
import 'package:good_deeds/constants/colors.dart';
import 'package:good_deeds/screens/auth/login.dart';

class Setting extends StatefulWidget {
  const Setting({super.key, required this.userData});

  static const String routeName = 'settings';
  final Map<String, dynamic> userData;

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: const Text("Settings"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        AssetImage("assets/p${widget.userData['id'] % 13}.png"),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.userData['name'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text("Total Points: 150"),
                  const SizedBox(height: 10),
                  Text(
                    widget.userData['email'],
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (starIndex) {
                      return Icon(
                        Icons.star,
                        color: starIndex < widget.userData['review']
                            ? Colors.redAccent
                            : Colors.white,
                        size: 15.0,
                      );
                    }),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  _authService.signOut();
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const LoginScreen();
                  }));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  minimumSize:
                      const Size.fromHeight(50), // Set the height you want
                ),
                child: const Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
