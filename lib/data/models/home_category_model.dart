import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final String nameTelugu;
  final IconData icon;
  final int documentCount;
  final int expiringCount;
  final bool isCustom;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.nameTelugu,
    required this.icon,
    this.documentCount = 0,
    this.expiringCount = 0,
    this.isCustom = false,
  });

  CategoryModel copyWith({
    String? id,
    String? name,
    String? nameTelugu,
    IconData? icon,
    int? documentCount,
    int? expiringCount,
    bool? isCustom,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nameTelugu: nameTelugu ?? this.nameTelugu,
      icon: icon ?? this.icon,
      documentCount: documentCount ?? this.documentCount,
      expiringCount: expiringCount ?? this.expiringCount,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'name_telugu': nameTelugu,
      'icon_code_point': icon.codePoint,
      'document_count': documentCount,
      'expiring_count': expiringCount,
      'is_custom': isCustom ? 1 : 0,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as String,
      name: map['name'] as String,
      nameTelugu: map['name_telugu'] as String,
      icon: IconData(
        map['icon_code_point'] as int,
        fontFamily: 'MaterialIcons',
      ),
      documentCount: map['document_count'] as int? ?? 0,
      expiringCount: map['expiring_count'] as int? ?? 0,
      isCustom: (map['is_custom'] as int? ?? 0) == 1,
    );
  }
}