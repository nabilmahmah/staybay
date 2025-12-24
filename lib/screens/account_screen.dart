import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staybay/cubits/locale/locale_cubit.dart';
import 'package:staybay/cubits/locale/locale_state.dart';
import 'package:staybay/screens/bookings_screen.dart';
import 'package:staybay/screens/my_apartments_screen.dart';
import 'package:staybay/screens/welcome_screen.dart';
import 'package:staybay/services/logout_service.dart';

class AccountScreen extends StatelessWidget {
  static const routeName = '/account';

  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, localeState) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor.withAlpha(240),

          appBar: AppBar(
            elevation: 0,
            backgroundColor: theme.appBarTheme.backgroundColor,
            centerTitle: true,
            title: Text(
              'الملف الشخصي',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: TextButton(
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
                        context,
                        icon: Icons.favorite_border,
                        title: 'شققي',
                        onTap: () {
                          Navigator.of(
                            context,
                          ).pushNamed(MyApartmentsScreen.routeName);
                        },
                      ),

                      _profileTile(
                        context,
                        icon: Icons.bookmark_border,
                        title: 'حجوزاتي',
                        onTap: () {
                          Navigator.of(
                            context,
                          ).pushNamed(BookingsScreen.routeName);
                        },
                      ),

                      _profileTile(
                        context,
                        icon: Icons.dark_mode_outlined,
                        title: 'تبديل الوضع',
                        onTap: () {
                          // تبديل الثيم لاحقًا
                        },
                      ),

                      _profileTile(
                        context,
                        icon: Icons.logout,
                        title: 'تسجيل الخروج',
                        onTap: () async {
                          LogoutService.logout();
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
    );
  }

  /// ===== PROFILE TILE =====
  Widget _profileTile(
    context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor,
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: ListTile(
          onTap: onTap,
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, size: 26, color: Theme.of(context).primaryColor),
          title: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ),
      ),
    );
  }
}
