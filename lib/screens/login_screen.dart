import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staybay/cubits/locale/locale_cubit.dart';
import 'package:staybay/cubits/locale/locale_state.dart';
import '../app_theme.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/custom_text_field.dart';
import 'success_screen.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  Map<String, dynamic> get locale =>
  context.read<LocaleCubit>().state.localizedStrings['login'];
  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).pushNamed(SuccessScreen.routeName, arguments: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final verticalSpacer = SizedBox(height: screenHeight * 0.03);

    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.paddingLarge),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: screenWidth > 600 ? 500 : screenWidth,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            locale['title'] ?? 'Login',
                            style: AppStyles.titleStyle.copyWith(
                              fontSize: AppSizes.fontSizeTitle * 0.9,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(
                                context,
                              ).textTheme.titleLarge!.color,
                            ),
                          ),

                          TextButton(
                            onPressed: () {
                              String newLanguage = state.currentLanguage == 'EN'
                                  ? 'AR'
                                  : 'EN';
                              context.read<LocaleCubit>().changeLanguage(
                                newLanguage,
                              );
                            },
                            child: Text(
                              state.currentLanguage,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.05),

                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: screenHeight * 0.06,
                              backgroundColor: Theme.of(
                                context,
                              ).primaryColor.withOpacity(0.1),
                              child: Icon(
                                Icons.home_work_rounded,
                                size: screenHeight * 0.06,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              'STAY BAY',
                              style: AppStyles.titleStyle.copyWith(
                                color: Theme.of(
                                  context,
                                ).textTheme.titleLarge!.color,
                              ),
                            ),
                            Text(
                              'Dream House',
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),

                      verticalSpacer,
                      SizedBox(height: screenHeight * 0.02),

                      Text(
                        locale['title'] ?? 'Login',
                        style: AppStyles.titleStyle.copyWith(
                          fontSize: AppSizes.fontSizeTitle * 0.9,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        locale['subtitle'] ??
                            'Please enter your login details to log in.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.start,
                      ),

                      SizedBox(height: screenHeight * 0.04),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: _phoneController,
                              hintText: locale['phone'] ?? 'Phone Number',
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return state
                                          .localizedStrings['login']['phoneRequired'] ??
                                      'Please enter password';
                                }
                                if (value.length != 10) {
                                  return state
                                          .localizedStrings['login']['phoneLengthError'] ??
                                      'Password must be between 8 and 16 characters';
                                }
                                return null;
                              },
                              suffixIcon: Icon(
                                Icons.phone_android_outlined,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),

                            verticalSpacer,

                            CustomTextField(
                              controller: _passwordController,
                              hintText: locale['password'] ?? 'Password',
                              isPassword: !_isPasswordVisible,
                              keyboardType: TextInputType.visiblePassword,
                              maxLength: 16,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return state
                                          .localizedStrings['login']['passwordRequired'] ??
                                      'Please enter password';
                                }
                                if (value.length < 8 || value.length > 16) {
                                  return state
                                          .localizedStrings['login']['passwordLengthError'] ??
                                      'Password must be between 8 and 16 characters';
                                }
                                return null;
                              },
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),

                            verticalSpacer,

                            CustomPrimaryButton(
                              text: locale['login'] ?? 'Login',
                              onPressed: _handleLogin,
                            ),

                            verticalSpacer,

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  locale['haveAccount'] ??
                                      "Don't have an account?",
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium!.color,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(
                                      context,
                                    ).pushNamed(SignUpScreen.routeName);
                                  },
                                  child: Text(
                                    locale['createAccount'] ?? 'Create account',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
