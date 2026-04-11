import 'package:cloud_firestore/cloud_firestore.dart';

class DevotionModel {
  final String id;
  final String? slug; // ✅ NEW

  final DateTime episodeDate;
  final bool episodeIsToday;
  final String episodeName;
  final String episodeNo;
  final String episodeduration;
  final DocumentReference? episodeSpeaker;
  final String episodeTranscript;
  final String episodeUrl;
  final bool isPublished;
  final String? episodeCoverUrl;
  final String? episodeDesc; // Optional field for speaker's name

  final String? episodesongTitle;
  final String? episodesongArtist;
  final String? episodesongUrl;

  final String? verseReference;
  final String? verse;


  DevotionModel({
    required this.id,
        this.slug, // ✅ NEW

    required this.episodeDate,
    required this.episodeIsToday,
    required this.episodeName,
    required this.episodeNo,
    required this.episodeSpeaker,
    required this.episodeTranscript,
    required this.episodeUrl,
    required this.isPublished,
    required this.episodeCoverUrl, 
    required this.episodeduration, 
    this.episodeDesc,
    this.episodesongTitle,
    this.episodesongArtist,
    this.episodesongUrl,
    this.verseReference,
    this.verse
  });

  factory DevotionModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;

    return DevotionModel(
      id: doc.id,
            slug: data['slug'], // ✅ ADD THIS

      episodeDate:
          (data['episodeData'] as Timestamp).toDate(),
      episodeDesc: data['episodeDesc'], // Optional field for speaker's name
      episodeduration: data['episodeduration'] ?? '',
      episodeIsToday: data['episodeIsToday'] ?? false,
      episodeName: data['episodeName'] ?? '',
      episodeNo: data['episodeNo'] ?? '',
      episodeSpeaker: data['episodeSpeaker'],
      episodeTranscript: data['episodeTranscript'] ?? '',
      episodeUrl: data['episodeUrl'] ?? '',
      isPublished: data['isPublished'] ?? false, 
      episodeCoverUrl: data['episodeCoverUrl'] ?? '',
      episodesongTitle: data['episodesongTitle'] ?? '',
      episodesongArtist: data['episodesongArtist'] ?? '',
      episodesongUrl: data['episodesongUrl'] ?? '',
      verseReference: data['verseReference'] ?? '',
      verse: data['verse'] ?? '',

    );
  }
}