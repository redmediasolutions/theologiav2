import 'package:cloud_firestore/cloud_firestore.dart';

class DevotionModel {
  final String id;
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


  DevotionModel({
    required this.id,
    required this.episodeDate,
    required this.episodeIsToday,
    required this.episodeName,
    required this.episodeNo,
    required this.episodeSpeaker,
    required this.episodeTranscript,
    required this.episodeUrl,
    required this.isPublished,
    required this.episodeCoverUrl, 
    required this.episodeduration, this.episodeDesc,
  });

  factory DevotionModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;

    return DevotionModel(
      id: doc.id,
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
    );
  }
}