import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:staybay/widgets/filter_dialog.dart';
import '../app_theme.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  static const String routeName = '/home';

  int? govId;
  int? cityId;
  String? bedrooms;
  String? bathrooms;
  double? pMin;
  double? pMax;
  double? sMin;
  double? sMax;
  double? rMin;
  double? rMax;
  bool pool = false;
  bool wifi = false;
  Future<void> _openFilterDialog(BuildContext context) async {
    final Map<String, dynamic>? results =
        await showDialog<Map<String, dynamic>>(
          context: context,
          barrierDismissible:
              false, // يمنع إغلاق الدايالوج عند الضغط خارجه لضمان اختيار قيم
          builder: (BuildContext context) {
            return FilterDialog();
          },
        );

    if (results != null) {
      govId = results['governorate_id'];
      cityId = results['city_id'];
      bedrooms = results['bedrooms'];
      bathrooms = results['bathrooms'];

      pMin = results['price_min'];
      pMax = results['price_max'];
      sMin = results['size_min'];
      sMax = results['size_max'];
      rMin = results['rating_min'];
      rMax = results['rating_max'];

      pool = results['has_pool'] ?? false;
      wifi = results['has_wifi'] ?? false;

      log("--- نتائج الفلترة النهائية ---");
      log("المحافظة ID: $govId, المدينة ID: $cityId");
      log("السعر: من $pMin إلى $pMax");
      log("المساحة: من $sMin إلى $sMax");
      log("المسبح: $pool, واي فاي: $wifi");

      // _searchApartments(results);
    } else {
      log("قام المستخدم بإلغاء عملية الفلترة");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: _homeAppBar(theme, searchController, context),
      backgroundColor: theme.scaffoldBackgroundColor,
    );
  }

  PreferredSize _homeAppBar(
    ThemeData theme,
    TextEditingController searchController,
    BuildContext context,
  ) {
    return PreferredSize(
      preferredSize: Size.fromHeight(AppSizes.paddingExtraLarge * 2.5),
      child: Container(
        decoration: BoxDecoration(
          color: theme.appBarTheme.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: AppSizes.paddingExtraLarge * 1.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        AppSizes.borderRadiusExtraLarge,
                      ),
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "search",
                        hintStyle: theme.inputDecorationTheme.helperStyle,
                        prefixIcon: Icon(
                          Icons.search,
                          color: theme.inputDecorationTheme.hintStyle?.color,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                      ),
                      style: theme.inputDecorationTheme.counterStyle,
                    ),
                  ),
                ),

                SizedBox(width: AppSizes.paddingSmall),

                IconButton(
                  icon: Icon(
                    Icons.notifications_none,
                    color: theme.appBarTheme.iconTheme!.color,
                  ),
                  onPressed: () {
                    // TODO : Handle notification button press
                  },
                ),

                // الزر الثاني
                IconButton(
                  icon: Icon(
                    Icons.filter_alt_outlined,
                    color: theme.appBarTheme.iconTheme!.color,
                  ),
                  onPressed: () {
                    _openFilterDialog(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
