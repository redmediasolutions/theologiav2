import 'package:cloud_firestore/cloud_firestore.dart';

class HomeSectionModel {
  final String id;
  final String title;
  final String description;
  final String collectionId;
  final int order;
  final bool isActive;
  final DateTime? createdAt;

  HomeSectionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.collectionId,
    required this.order,
    required this.isActive,
    this.createdAt,
  });

  /// 🔥 FROM FIRESTORE
  factory HomeSectionModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();

    return HomeSectionModel(
      id: doc.id,
      title: data?['title'] ?? '',
      description: data?['description'] ?? '',
      collectionId: data?['collectionId'] ?? '',
      order: data?['order'] ?? 0,
      isActive: data?['isActive'] ?? true,
      createdAt: (data?['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  /// 🔥 TO FIRESTORE (useful later)
  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "description": description,
      "collectionId": collectionId,
      "order": order,
      "isActive": isActive,
      "createdAt": createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  /// 🔥 COPY WITH (for updates later)
  HomeSectionModel copyWith({
    String? title,
    String? description,
    String? collectionId,
    int? order,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return HomeSectionModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      collectionId: collectionId ?? this.collectionId,
      order: order ?? this.order,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}