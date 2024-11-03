import 'package:flutter/material.dart';
import 'package:good_deeds/constants/colors.dart';

class OfferingHelp extends StatelessWidget {
  const OfferingHelp({
    super.key,
    required this.name,
    required this.id,
    required this.review,
  });

  final String name;
  final int id;
  final int review;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/p${id % 13}.png'),
                radius: 12,
              ),
              const SizedBox(width: 5.0),
              Text(
                name,
                style: const TextStyle(
                  color: AppColors.textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: List.generate(5, (starIndex) {
              return Icon(
                Icons.star,
                color: starIndex < review ? Colors.red : Colors.grey,
                size: 15.0,
              );
            }),
          ),
        ],
      ),
    );
  }
}
