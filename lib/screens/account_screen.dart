import 'package:flutter/material.dart';
<<<<<<< HEAD
=======
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:staybay/cubits/locale/locale_cubit.dart';
import 'package:staybay/cubits/locale/locale_state.dart';
>>>>>>> 9473d48d8b197490307bbf8f31dd53d47abc0e48
import 'package:staybay/screens/bookings_screen.dart';
import 'package:staybay/screens/favorites_screen.dart';
import 'package:staybay/screens/my_apartments_screen.dart';
import 'package:staybay/screens/welcome_screen.dart';

class AccountScreen extends StatelessWidget {
  static const routeName = '/account';

  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'الملف الشخصي',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: OutlinedButton(
              onPressed: () {
                // ربط تغيير اللغة لاحقًا
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('العربية'),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            /// ===== PROFILE HEADER =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  /// Profile Image
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const CircleAvatar(
                        radius: 68,
                        backgroundImage: AssetImage('assets/profile.jpg'),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {
                          // تغيير الصورة لاحقًا
                        },
                        child: Container(
                          padding: const EdgeInsets.all(9),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 20,
                            color: Colors.white,
                          ),
=======
    var theme = Theme.of(context);
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, localeState) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,

          appBar: AppBar(
            elevation: 0,
            backgroundColor: theme.scaffoldBackgroundColor,
            centerTitle: true,
            title: Text(
              'الملف الشخصي',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  String newLanguage = localeState.currentLanguage == 'EN'
                      ? 'AR'
                      : 'EN';
                  context.read<LocaleCubit>().changeLanguage(newLanguage);
                },
                child: Text(
                  localeState.currentLanguage,
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          body: SingleChildScrollView(
            child: Column(
              children: [
                /// ===== PROFILE HEADER =====
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    children: [
                      /// Profile Image
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          const CircleAvatar(
                            radius: 68,
                            backgroundImage: AssetImage('assets/profile.jpg'),
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () {
                              // تغيير الصورة لاحقًا
                            },
                            child: Container(
                              padding: const EdgeInsets.all(9),
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      /// Name
                      const Text(
                        'الاسم الكامل',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      /// Phone
                      Text(
                        '+963 9XX XXX XXX',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
>>>>>>> 9473d48d8b197490307bbf8f31dd53d47abc0e48
                        ),
                      ),
                    ],
                  ),
<<<<<<< HEAD

                  const SizedBox(height: 16),

                  /// Name
                  const Text(
                    'الاسم الكامل',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// Phone
                  Text(
                    '+963 9XX XXX XXX',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// ===== ACTIONS =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _profileTile(
                    icon: Icons.apartment,
                    title: 'عقاراتي',
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(MyApartmentsScreen.routeName);
                    },
                  ),
                  _profileTile(
                    icon: Icons.bookmark_border,
                    title: 'حجوزاتي',
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(BookingsScreen.routeName);
                    },
                  ),

                  _profileTile(
                    icon: Icons.dark_mode_outlined,
                    title: 'تبديل الوضع',
                    onTap: () {
                      // تبديل الثيم لاحقًا
                    },
                  ),

                  _profileTile(
                    icon: Icons.logout,
                    title: 'تسجيل الخروج',
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(WelcomeScreen.routeName);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
=======
                ),

                const SizedBox(height: 30),

                /// ===== ACTIONS =====
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _profileTile(
                        icon: Icons.favorite_border,
                        title: 'المفضلة',
                        onTap: () {
                          Navigator.of(
                            context,
                          ).pushNamed(FavoritesScreen.routeName);
                        },
                      ),

                      _profileTile(
                        icon: Icons.bookmark_border,
                        title: 'حجوزاتي',
                        onTap: () {
                          Navigator.of(
                            context,
                          ).pushNamed(BookingsScreen.routeName);
                        },
                      ),

                      _profileTile(
                        icon: Icons.dark_mode_outlined,
                        title: 'تبديل الوضع',
                        onTap: () {
                          // تبديل الثيم لاحقًا
                        },
                      ),

                      _profileTile(
                        icon: Icons.logout,
                        title: 'تسجيل الخروج',
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('isLoggedIn', false);
                          Navigator.of(
                            context,
                          ).pushNamed(WelcomeScreen.routeName);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
>>>>>>> 9473d48d8b197490307bbf8f31dd53d47abc0e48
    );
  }

  /// ===== PROFILE TILE =====
  Widget _profileTile({
<<<<<<< HEAD
=======
    context,
>>>>>>> 9473d48d8b197490307bbf8f31dd53d47abc0e48
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
<<<<<<< HEAD
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
=======
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.05),
>>>>>>> 9473d48d8b197490307bbf8f31dd53d47abc0e48
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
<<<<<<< HEAD
=======
            crossAxisAlignment: CrossAxisAlignment.center,
>>>>>>> 9473d48d8b197490307bbf8f31dd53d47abc0e48
            children: [
              Icon(icon, size: 26, color: Colors.blue),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
<<<<<<< HEAD
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
=======
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
>>>>>>> 9473d48d8b197490307bbf8f31dd53d47abc0e48
            ],
          ),
        ),
      ),
    );
  }
}
