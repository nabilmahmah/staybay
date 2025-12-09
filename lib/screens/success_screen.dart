import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staybay/cubits/locale/locale_cubit.dart';
import 'package:staybay/cubits/locale/locale_state.dart';
import 'package:staybay/screens/welcome_screen.dart';
import '../app_theme.dart';
import '../widgets/custom_primary_button.dart';
import 'home_page_screen.dart';

class SuccessScreen extends StatelessWidget {
  static const String routeName = '/success';
  final bool isLoginSuccess;

  const SuccessScreen({super.key, this.isLoginSuccess = true});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    final String title = isLoginSuccess
        ? 'Thank you, login succeeded!'
        : 'Thank you, registration succeeded!';
    final String buttonText = 'Go to Home Page';
    final String secondaryText = isLoginSuccess
        ? 'You have successfully logged into your account.'
        : 'Your account has been created successfully.';

    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.paddingLarge),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // لون الإطار الخارجي
                      border: Border.all(color: primaryColor, width: 3.0),
                    ),
                    child: CircleAvatar(
                      radius: screenHeight * 0.1,
                      backgroundColor: primaryColor,
                      child: Icon(
                        Icons.check,
                        size: screenHeight * 0.08,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.05),

                  Text(
                    isLoginSuccess
                        ? state.localizedStrings['Success']['login succeeded'] ??
                              'Thank you, login succeeded!'
                        : state.localizedStrings['Success']['registration succeeded'] ??
                              'Thank you, registration succeeded!',
                    textAlign: TextAlign.center,
                    style: AppStyles.titleStyle.copyWith(
                      fontSize: AppSizes.fontSizeSubtitle * 1.2,
                      color: theme.textTheme.titleLarge!.color,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingSmall),

                  Text(
                    isLoginSuccess
                        ? state.localizedStrings['Success']['successfully logged'] ??
                              'You have successfully logged into your account.'
                        : state.localizedStrings['Success']['created successfully'] ??
                              'Your account has been created successfully.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppSizes.fontSizeLabel,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.08),

                  CustomPrimaryButton(
                    text: buttonText,
                    onPressed: () {
                      if (isLoginSuccess) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          HomePage.routeName,
                          (Route<dynamic> route) => false,
                        );
                      } else {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          WelcomeScreen.routeName,
                          (Route<dynamic> route) => false,
                        );
                      }
                    },
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingMedium,
                    ),
                    child: Text(
                      state.localizedStrings['Success']['agree'] ??
                          'By continuing, you agree to our Terms of Service and Privacy Policy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: AppSizes.fontSizeLabel * 0.9,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
