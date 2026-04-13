import 'package:flutter/material.dart';
import 'package:theologia_app_1/components/collectionbutton.dart';
import 'package:theologia_app_1/models/collection_model.dart';
import 'package:theologia_app_1/services/firestore.dart';

class Collectionsforhome extends StatelessWidget {
  const Collectionsforhome({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
                  children: [
                    Icon(Icons.grid_3x3_rounded, color: Colors.brown),
                    SizedBox(width: 10),
                    Text(
                      'Collections',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_right_outlined),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 150,
                  child: StreamBuilder<List<CollectionModel>>(
                    stream: FirestoreService().streamCollectionsforHome(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox.shrink();
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      final collections = snapshot.data!;

                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        //padding: const EdgeInsets.symmetric(horizontal: ),
                        itemCount: collections.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 20),
                        itemBuilder: (context, index) {
                          final collection = collections[index];

                          return CategoriesButton(
                            topic: collection.title,
                            id: collection.id,
                            iconPath: collection.collectionicon,
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
      ],
    );
  }
}