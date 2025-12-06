import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staybay/cubits/locale/locale_cubit.dart';
import 'package:staybay/cubits/locale/locale_state.dart';
import 'package:staybay/cubits/theme/theme_cubit.dart';
import 'package:staybay/cubits/theme/theme_state.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themestate) {
        return BlocBuilder<LocaleCubit, LocaleState>(
          builder: (context, localestate) {
            return Scaffold(
              body: Center(
                child: Row(
                  children: [
                    Text(
                      localestate.localizedStrings['welcome']['WELCOME'] ?? '',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    Text(
                      localestate.localizedStrings['des'] ?? '',
                      style: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                    MaterialButton(
                      color: Theme.of(context).primaryColorDark,
                      onPressed: () {
                        String newLanguage = localestate.currentLanguage == 'EN'
                            ? 'AR'
                            : 'EN';
                        context.read<LocaleCubit>().changeLanguage(newLanguage);
                      },
                      child: Text(
                        localestate.localizedStrings['change language'] ?? '',
                      ),
                    ),
                    MaterialButton(
                      color: Theme.of(context).primaryColorDark,
                      onPressed: () {
                        context.read<ThemeCubit>().toggleTheme();
                      },
                      child: Text(
                        localestate.localizedStrings['toggle theme'] ?? '',
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
