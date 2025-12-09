import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staybay/cubits/locale/locale_cubit.dart';
import 'package:staybay/cubits/locale/locale_state.dart';
import 'package:staybay/screens/login_screen.dart';
import 'package:staybay/screens/sign_up_screen.dart';
import '../app_theme.dart';
import '../widgets/custom_primary_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const String routeName = '/welcome';

  void _navigateToLogin(BuildContext context) {
    Navigator.of(context).pushNamed(LoginScreen.routeName);
  }

  void _navigateToSignUp(BuildContext context) {
    Navigator.of(context).pushNamed(SignUpScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topSectionHeight = screenHeight * 0.59;
    final theme = Theme.of(context);

    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: topSectionHeight,
                  width: double.infinity,
                  child: ClipPath(
                    clipper: WelcomeClipper(),
                    child: Container(
                      color: theme.colorScheme.primary,
                      width: double.infinity,
                      height: double.infinity,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.home_work,
                              size: 100,
                              color: Colors.white,
                            ),
                            const SizedBox(height: AppSizes.paddingSmall),
                            const Text(
                              'STAY BAY',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                              ),
                            ),

                            Text(
                              'Dream House',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: AppSizes.fontSizeSubtitle,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.05),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingLarge,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        state.localizedStrings['welcome']['WELCOME'] ??
                            'WELCOME',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppSizes.paddingSmall),

                      Text(
                        state.localizedStrings['welcome']['des1'] ??
                            'Find your next space, Feel at home',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: AppSizes.fontSizeLabel,

                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSizes.paddingSmall / 2),
                      Text(
                        state.localizedStrings['welcome']['des2'] ??
                            'Where comfort meets convenience',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: AppSizes.fontSizeLabel,

                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSizes.paddingExtraLarge),

                      CustomPrimaryButton(
                        text:
                            state.localizedStrings['welcome']['login'] ??
                            'Login',
                        onPressed: () => _navigateToLogin(context),
                      ),

                      const SizedBox(height: AppSizes.paddingMedium),

                      SizedBox(
                        width: double.infinity,
                        height: AppSizes.buttonHeight,
                        child: OutlinedButton(
                          onPressed: () => _navigateToSignUp(context),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: theme.scaffoldBackgroundColor,
                            side: BorderSide(
                              color: theme.colorScheme.outline,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppSizes.borderRadiusLarge * 2,
                              ), // 24.0
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            state.localizedStrings['welcome']['signup'] ??
                                'Sign Up',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: AppSizes.fontSizeButton,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.paddingExtraLarge),
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
}

class WelcomeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, 0);
    path.lineTo(0, size.height * 0.82);

    var controlPoint = Offset(size.width / 2, size.height * 0.99);
    var endPoint = Offset(size.width, size.height * 0.82);

    path.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
