import 'package:flutter/material.dart';
import 'package:staybay/models/apartment_model.dart';
import 'package:staybay/screens/add_apartment_screen.dart';
import 'package:staybay/services/apartment_service.dart';
import 'package:staybay/widgets/apartment_card.dart';

class MyApartmentsScreen extends StatelessWidget {
  static const routeName = '/my-apartments';
  //for nabil
  // this is for test ---> you should replace it with real data from backend
  List<Apartment> myApartments = ApartmentService.mockApartments;
  MyApartmentsScreen({super.key});
  onTap(context, Apartment apartment) {
    Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AddApartmentScreen(apartmentToEdit: apartment ),
          ),
        );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Apartments')),
      body: ListView.builder(
        itemCount: myApartments.length,
        itemBuilder: (context, index) {
          final apartment = myApartments[index];
          return ApartmentCard(apartment: apartment, onTap: () => onTap(context, apartment),);
        },
      ),
    );
  }
}
