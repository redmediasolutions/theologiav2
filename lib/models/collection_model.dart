import 'package:cloud_firestore/cloud_firestore.dart';

class CollectionModel {
  final String id;
  final String title;
  final String description;
  final String? coverImage;
  final int order;
  final String collectionicon;

  CollectionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.coverImage,
    required this.order, 
    required this.collectionicon,
  });

  /// 🔹 Factory constructor from Firestore
  factory CollectionModel.fromFirestore(
      DocumentSnapshot doc) {
    final data =
        doc.data() as Map<String, dynamic>;

    return CollectionModel(
      id: doc.id,
      title: data['name'] ?? '',
      description: data['description'] ?? '',
      coverImage: data['imageUrl'],
      order: data['order'] ?? 0,
      collectionicon: data['collectionicon'] ?? '',
    );
  }

  /// 🔹 Convert to Map (useful later for admin)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'coverImage': coverImage,
      'order': order,
    };
  }
}