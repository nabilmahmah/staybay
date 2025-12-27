abstract class ApartmentState {}

class ApartmentInitial extends ApartmentState {}

class ApartmentLoading extends ApartmentState {}

class ApartmentLoaded extends ApartmentState {
  final List<dynamic> apartments;
  final Map<String, dynamic> pagination;

  ApartmentLoaded({required this.apartments, required this.pagination});
}

class ApartmentError extends ApartmentState {
  final String message;

  ApartmentError(this.message);
}
