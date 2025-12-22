import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:staybay/cubits/locale/locale_cubit.dart';
import 'package:staybay/cubits/locale/locale_state.dart';
import '../app_theme.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_primary_button.dart';
import 'login_screen.dart';
import 'success_screen.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/signup';

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordObscured = true;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();

  Map<String, dynamic> get locale =>
      context.read<LocaleCubit>().state.localizedStrings['singup'];
  // late var locale = BlocProvider.of<LocaleCubit>(
  //   context,
  
  // ).state.localizedStrings['singup'];

  // LocaleState localeState = context.read<LocaleState>().localizedStrings;
  // @override
  // void dispose() {
  //   _firstNameController.dispose();
  //   _lastNameController.dispose();
  //   _phoneController.dispose();
  //   _passwordController.dispose();
  //   _dateOfBirthController.dispose();
  //   super.dispose();
  // }

  Future<void> _selectDateOfBirth() async {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryColor = theme.primaryColor;

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('en'),

      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: isDarkMode
              ? ThemeData.dark().copyWith(
                  colorScheme: ColorScheme.dark(
                    primary: primaryColor,
                    onPrimary: Colors.white,
                    surface: Colors.black,
                    onSurface: Colors.white,
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(foregroundColor: primaryColor),
                  ),
                )
              : Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: primaryColor,
                    onPrimary: Colors.white,
                    onSurface: theme.textTheme.bodyLarge!.color!,
                  ),
                ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        _dateOfBirthController.text =
            "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
      });
    }
  }

  File? _profileImage, _idImage;
  String? _profileImageString, _idImageString;
  final picker = ImagePicker();

  Future<void> _pickImage(bool isProfileImage) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (isProfileImage) {
          _profileImage = File(pickedFile.path);
          _profileImageString = pickedFile.path;
        } else {
          _idImage = File(pickedFile.path);
          _idImageString = pickedFile.path;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              locale['imageSelected'] ?? 'Image selected successfully',
            ),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(locale["No image selected"] ?? "No image selected."),
        ),
      );
    }
  }

  void _handleSignUp() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_profileImageString == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              locale['profileRequired'] ?? 'Please select profile image.',
            ),
          ),
        );
        return;
      }
      if (_idImageString == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              locale['idRequired'] ?? 'Please select identity image.',
            ),
          ),
        );
        return;
      }

      Navigator.of(
        context,
      ).pushNamed(SuccessScreen.routeName, arguments: false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            locale['allRequired'] ?? 'Please fill all required fields',
          ),
        ),
      );
    }
  }

  Widget _buildImagePickerField(
    String labelText,
    File? image,
    VoidCallback onSelect,
    VoidCallback onReset,
  ) {
    bool isImageSelected = image != null;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText, style: theme.textTheme.labelLarge),
        const SizedBox(height: AppSizes.paddingSmall),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                isImageSelected
                    ? locale["Image Selected"] ?? 'Image Selected'
                    : locale['No image selected'] ?? 'No image selected yet',
                style: TextStyle(
                  color: isImageSelected
                      ? theme.primaryColor
                      : theme.colorScheme.onSurfaceVariant,
                  fontStyle: isImageSelected
                      ? FontStyle.normal
                      : FontStyle.italic,
                  fontSize: AppSizes.fontSizeLabel,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSizes.paddingSmall),

            OutlinedButton.icon(
              onPressed: onSelect,
              icon: const Icon(Icons.file_upload_outlined, size: 18),
              label: Text(locale['selectImage'] ?? 'Select Image'),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.primaryColor,
                side: BorderSide(color: theme.primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppSizes.borderRadiusSmall,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingSmall,
                  vertical: 0,
                ),
              ),
            ),
            const SizedBox(width: 5),

            if (isImageSelected)
              OutlinedButton(
                onPressed: onReset,
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                  side: BorderSide(color: theme.colorScheme.error),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppSizes.borderRadiusSmall,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingSmall,
                    vertical: 0,
                  ),
                ),
                child: Text(locale['resetImage'] ?? 'Reset'),
              ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingMedium,
                vertical: AppSizes.paddingLarge,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: screenWidth > 600 ? 500 : screenWidth,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth > 600 ? AppSizes.paddingLarge : 0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              locale['title'] ?? 'Sign Up',
                              style: AppStyles.titleStyle.copyWith(
                                color: theme.textTheme.titleLarge!.color,
                              ),
                            ),

                            TextButton(
                              onPressed: () {
                                String newLanguage =
                                    state.currentLanguage == 'EN' ? 'AR' : 'EN';
                                context.read<LocaleCubit>().changeLanguage(
                                  newLanguage,
                                );
                              },
                              child: Text(
                                state.currentLanguage,
                                style: TextStyle(
                                  color: theme.textTheme.titleLarge!.color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppSizes.fontSizeLabel,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.paddingExtraLarge),

                        Center(
                          child: GestureDetector(
                            onTap: () {
                              _pickImage(true);
                              log(_profileImage.toString());
                              _profileImageString = _profileImage.toString();
                            },
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: primaryColor,
                                      width: 3.0,
                                    ),
                                    image: _profileImage != null
                                        ? DecorationImage(
                                            image: FileImage(_profileImage!),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: _profileImage == null
                                      ? Icon(
                                          Icons.person,
                                          size: 50,
                                          color: primaryColor,
                                        )
                                      : null,
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_profileImageString != null)
                          Center(
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _profileImage = null;
                                  _profileImageString = null;
                                });
                              },
                              child: Text(
                                locale['resetImage'] ?? 'Reset',
                                style: TextStyle(
                                  color: theme.colorScheme.error,
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: AppSizes.paddingExtraLarge),

                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              CustomTextField(
                                controller: _firstNameController,
                                hintText: locale['firstName'] ?? 'First Name',
                                keyboardType: TextInputType.text,
                                maxLength: 20,
                                suffixIcon: Icon(
                                  Icons.person_outline,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return locale['required'] ??
                                        'This field is required';
                                  }
                                  if (value.length > 20) {
                                    return locale['nameLengthError'] ??
                                        'Max 20 characters allowed';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: AppSizes.paddingMedium),

                              CustomTextField(
                                controller: _lastNameController,
                                hintText: locale['lastName'] ?? 'Last Name',
                                keyboardType: TextInputType.text,
                                maxLength: 20,
                                suffixIcon: Icon(
                                  Icons.person_outline,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return locale['required'] ??
                                        'This field is required';
                                  }
                                  if (value.length > 20) {
                                    return locale['nameLengthError'] ??
                                        'Max 20 characters allowed';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: AppSizes.paddingMedium),

                              CustomTextField(
                                controller: _phoneController,
                                hintText: locale['phone'] ?? 'Phone Number',
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                suffixIcon: Icon(
                                  Icons.phone_android_outlined,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return locale['phoneRequired'] ??
                                        'Please enter phone number';
                                  }
                                  if (value.length != 10) {
                                    return locale['phoneLengthError'] ??
                                        'Phone Number must be exactly 10 digits';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: AppSizes.paddingMedium),

                              CustomTextField(
                                controller: _passwordController,
                                hintText: locale['password'] ?? 'Password',
                                isPassword: _isPasswordObscured,
                                maxLength: 16,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return locale['passwordRequired'] ??
                                        'Please enter password';
                                  }
                                  if (value.length < 8 || value.length > 16) {
                                    return locale['passwordLengthError'] ??
                                        'Password must be between 8 and 16 characters';
                                  }
                                  return null;
                                },
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordObscured
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordObscured =
                                          !_isPasswordObscured;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: AppSizes.paddingMedium),
                              CustomTextField(
                                controller: _dateOfBirthController,
                                hintText: locale['dob'] ?? 'Date of Birth',
                                maxLength: 16,
                                keyboardType: TextInputType.datetime,
                                readOnly: true,
                                onTap: _selectDateOfBirth,
                                validator: (value) =>
                                    (value == null || value.isEmpty)
                                    ? locale['required'] ??
                                          'This field is required'
                                    : null,
                                suffixIcon: Icon(
                                  Icons.calendar_today,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: AppSizes.paddingMedium),
                            ],
                          ),
                        ),

                        _buildImagePickerField(
                          locale['idImage'] ?? 'Identity Image',
                          _idImage,
                          () {
                            setState(() {
                              _pickImage(false);
                              _idImageString = _idImage.toString();
                            });
                          },
                          () {
                            setState(() {
                              _idImage = null;
                              _idImageString = null;
                            });
                          },
                        ),
                        const SizedBox(height: AppSizes.paddingExtraLarge),

                        CustomPrimaryButton(
                          text: locale['signUp'] ?? 'Sign Up',
                          onPressed: _handleSignUp,
                        ),
                        const SizedBox(height: AppSizes.paddingMedium),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              locale['haveAccount'] ??
                                  'Already have an account?',
                              style: TextStyle(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(width: 5),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(
                                  context,
                                ).pushNamed(LoginScreen.routeName);
                              },
                              child: Text(
                                locale['login'] ?? 'Login',
                                style: TextStyle(
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
