// lib/features/home/model/category_model.dart

import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final String nameTelugu;
  final IconData icon;
  final int documentCount;
  final int expiringCount; // Documents expiring in 30 days

  CategoryModel({
    required this.id,
    required this.name,
    required this.nameTelugu,
    required this.icon,
    this.documentCount = 0,
    this.expiringCount = 0,
  });
}