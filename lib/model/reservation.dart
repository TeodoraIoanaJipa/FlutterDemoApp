import 'package:flutter/material.dart';

class Reservation {
  late int id;
  late int? numberOfPersons;
  late DateTime? reservationDate;
  late TimeOfDay? reservationHour;

  Reservation({this.numberOfPersons, this.reservationDate});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'numberOfPersons': numberOfPersons,
      'reservationDate': reservationDate,
    };
  }
}
