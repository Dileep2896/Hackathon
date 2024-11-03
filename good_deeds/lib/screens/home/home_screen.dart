import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:good_deeds/apis/database.dart';
import 'package:good_deeds/constants/colors.dart';
import 'package:good_deeds/screens/home/store.dart';
import 'package:good_deeds/screens/home/request.dart';
import 'package:good_deeds/screens/home/serve.dart';
import 'package:good_deeds/screens/settings/setting.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.userData,
    required this.servicesData,
  });

  static const String routeName = 'home';
  final Map<String, dynamic> userData;
  final List<QueryDocumentSnapshot> servicesData;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  bool isLoading = true;
  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final List<QueryDocumentSnapshot> servicesData = widget.servicesData;
    final Map<String, dynamic> userData = widget.userData;

    final navigatorScreen = [
      Serve(serviceData: servicesData),
      Request(userData: userData, serviceData: servicesData),
      const Store(),
    ];

    const navColor = [
      Color(0xFFD32F2F),
      Color(0xFFFF7043),
      Color(0xFF3F51B5),
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Text(
            "Welcome, ${widget.userData['name'].toString().split(" ")[0]}"),
        leading: IconButton(
          onPressed: () {
            setState(() {
              currentIndex = 2;
            });
          },
          icon: const CircleAvatar(
            radius: 15,
            backgroundImage: AssetImage(
              "assets/heart_coins.png",
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundImage:
                  AssetImage('assets/p${widget.userData['id']}.png'),
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return Setting(
                    userData: userData,
                  );
                },
              ));
            },
            iconSize: 30.0,
            padding: const EdgeInsets.all(8.0),
            splashColor: AppColors.secondaryColor,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Serve',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Request',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Store',
          ),
        ],
        currentIndex: currentIndex,
        selectedItemColor: navColor[currentIndex],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      body: navigatorScreen[currentIndex],
    );
  }
}
