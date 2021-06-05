import 'package:flutter/material.dart';
import 'package:foodzzz/model/restaurant.dart';
import 'package:foodzzz/reservation_form.dart';

class ReservationPage extends StatelessWidget {
  Restaurant selectedRestaurant;

  ReservationPage({required this.selectedRestaurant});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reservation',
      home: Scaffold(
        appBar: AppBar(
          title: Text("Rezerva acum la " + selectedRestaurant.name),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ReservationForm(),
          ),
        ),
      ),
    );
  }
}
