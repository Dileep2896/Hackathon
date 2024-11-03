import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:good_deeds/apis/database.dart';
import 'package:good_deeds/constants/colors.dart';
import 'package:good_deeds/screens/chat/chat_screen.dart';

class RequestDetails extends StatefulWidget {
  const RequestDetails({
    super.key,
    required this.request,
  });

  final QueryDocumentSnapshot<Object?> request;

  @override
  State<RequestDetails> createState() => _RequestDetailsState();
}

class _RequestDetailsState extends State<RequestDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          widget.request.get('taskName'),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.request.get('personName'),
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    "The request is ${widget.request.get('isOpen') ? 'Open' : 'Closed'}",
                    style: const TextStyle(fontSize: 13, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.request.get('taskName'),
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.request.get('serviceDescription'),
                    style: const TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ],
              ),
            ),
            const Divider(
              color: AppColors.primaryColor,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.request.get('isAccepted')
                        ? StreamBuilder(
                            stream: DatabaseService().getUserDetailsById(
                                widget.request.get('acceptedUser')),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (snapshot.hasError) {
                                return const Text('Error loading user details');
                              }
                              if (!snapshot.hasData) {
                                return const Text('No user details available');
                              }
                              final data = snapshot.data;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Accepted request".toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  'assets/p${data!.get('id') % 13}.png'),
                                              radius: 25,
                                            ),
                                            const SizedBox(width: 10.0),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${data.get('name')}",
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "${data.get('email')}",
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return ChatScreen(
                                                    requestUserId:
                                                        data.get('uid'),
                                                    serviceId:
                                                        widget.request.id,
                                                    chatId: widget.request
                                                        .get('chatId'),
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.chat,
                                            size: 30.0,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            })
                        : StreamBuilder(
                            stream: DatabaseService().getUsersByIds(
                              List<String>.from(
                                widget.request.get('availableUsers'),
                              ),
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (snapshot.hasError) {
                                return const Text('Error loading users');
                              }
                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return const Text('No users in request');
                              }
                              final users = snapshot.data!;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Offering help".toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Column(
                                    children: users.map((user) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                      'assets/p${user.get('id') % 13}.png'),
                                                  radius: 25,
                                                ),
                                                const SizedBox(width: 10.0),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(user.get('name')),
                                                    Row(
                                                      children: List.generate(5,
                                                          (starIndex) {
                                                        return Icon(
                                                          Icons.star,
                                                          color: starIndex <
                                                                  user.get(
                                                                      'review')
                                                              ? Colors.red
                                                              : Colors.grey,
                                                          size: 15.0,
                                                        );
                                                      }),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              decoration: BoxDecoration(
                                                color: AppColors.primaryColor
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                border: Border.all(
                                                  color: AppColors.primaryColor,
                                                ),
                                              ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  DatabaseService()
                                                      .acceptServiceRequest(
                                                    widget.request.id,
                                                    user.get('uid'),
                                                  );
                                                },
                                                child: const Row(
                                                  children: [
                                                    Text(
                                                      "Accept",
                                                      style: TextStyle(
                                                        color: AppColors
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                    SizedBox(width: 5.0),
                                                    Icon(
                                                      Icons.check,
                                                      color: AppColors
                                                          .primaryColor,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              );
                            }),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                        ),
                        child: const Text(
                          "Delete",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
