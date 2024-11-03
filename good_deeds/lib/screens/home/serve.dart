import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:good_deeds/constants/accent_colors.dart';
import 'package:good_deeds/constants/colors.dart';
import 'package:good_deeds/screens/chat/chat_screen.dart';
import 'package:good_deeds/screens/serviceDetails/service_detail.dart';
import 'package:good_deeds/widgets/icon_text.dart';
import 'package:intl/intl.dart';

class Serve extends StatelessWidget {
  const Serve({
    super.key,
    required this.serviceData,
  });

  final List<QueryDocumentSnapshot> serviceData;

  List<QueryDocumentSnapshot> getFilteredServiceData(String loggedInUserId) {
    return serviceData.where((request) {
      return request.get('requestedUser') != loggedInUserId;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<QueryDocumentSnapshot> filteredServiceData =
        getFilteredServiceData(
      FirebaseAuth.instance.currentUser?.uid ?? '',
    );

    final homeHelp = filteredServiceData.where((request) {
      return request.get('category') == 'home_help';
    }).toList();
    final emotionalHelp = filteredServiceData
        .where((request) => request.get('category') == 'emotional_help')
        .toList();
    final educationHelp = filteredServiceData
        .where((request) => request.get('category') == 'education_help')
        .toList();
    final other = filteredServiceData
        .where((request) => request.get('category') == 'other')
        .toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          const Text(
            "Self & Home",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          HelpCategoryRow(categories: homeHelp),
          const SizedBox(height: 20.0),
          const Text(
            "Health & Emotion",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          HelpCategoryRow(categories: emotionalHelp),
          const SizedBox(height: 20.0),
          const Text(
            "Education",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          HelpCategoryRow(categories: educationHelp),
          const SizedBox(height: 20.0),
          const Text(
            "Others",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          HelpCategoryRow(categories: other),
        ],
      ),
    );
  }
}

class HelpCategoryRow extends StatelessWidget {
  final List<QueryDocumentSnapshot<Object?>> categories;

  const HelpCategoryRow({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(categories.length, (index) {
          QueryDocumentSnapshot<Object?> category = categories[index];
          User? user = FirebaseAuth.instance.currentUser;
          bool isRequested = category.get('availableUsers').contains(
                user!.uid,
              );
          bool isAccepted = category.get('acceptedUser') == user.uid;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServiceDetail(
                    serviceData: category,
                    index: index,
                    isRequested: isRequested,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Container(
                width: 250,
                height: 315,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 46, 48, 49),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: AccentColors
                            .lightAccentColors[category.get('id') % 13],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage(
                                    "assets/p${category.get('id') % 13}.png"),
                                radius: 30.0,
                              ),
                              Text(
                                category.get('personName'),
                                maxLines: 1,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: List.generate(5, (starIndex) {
                                  return Icon(
                                    Icons.star,
                                    color: starIndex < category.get('review')
                                        ? Colors.yellow
                                        : Colors.white,
                                    size: 15.0,
                                  );
                                }),
                              ),
                            ],
                          ),
                          isAccepted
                              ? const StatusTag(
                                  text: "Accepted",
                                  color: AppColors.primaryColor,
                                )
                              : isRequested
                                  ? const StatusTag(
                                      text: "Requested",
                                      color: AppColors.secondaryColor,
                                    )
                                  : const SizedBox(),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.get('taskName'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                          ),
                          Text(
                            category.get('serviceDescription'),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11.0,
                            ),
                          ),
                          const Divider(
                            color: AppColors.backgroundColor,
                          ),
                          IconText(
                            text: category.get('location'),
                            icon: Icons.location_on,
                          ),
                          const SizedBox(height: 5.0),
                          IconText(
                            text: DateFormat('MMM d, y').format(
                              (category.get('dateOfRequest') as Timestamp)
                                  .toDate(),
                            ),
                            icon: Icons.calendar_today,
                          ),
                          isAccepted
                              ? IconButton(
                                  color: Colors.white,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ChatScreen(
                                            requestUserId:
                                                category.get('requestedUser'),
                                            serviceId: category.id,
                                            chatId: category.get('chatId'),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.chat),
                                )
                              : const SizedBox()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class StatusTag extends StatelessWidget {
  const StatusTag({
    super.key,
    required this.text,
    required this.color,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12.0,
        ),
      ),
    );
  }
}
