import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/singlearticlemodel.dart';

class ArticleRepository {
  final FirebaseFirestore _db;

  ArticleRepository(this._db);

  Future<Singlearticlemodel?> fetchArticle(String articleId) async {
  final doc = await _db
      .collection('Articles')
      .doc(articleId)
      .get();

  if (!doc.exists) return null;

  final data = doc.data();

  if (data == null) return null;

  if (data['isPublished'] != true) return null;

  return Singlearticlemodel.fromFirestore(
    doc,
  );
}
}