import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../screens/home_page_screen.dart';
import '../screens/add_apartment_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/account_screen.dart';

class AppBottomNavBar extends StatefulWidget {
  static const String routeName = 'bottom-bar';

  const AppBottomNavBar({super.key});

  @override
  State<AppBottomNavBar> createState() => _AppBottomNavBarState();
}

class _AppBottomNavBarState extends State<AppBottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    AddApartmentScreen(),
    FavoritesScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Color activeColor = theme.colorScheme.onPrimary;
    final Color inactiveColor = activeColor.withOpacity(0.7);

    return Scaffold(
      // الـ body يحتفظ بحالة كل صفحة عبر IndexedStack
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == _currentIndex) return;
          setState(() {
            _currentIndex = index;
            FavoritesScreen();
          });
        },
        backgroundColor: theme.colorScheme.primary,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: activeColor,
        unselectedItemColor: inactiveColor,
        selectedLabelStyle: AppStyles.labelStyle.copyWith(
          fontSize: AppSizes.fontSizeLabel * 0.9,
          color: activeColor,
        ),  
        unselectedLabelStyle: AppStyles.labelStyle.copyWith(
          fontSize: AppSizes.fontSizeLabel * 0.9,
          color: inactiveColor,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
