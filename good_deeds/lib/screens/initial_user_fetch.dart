import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:good_deeds/screens/home/home_screen.dart';

class InitialUserFetch extends StatelessWidget {
  const InitialUserFetch({super.key});

  static const String routeName = 'initial_user_fetch';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .snapshots(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (userSnapshot.hasError) {
          return const Center(child: Text('Error fetching user data'));
        }
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return const Center(child: Text('User data not found'));
        }

        var userData = userSnapshot.data!.data() as Map<String, dynamic>;

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('service')
              .where('isOpen', isEqualTo: true)
              .snapshots(),
          builder: (context, serviceSnapshot) {
            if (serviceSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (serviceSnapshot.hasError) {
              return const Center(child: Text('Error fetching services data'));
            }
            if (!serviceSnapshot.hasData) {
              return const Center(child: Text('Services data not found'));
            }

            var servicesData = serviceSnapshot.data!.docs;

            return HomeScreen(
              userData: userData,
              servicesData: servicesData,
            );
          },
        );
      },
    );
  }
}
