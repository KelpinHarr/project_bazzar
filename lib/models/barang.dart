import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';

class Barang {
  String name;
  String stand_name;
  Int price;
  Int qty;

  Barang(
      {required this.name,
      required this.stand_name,
      required this.price,
      required this.qty});

  Barang.fromJson(Map<String, Object?> json)
      : this(
            name: json['name']! as String,
            stand_name: json['stand_name']! as String,
            price: json['price']! as Int,
            qty: json['qty']! as Int);

  Barang copyWith({String? name, String? stand_name, Int? price, Int? qty}) {
    return Barang(
        name: name ?? this.name,
        stand_name: stand_name ?? this.name,
        price: price ?? this.price,
        qty: qty ?? this.qty);
  }

  Map<String, Object?> toJson() {
    return {
      'name' : name,
      'stand_name' : stand_name,
      'price' : price,
      'qty' : qty
    };
  }

}
