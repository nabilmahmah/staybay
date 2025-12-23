import 'package:flutter/material.dart';
import '../app_theme.dart';

class SearchFiltersWidget extends StatelessWidget {
  final void Function(String governorate, String city) onLocationSelected;
  final void Function(int beds) onBedsSelected;
  final void Function(int baths) onBathsSelected;
  final void Function(double min, double max) onAreaSelected;
  final void Function(double min, double? max) onPriceSelected;

  const SearchFiltersWidget({
    super.key,
    required this.onLocationSelected,
    required this.onBedsSelected,
    required this.onBathsSelected,
    required this.onAreaSelected,
    required this.onPriceSelected,
  });

 static const Map<String, List<String>> _locations = {

  // ---------------- Damascus ----------------
  'Damascus': [
    'Mazzeh',
    'Mazzeh Villas',
    'Rukn Al-Din',
    'Barzeh',
    'Midan',
    'Kafr Sousa',
    'Abu Rummaneh',
    'Malki',
    'Shaalan',
    'Salhieh',
    'Muhajreen',
    'Qanawat',
    'Bab Touma',
    'Bab Sharqi',
    'Jobar',
    'Qaboun',
    'Tishreen',
    'Dummar',
    'Dummar Project',
    'Mezzeh 86',
    'Kafar Souseh',
    'Zahera',
  ],

  // ---------------- Rif Dimashq ----------------
  'Rif Dimashq': [
    'Douma',
    'Darayya',
    'Qudsaya',
    'Yabroud',
    'Al-Tall',
    'Zabadani',
    'Madaya',
    'Harasta',
    'Saqba',
    'Kafr Batna',
    'Jaramana',
    'Mleiha',
    'Ein Tarma',
    'Nabek',
    'Rankous',
  ],

  // ---------------- Aleppo ----------------
  'Aleppo': [
    'Aziziya',
    'New Aleppo',
    'Suleimaniya',
    'Hamdaneya',
    'Al-Jamiliyah',
    'Al-Sabil',
    'Al-Midan',
    'Al-Shaar',
    'Seif Al-Dawla',
    'Hanano',
    'Ramousah',
    'Karm Al-Jabal',
    'Al-Furqan',
  ],

  // ---------------- Homs ----------------
  'Homs': [
    'Al-Hamra',
    'Al-Zahra',
    'Al-Waer',
    'Inshaat',
    'Baba Amr',
    'Karm Al-Zeitoun',
    'Khaldiyeh',
    'Al-Arman',
  ],

  // ---------------- Hama ----------------
  'Hama': [
    'Al-Hader',
    'Al-Arbaeen',
    'Al-Hamidiya',
    'Bab Qibli',
    'Al-Mourabit',
    'Salamieh',
    'Masyaf',
  ],

  // ---------------- Latakia ----------------
  'Latakia': [
    'Al-Raml Al-Janoubi',
    'Al-Raml Al-Shamali',
    'Al-Azizieh',
    'Project 10',
    'Project 7',
    'Al-Ziraa',
    'Jableh',
    'Qardaha',
  ],

  // ---------------- Tartous ----------------
  'Tartous': [
    'Tartous City',
    'Baniyas',
    'Safita',
    'Sheikh Badr',
    'Duraykish',
  ],

  // ---------------- Idlib ----------------
  'Idlib': [
    'Idlib City',
    'Ariha',
    'Saraqib',
    'Jisr Al-Shughur',
    'Maarrat Misrin',
  ],

  // ---------------- Deir ez-Zor ----------------
  'Deir ez-Zor': [
    'Deir ez-Zor City',
    'Al-Mayadin',
    'Al-Bukamal',
    'Ashara',
  ],

  // ---------------- Raqqa ----------------
  'Raqqa': [
    'Raqqa City',
    'Tal Abyad',
    'Al-Karamah',
  ],

  // ---------------- Hasakah ----------------
  'Al-Hasakah': [
    'Hasakah City',
    'Qamishli',
    'Ras Al-Ain',
    'Malikiyah',
  ],

  // ---------------- Daraa ----------------
  'Daraa': [
    'Daraa City',
    'Daraa Al-Balad',
    'Izraa',
    'Al-Sanamayn',
    'Busra Al-Sham',
  ],

  // ---------------- Sweida ----------------
  'Sweida': [
    'Sweida City',
    'Shahba',
    'Salkhad',
  ],

  // ---------------- Quneitra ----------------
  'Quneitra': [
    'Khan Arnabeh',
    'Baath City',
  ],
};


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: TextEditingController(),
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 52,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              _chip(context, 'Location', Icons.location_on,
                  () => _locationSheet(context)),
              _chip(context, 'Beds', Icons.bed,
                  () => _numberSheet(context, 'Beds')),
              _chip(context, 'Baths', Icons.bathtub,
                  () => _numberSheet(context, 'Baths')),
              _chip(context, 'Area', Icons.square_foot,
                  () => _areaSheet(context)),
              _chip(context, 'Price', Icons.attach_money,
                  () => _priceSheet(context)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _chip(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        avatar: Icon(icon, size: 18, color: theme.colorScheme.primary),
        label: Text(label),
        onPressed: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        ),
      ),
    );
  }

  // ---------------- LOCATION ----------------
  void _locationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.borderRadiusLarge),
        ),
      ),
      builder: (_) {
        return ListView(
          children: _locations.entries.map((entry) {
            return ExpansionTile(
              title: Text(entry.key),
              children: entry.value.map((city) {
                return ListTile(
                  title: Text(city),
                  onTap: () {
                    onLocationSelected(entry.key, city);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            );
          }).toList(),
        );
      },
    );
  }

  // ---------------- BEDS / BATHS --------------------
  void _numberSheet(BuildContext context, String type) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(6, (i) {
            return ListTile(
              title: Text('$i+'),
              onTap: () {
                type == 'Beds'
                    ? onBedsSelected(i)
                    : onBathsSelected(i);
                Navigator.pop(context);
              },
            );
          }),
        );
      },
    );
  }

  // ---------------- AREA ----------------
  void _areaSheet(BuildContext context) {
    const ranges = [
      [0, 50],
      [50, 100],
      [100, 150],
      [150, 300],
      [300, 1000],
    ];

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: ranges.map((r) {
            return ListTile(
              title: Text('${r[0]} – ${r[1]} m²'),
              onTap: () {
                onAreaSelected(r[0].toDouble(), r[1].toDouble());
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  // ---------------- PRICE ----------------
  void _priceSheet(BuildContext context) {
    const ranges = [
      [0, 500],
      [500, 1000],
      [1000, 2000],
      [2000, null],
    ];

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: ranges.map((r) {
            return ListTile(
              title: Text(
                r[1] == null
                    ? '> \$${r[0]}'
                    : '\$${r[0]} – \$${r[1]}',
              ),
              onTap: () {
                onPriceSelected(
                  r[0]!.toDouble(),
                  r[1]?.toDouble(),
                );
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }
}
