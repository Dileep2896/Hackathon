import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:good_deeds/constants/accent_colors.dart';
import 'package:good_deeds/constants/colors.dart';
import 'package:good_deeds/constants/gift_card.dart';

class Store extends StatelessWidget {
  const Store({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundImage: AssetImage(
                          "assets/heart_coins.png",
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "150",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "\$15.00",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  )
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppColors.primaryColor,
                  backgroundColor: Colors.white,
                ),
                child: const Row(
                  children: [
                    Icon(Icons.swap_horiz),
                    Text("Convert"),
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(15),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "STORE",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(
                color: AppColors.primaryColor,
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: GridView.builder(
              itemCount: giftCards.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 3 / 2.5,
              ),
              itemBuilder: (context, index) {
                final giftCard = giftCards[index];
                return Card(
                  color: Colors.white,
                  elevation: 0.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      giftCard.logoUrl.endsWith('.svg')
                          ? SvgPicture.network(
                              giftCard.logoUrl,
                              height: 50.0,
                              width: 50.0,
                              placeholderBuilder: (context) =>
                                  const CircularProgressIndicator(),
                              fit: BoxFit.contain,
                            )
                          : Image.network(
                              giftCard.logoUrl,
                              height: 50.0,
                              width: 50.0,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.image_not_supported,
                                  size: 50.0,
                                  color: Colors.grey,
                                );
                              },
                            ),
                      const SizedBox(height: 8.0),
                      Text(
                        giftCard.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8.0),
                      Container(
                        padding: const EdgeInsets.all(5.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AccentColors.lightAccentColors[index % 12],
                        ),
                        child: Center(
                          child: Text(
                            '${giftCard.coinValue} coins = \$${giftCard.dollarValue.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 14.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
