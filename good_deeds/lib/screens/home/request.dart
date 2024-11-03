import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:good_deeds/apis/database.dart';
import 'package:good_deeds/constants/colors.dart';
import 'package:good_deeds/screens/add_request.dart';
import 'package:good_deeds/screens/requestDetails/request_details.dart';
import 'package:good_deeds/widgets/offering_help.dart';

class Request extends StatelessWidget {
  const Request({
    super.key,
    required this.userData,
    required this.serviceData,
  });

  final Map<String, dynamic> userData;
  final List<QueryDocumentSnapshot> serviceData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddRequest(
              userData: userData,
            );
          }));
        },
        backgroundColor: AppColors.primaryColor,
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: const Text(
          'Add Request',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView.builder(
          itemCount: serviceData.length,
          itemBuilder: (context, index) {
            final QueryDocumentSnapshot<Object?> request = serviceData[index];
            if (request.get('requestedUser') != userData['uid']) {
              return const SizedBox.shrink();
            }

            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return RequestDetails(
                    request: request,
                  );
                }));
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(request.get('personName')),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              request.get('taskName'),
                              style: const TextStyle(color: Colors.black),
                            ),
                            Text(request.get('serviceDescription')),
                          ],
                        ),
                        trailing: Text(
                          request.get('isOpen') ? "Open" : "Closed",
                        ),
                      ),
                      const Divider(),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: request.get("isAccepted")
                              ? StreamBuilder(
                                  stream: DatabaseService().getUserDetailsById(
                                      request.get('acceptedUser')),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Text('Loading...');
                                    } else if (snapshot.hasError) {
                                      return const Text(
                                          'Error loading user details');
                                    } else if (!snapshot.hasData) {
                                      return const Text(
                                          'No user details found');
                                    }
                                    final data = snapshot.data;
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Accepted Request"),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  'assets/p${data!.get('id') % 13}.png'),
                                              radius: 12,
                                            ),
                                            const SizedBox(width: 5.0),
                                            Text(
                                              data.get('name'),
                                              style: const TextStyle(
                                                color: AppColors.textColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  })
                              : StreamBuilder<List<DocumentSnapshot>>(
                                  stream: DatabaseService().getUsersByIds(
                                      List<String>.from(
                                          request.get('availableUsers'))),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Text('Loading...');
                                    } else if (snapshot.hasError) {
                                      return const Text('Error loading users');
                                    } else if (!snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return const Text('No users in request');
                                    } else {
                                      List<DocumentSnapshot> users =
                                          snapshot.data!;
                                      print("Users $users");
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text("Offering help"),
                                          const SizedBox(height: 5.0),
                                          Column(
                                            children: users.map((user) {
                                              return OfferingHelp(
                                                name: user.get('name'),
                                                id: user.get('id'),
                                                review: user.get('review'),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      );
                                    }
                                  })),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
