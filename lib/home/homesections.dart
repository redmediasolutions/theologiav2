import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:theologia_app_1/home/homesectionblock.dart';
import 'package:theologia_app_1/models/homesection_model.dart';
import 'package:theologia_app_1/services/firestore.dart';

class HomeSectionsWidget extends StatelessWidget {
  const HomeSectionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("🏠 HomeSectionsWidget build() called");

    return 
    
    StreamBuilder<List<HomeSectionModel>>(
  stream: FirestoreService().streamHomeSections(),
  builder: (context, snapshot) {
    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const SizedBox.shrink();
    }

    final sections = snapshot.data!;

    return Column(
      children: sections.map((section) {
        return HomeSectionBlock(
          title: section.title,
          description: section.description,
          collectionId: section.collectionId,
        );
      }).toList(),
    );
  },
);
  }
}