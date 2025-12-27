import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:staybay/cubits/apartments/acpartment_state.dart';
import 'package:staybay/services/get_apartments.dart';

class ApartmentCubit extends Cubit<ApartmentState> {
  ApartmentCubit() : super(ApartmentInitial());

  int currentPage = 1;
  bool hasReachedMax = false;
  bool isLoading = false;

  final List<dynamic> _allApartments = [];

  Future<void> fetchApartments({
    bool refresh = false,
    Map<String, dynamic>? filters,
  }) async {
    // منع الطلبات المتداخلة
    if (isLoading && !refresh) return;

    // ===== Refresh logic =====
    if (refresh) {
      currentPage = 1;
      hasReachedMax = false;
      _allApartments.clear();
    }

    // إذا وصلنا للنهاية لا نكمل
    if (hasReachedMax) return;

    isLoading = true;

    // إظهار loading فقط في الصفحة الأولى
    if (currentPage == 1) {
      emit(ApartmentLoading());
    }

    try {
      final response = await ApartmentService.getApartments(
        page: currentPage,
        governorateId: filters?['governorate_id'],
        cityId: filters?['city_id'],
        bedrooms: filters?['bedrooms'],
        bathrooms: filters?['bathrooms'],
        priceMin: filters?['price_min'],
        priceMax: filters?['price_max'],
        sizeMin: filters?['size_min'],
        sizeMax: filters?['size_max'],
        ratingMin: filters?['rating_min'],
        ratingMax: filters?['rating_max'],
        hasPool: filters?['has_pool'],
        hasWifi: filters?['has_wifi'],
        search: filters?['search'],
      );

      final List newApartments = response['data'];
      final pagination = response['pagination'];

      _allApartments.addAll(newApartments);

      hasReachedMax = pagination['current_page'] >= pagination['last_page'];

      currentPage++;

      emit(
        ApartmentLoaded(
          apartments: List.from(_allApartments),
          pagination: pagination,
        ),
      );
    } catch (e) {
      emit(ApartmentError(e.toString()));
    } finally {
      isLoading = false;
    }
  }

  Future<void> refreshApartments(Map<String, dynamic>? filters) async {
    await fetchApartments(refresh: true, filters: filters);
  }
}
