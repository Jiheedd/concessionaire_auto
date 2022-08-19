import 'dart:collection';

class CheckBoxModel {
  final String title;
  bool isSelected;
  Map<String, dynamic>? price;
  String? autres;
  Map<String, dynamic>? time;

  CheckBoxModel({
    required this.title,
    this.isSelected = false,
    this.price,
    this.time,
    this.autres,
  });

  // Receive data from server
  factory CheckBoxModel.fromMap(Map<String, dynamic> map) => CheckBoxModel(
    title: map["titre"],
    price: map["prix"],
    time: map["temps"],
    autres: map["autres"],
  );

  // Send data to server
  Map<String, dynamic> toMap() => {
    "titre": title,
    "prix": price,
    "temps": time,
    "autres": autres,
  };
}