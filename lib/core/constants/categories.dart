import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryConstants {

  static final List<Category> categories = [
    Category(id: 'groceries', title: 'Groceries', iconName: 'shopping_cart'),
    Category(id: 'entertainment', title: 'Entertainment', iconName: 'local_cafe'),
    Category(id: 'gas', title: 'Gas', iconName: 'local_gas_station'),
    Category(id: 'shopping', title: 'Shopping', iconName: 'shopping_bag'),
    Category(id: 'news', title: 'News Paper', iconName: 'newspaper'),
    Category(id: 'transport', title: 'Transport', iconName: 'directions_car'),
    Category(id: 'rent', title: 'Rent', iconName: 'home'),
    Category(id: 'food', title: 'Food', iconName: 'restaurant'),
    Category(id: 'bills', title: 'Bills', iconName: 'receipt'),
    Category(id: 'other', title: 'Other', iconName: 'category'),
  ];

  static IconData getIconData(String iconName) {
    switch (iconName) {
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'local_cafe':
        return Icons.local_cafe;
      case 'local_gas_station':
        return Icons.local_gas_station;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'newspaper':
        return Icons.newspaper;
      case 'directions_car':
        return Icons.directions_car;
      case 'home':
        return Icons.home;
      case 'restaurant':
        return Icons.restaurant;
      case 'receipt':
        return Icons.receipt;
      case 'category':
        return Icons.category;
      default:
        return Icons.category;
    }
  }

  static Category? getCategoryById(String id) {
    try {
      return categories.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
}

