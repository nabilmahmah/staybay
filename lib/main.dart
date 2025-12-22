import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_theme.dart';
import 'cubits/locale/locale_cubit.dart';
import 'cubits/locale/locale_state.dart';
import 'cubits/theme/theme_cubit.dart';
import 'cubits/theme/theme_state.dart';
import 'screens/account_screen.dart';
import 'screens/add_apartment_screen.dart';
import 'screens/apartment_details_screen.dart';
import 'screens/booking_details_screen.dart';
import 'screens/bookings_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/home_page_screen.dart';
import 'screens/login_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/success_screen.dart';
import 'screens/welcome_screen.dart';
import 'widgets/app_bottom_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeCubit = LocaleCubit();

    return MultiBlocProvider(
      providers: [
        BlocProvider<LocaleCubit>.value(value: localeCubit),
        BlocProvider(create: (context) => ThemeCubit()),
      ],
      child: FutureBuilder(
        future: localeCubit.init(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const MaterialApp(
              home: Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
            );
          }

          return BlocBuilder<LocaleCubit, LocaleState>(
            builder: (context, localeState) {
              return BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, themeState) {
                  return MaterialApp(
                    builder: (context, child) => Directionality(
                      textDirection: localeState.textDirection,
                      child: child!,
                    ),
                    debugShowCheckedModeBanner: false,
                    theme: AppTheme.lightTheme,
                    darkTheme: AppTheme.darkTheme,
                    themeMode: themeState is DarkModeState
                        ? ThemeMode.dark
                        : ThemeMode.light,
                    initialRoute: AppBottomNavBar.routeName,
                    routes: _buildAppRoutes(),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  /// Returns a map of all application routes
  Map<String, WidgetBuilder> _buildAppRoutes() {
    return {  
      WelcomeScreen.routeName: (context) => const WelcomeScreen(),
      LoginScreen.routeName: (context) => const LoginScreen(),
      SignUpScreen.routeName: (context) => const SignUpScreen(),
      HomePage.routeName: (context) => const HomePage(),
      AppBottomNavBar.routeName: (context) => const AppBottomNavBar(),
      SuccessScreen.routeName: (context) {
        final isLogin =
            ModalRoute.of(context)?.settings.arguments as bool? ?? true;
        return SuccessScreen(isLoginSuccess: isLogin);
      },
      AddApartmentScreen.routeName: (context) => const AddApartmentScreen(),
      FavoritesScreen.routeName: (context) => const FavoritesScreen(),
      AccountScreen.routeName: (context) => const AccountScreen(),
      BookingsScreen.routeName: (context) => const BookingsScreen(),
      BookingDetailsScreen.routeName: (context) => BookingsScreen(),
    };
  }
}
