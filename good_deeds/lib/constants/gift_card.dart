// gift_card_conversion.dart

import 'dart:math';

class GiftCard {
  final String name;
  final String logoUrl;
  final int coinValue;

  GiftCard({
    required this.name,
    required this.logoUrl,
    required this.coinValue,
  });

  double get dollarValue => coinValue / 10;
}

final Random _random = Random();

int getRandomCoinValue() =>
    50 + _random.nextInt(151); // Random value between 50 and 200

const List<Map<String, String>> _companyData = [
  {
    'name': 'Amazon',
    'logoUrl':
        'https://upload.wikimedia.org/wikipedia/commons/a/a9/Amazon_logo.svg'
  },
  {
    'name': 'Nike',
    'logoUrl':
        'https://upload.wikimedia.org/wikipedia/commons/a/a6/Logo_NIKE.svg'
  },
  {
    'name': 'Target',
    'logoUrl':
        'https://upload.wikimedia.org/wikipedia/commons/9/9a/Target_logo.svg'
  },
  {
    'name': 'eBay',
    'logoUrl':
        'https://upload.wikimedia.org/wikipedia/commons/1/1b/EBay_logo.svg'
  },
  {
    'name': 'Walmart',
    'logoUrl':
        'https://upload.wikimedia.org/wikipedia/commons/c/ca/Walmart_logo.svg'
  },
  {
    'name': 'Starbucks',
    'logoUrl':
        'https://upload.wikimedia.org/wikipedia/en/d/d3/Starbucks_Corporation_Logo_2011.svg'
  },
  {
    'name': 'Apple',
    'logoUrl':
        'https://upload.wikimedia.org/wikipedia/commons/f/fa/Apple_logo_black.svg'
  },
  {
    'name': 'Google Play',
    'logoUrl':
        'https://upload.wikimedia.org/wikipedia/commons/7/7a/Google_Play_2022_logo.svg'
  },
  {
    'name': 'Best Buy',
    'logoUrl':
        'https://upload.wikimedia.org/wikipedia/commons/c/c4/Best_Buy_logo_2018.svg'
  },
  {
    'name': 'Home Depot',
    'logoUrl':
        'https://upload.wikimedia.org/wikipedia/commons/5/5f/TheHomeDepot.svg'
  },
  {
    'name': 'Lowe\'s',
    'logoUrl':
        'https://upload.wikimedia.org/wikipedia/commons/2/2c/Lowes_Companies_Logo.svg'
  },
  {
    'name': 'Sephora',
    'logoUrl':
        'https://upload.wikimedia.org/wikipedia/commons/d/d7/Charles_Scribner%27s_Sons.jpg'
  },
  {
    'name': 'Macy\'s',
    'logoUrl':
        'https://upload.wikimedia.org/wikipedia/commons/a/a6/Macy%27s_logo.svg'
  },
  {
    'name': 'Nordstrom',
    'logoUrl':
        'https://upload.wikimedia.org/wikipedia/commons/5/5c/Nordstrom_flagship_pano_01.jpg'
  },
  {
    'name': 'Gap',
    'logoUrl':
        'https://upload.wikimedia.org/wikipedia/commons/c/c8/Gap_Inc._logo_2024.svg'
  },
  {
    'name': 'Old Navy',
    'logoUrl':
        'https://upload.wikimedia.org/wikipedia/commons/d/d3/Old_Navy_Logo.svg'
  },
  {
    'name': 'Banana Republic',
    'logoUrl':
        'https://upload.wikimedia.org/wikipedia/commons/f/fa/Banana_Republic_%2854076909886%29.jpg'
  },
  {
    'name': 'JCPenney',
    'logoUrl':
        'https://upload.wikimedia.org/wikipedia/commons/2/23/JCPenney_logo.svg'
  },
  {
    'name': 'Kohl\'s',
    'logoUrl':
        'https://upload.wikimedia.org/wikipedia/commons/6/60/Kohl%27s_logo.svg'
  },
  {
    'name': 'Bed Bath & Beyond',
    'logoUrl':
        'https://upload.wikimedia.org/wikipedia/en/9/94/Bed_Bath_%26_Beyond_%28logo%29.svg'
  },
];

List<GiftCard> giftCards = _companyData.map((company) {
  return GiftCard(
    name: company['name']!,
    logoUrl: company['logoUrl']!,
    coinValue: getRandomCoinValue(),
  );
}).toList();
