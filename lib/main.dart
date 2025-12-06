import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_theme.dart';

import 'cubits/locale/locale_state.dart';
import 'cubits/locale/locale_cubit.dart';
import 'cubits/theme/theme_cubit.dart';
import 'cubits/theme/theme_state.dart';

import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/success_screen.dart';
import 'screens/home_page_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LocaleCubit()),
        BlocProvider(create: (context) => ThemeCubit()),
      ],
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, localeState) {
          return BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              return MaterialApp(
                builder: (context, child) {
                  return Directionality(
                    textDirection: localeState.textDirection,
                    child: child!,
                  );
                },
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeState is DarkModeState
                    ? ThemeMode.dark
                    : ThemeMode.light,

                initialRoute: WelcomeScreen.routeName,
                routes: {
                  WelcomeScreen.routeName: (context) => const WelcomeScreen(),
                  LoginScreen.routeName: (context) => const LoginScreen(),
                  SignUpScreen.routeName: (context) => const SignUpScreen(),
                  HomePage.routeName: (context) => const HomePage(),

                  SuccessScreen.routeName: (context) {
                    final isLogin =
                        ModalRoute.of(context)?.settings.arguments as bool? ??
                        true;
                    return SuccessScreen(isLoginSuccess: isLogin);
                  },
                },
              );
            },
          );
        },
      ),
    );
  }
}
