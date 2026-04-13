import 'package:flutter/material.dart';
import 'package:theologia_app_1/components/globalscaffold.dart';
import 'package:theologia_app_1/components/recentdevotionscard.dart';
import 'package:theologia_app_1/components/todaydevotions.dart';
import 'package:theologia_app_1/main.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:theologia_app_1/components/globalscaffold.dart';
import 'package:theologia_app_1/components/recentdevotionscard.dart';
import 'package:theologia_app_1/models/devotion_model.dart';
import 'package:theologia_app_1/services/firestore.dart';
import 'package:theologia_app_1/main.dart';

class Devotionpage extends StatefulWidget {
  const Devotionpage({super.key});

  @override
  State<Devotionpage> createState() => _DevotionpageState();
}

class _DevotionpageState extends State<Devotionpage> {
  final FirestoreService firestore = FirestoreService();

  final ScrollController _scrollController = ScrollController();

  final List<DevotionModel> devotions = [];

  DocumentSnapshot? lastDocument;

  bool isLoading = false;
  bool hasMore = true;

  final int limit = 10;

  @override
  void initState() {
    super.initState();

    _loadDevotions();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 300) {
        _loadDevotions();
      }
    });
  }

  Future<void> _loadDevotions() async {
    if (isLoading || !hasMore) return;

    setState(() => isLoading = true);

    Query query = FirebaseFirestore.instance
        .collection('Devotions')
        .where('isPublished', isEqualTo: true)
        .orderBy('episodeData', descending: true)
        .limit(limit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument!);
    }

    final snapshot = await query.get();

    if (snapshot.docs.isNotEmpty) {
      lastDocument = snapshot.docs.last;

      final newDevotions = snapshot.docs
          .map((doc) => DevotionModel.fromFirestore(
              doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();

      devotions.addAll(newDevotions);

      if (snapshot.docs.length < limit) {
        hasMore = false;
      }
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Globalscaffold(
      title: '',
      body: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.all(15),
        children: [

          /// TODAY'S DEVOTION
          StreamBuilder<DevotionModel?>(
            stream: firestore.streamTodayDevotion(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox(height: 210);
              }

              final devotion = snapshot.data!;

              return SizedBox(
                height: 210,
                width: double.infinity,
                child: TodaysDevotionContainer(
                  title: devotion.episodeName ?? "",
                  subtitle: devotion.episodeDesc ?? "",
                  imageUrl: devotion.episodeCoverUrl ?? "",
                  id: devotion.id, 
                  audioUrl: devotion.episodeUrl,
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          /// HEADER
          Text(
            'ALL DEVOTIONS',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
          ),

          const SizedBox(height: 15),

          /// PAGINATED DEVOTIONS
          ...devotions.skip(1).map((devotion) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: RecentDevotionCard(
                title: devotion.episodeName ?? "",
                subtitle:
                    "${devotion.episodeName ?? ''} • ${devotion.episodeduration ?? ''}",
                date: devotion.episodeDate.toString() ?? "",
                imageUrl: devotion.episodeCoverUrl ?? "", 
                id: devotion.id, 
                audioUrl: devotion.episodeUrl,
              ),
            );
          }),

          /// LOADER
          if (isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}




class VerseContainer2 extends StatelessWidget {
  final String verse;
  const VerseContainer2({super.key, required this.verse});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color.fromARGB(255, 222, 221, 221))
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(verse),
      )
    );
  }
}