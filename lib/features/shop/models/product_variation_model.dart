// ignore_for_file: prefer_null_aware_operators

import 'package:flutter/material.dart';

class ProductOption {
  final String name;
  final Color? color;

  ProductOption({required this.name, this.color});

  // Factory method to create a ProductOption from JSON data
  factory ProductOption.fromJson(Map<String, dynamic> json) {
    return ProductOption(
      name: json['name'] ?? 'Unknown', // Provide a default value if 'name' is null
      color: json['color'] != null ? getColorFromName(json['color']) : null,
    );
  }
   Map<String, dynamic> toJson() {
    return {
      'name': name,
      'color': color != null ? color!.toString() : null,
    };
  }

}

// Function to convert color names to Color objects
Color? getColorFromName(String colorName) {
  switch (colorName.toLowerCase()) {
    case 'red':
      return Colors.red;
    case 'black':
      return Colors.black;
    case 'blue':
      return Colors.blue;
    case 'green':
      return Colors.green;
    case 'yellow':
      return Colors.yellow;
    case 'purple':
      return Colors.purple;
    case 'orange':
      return Colors.orange;
    case 'pink':
      return Colors.pink;
    case 'brown':
      return Colors.brown;
    case 'grey':
    case 'gray':
      return Colors.grey;
    case 'cyan':
      return Colors.cyan;
    case 'teal':
      return Colors.teal;
    case 'indigo':
      return Colors.indigo;
    case 'lime':
      return Colors.lime;
    case 'amber':
      return Colors.amber;
    case 'deepOrange':
      return Colors.deepOrange;
    case 'lightBlue':
      return Colors.lightBlue;
    case 'lightGreen':
      return Colors.lightGreen;
    case 'deepPurple':
      return Colors.deepPurple;
    case 'blueGrey':
      return Colors.blueGrey;
    // Add more colors as needed
    default:
      return null; // Return null for unknown colors
  }
}
