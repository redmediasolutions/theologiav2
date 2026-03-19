import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:theologia_app_1/latestdevotion/latestdevotion.dart';

class LatestDevotionLoader extends StatelessWidget {
  const LatestDevotionLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('Devotions')
            .orderBy('createdAt', descending: true)
            .limit(1)
            .get(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No devotions found'));
          }

          final doc = snapshot.data!.docs.first;
          final data = doc.data() as Map<String, dynamic>;

          /// 🔥 Inject ID
          data['id'] = doc.id;

          return LatestDevotion(data: data);
        },
      ),
    );
  }
}