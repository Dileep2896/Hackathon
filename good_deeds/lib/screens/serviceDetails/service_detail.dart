import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:good_deeds/apis/database.dart';
import 'package:good_deeds/constants/accent_colors.dart';
import 'package:good_deeds/constants/colors.dart';
import 'package:good_deeds/widgets/icon_text.dart';
import 'package:intl/intl.dart';

class ServiceDetail extends StatefulWidget {
  const ServiceDetail({
    super.key,
    required this.serviceData,
    required this.index,
    required this.isRequested,
  });

  final QueryDocumentSnapshot<Object?> serviceData;
  final int index;
  final bool isRequested;

  @override
  State<ServiceDetail> createState() => _ServiceDetailState();
}

class _ServiceDetailState extends State<ServiceDetail> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor:
            AccentColors.lightAccentColors[widget.serviceData.get('id') % 13],
        title: Text(widget.serviceData.get('taskName')),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: isLoading
          ? const CircularProgressIndicator(
              color: AppColors.primaryColor,
            )
          : Column(
              children: [
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: AccentColors
                        .lightAccentColors[widget.serviceData.get('id') % 13],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(
                              "assets/p${widget.serviceData.get('id') % 13}.png",
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.serviceData.get(
                                  'personName',
                                ),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: List.generate(5, (starIndex) {
                                  return Icon(
                                    Icons.star,
                                    color: starIndex <
                                            widget.serviceData.get('review')
                                        ? Colors.yellow
                                        : Colors.white,
                                    size: 15.0,
                                  );
                                }),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.serviceData.get('taskName'),
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              IconText(
                                text: widget.serviceData.get('location'),
                                icon: Icons.location_on,
                                color: AppColors.textColor,
                              ),
                              const SizedBox(height: 5.0),
                              IconText(
                                text: DateFormat('MMM d, y').format(
                                  (widget.serviceData.get('dateOfRequest')
                                          as Timestamp)
                                      .toDate(),
                                ),
                                icon: Icons.calendar_today,
                                color: AppColors.textColor,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                  widget.serviceData.get('serviceDescription')),
                              const SizedBox(height: 15),
                              Divider(
                                color: AccentColors.lightAccentColors[
                                    widget.serviceData.get('id') % 13],
                              ),
                              const Text(
                                "You can earn",
                                style: TextStyle(
                                  color: AppColors.textColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Row(
                                children: [
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundImage: AssetImage(
                                      "assets/heart_coins.png",
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "5 Coins",
                                    style: TextStyle(
                                      color: AppColors.pinkColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: widget.isRequested
                                    ? Colors.redAccent
                                    : AppColors.primaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  isLoading = true;
                                });
                                DatabaseService()
                                    .addCurrentUserToService(
                                        widget.serviceData.id)
                                    .then((value) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Navigator.pop(context);
                                });
                              },
                              child: Text(
                                widget.isRequested
                                    ? "Cancel Request"
                                    : "Accept",
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
