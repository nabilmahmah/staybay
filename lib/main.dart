import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:staybay/constants.dart';
import 'package:staybay/core/dio_client.dart';
import 'package:staybay/core/forground_task_service.dart';
import 'package:staybay/core/notification_controller.dart';
import 'package:staybay/cubits/apartments/aparment_cubit.dart';
import 'package:staybay/cubits/user/user_cubit.dart';
import 'package:staybay/screens/loading_screen.dart';
import 'package:staybay/screens/my_apartments_screen.dart';
import 'package:staybay/screens/owner_bookings_screen.dart';
import 'package:staybay/services/local_notification_service.dart';
// import 'package:staybay/test.dart';
// import 'package:staybay/test.dart';

import 'app_theme.dart';
import 'cubits/locale/locale_cubit.dart';
import 'cubits/locale/locale_state.dart';
import 'cubits/theme/theme_cubit.dart';
import 'cubits/theme/theme_state.dart';
import 'screens/account_screen.dart';
import 'screens/add_apartment_screen.dart';
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
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await DioClient.init();
  await ForegroundTaskService.init();
  await LocalNotificationService.init();
  final bool islogin = prefs.getBool(kIsLoggedIn) ?? false;
  final bool isDark = prefs.getBool(kIsDark) ?? false;
  log(islogin.toString());
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();
      runApp(MyApp(islogin: islogin, isDark: isDark));
    },
    (error, stackTrace) {
      print("😎Caught by Zone:$error😎");
      print(stackTrace);
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.islogin, required this.isDark});
  final bool islogin;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final localeCubit = LocaleCubit();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ApartmentCubit()),
        BlocProvider(create: (context) => UserCubit()..getMe()),
        BlocProvider<LocaleCubit>.value(value: localeCubit),
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => NotificationCubit()..startPolling()),
      ],
      child: FutureBuilder(
        future: localeCubit.init(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const MaterialApp(
              home: Scaffold(body: Center(child: CircularProgressIndicator())),
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
                    // themeMode: ThemeMode.dark,
                    themeMode: themeState is DarkModeState
                        ? ThemeMode.dark
                        : themeState is ThemeInitial
                        ? isDark
                              ? ThemeMode.dark
                              : ThemeMode.light
                        : ThemeMode.light,
                    // home: LoadingScreen(),
                    initialRoute: !localeState.isLoaded
                        ? LoadingScreen.routeName
                        : islogin
                        ? AppBottomNavBar.routeName
                        : WelcomeScreen.routeName,
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
      LoadingScreen.routeName: (context) => const LoadingScreen(),
      WelcomeScreen.routeName: (context) => const WelcomeScreen(),
      LoginScreen.routeName: (context) => const LoginScreen(),
      SignUpScreen.routeName: (context) => const SignUpScreen(),
      HomePage.routeName: (context) => HomePage(),
      AppBottomNavBar.routeName: (context) => const AppBottomNavBar(),
      SuccessScreen.routeName: (context) {
        final isLogin =
            ModalRoute.of(context)?.settings.arguments as bool? ?? true;
        return SuccessScreen(isLoginSuccess: isLogin);
      },
      AddApartmentScreen.routeName: (context) => AddApartmentScreen(),
      FavoritesScreen.routeName: (context) => const FavoritesScreen(),
      AccountScreen.routeName: (context) => const AccountScreen(),
      BookingsScreen.routeName: (context) => const BookingsScreen(),
      OwnerBookingsScreen.routeName: (context) => const OwnerBookingsScreen(),
      BookingDetailsScreen.routeName: (context) =>
          BookingDetailsScreen(apartment: null),
      MyApartmentsScreen.routeName: (context) => MyApartmentsScreen(),
    };
  }
}
