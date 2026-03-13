import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/singlearticlemodel.dart';

class ArticleRepository {
  final FirebaseFirestore _db;

  ArticleRepository(this._db);

  Future<Singlearticlemodel?> fetchArticle(String articleId) async {

    print("📡 ArticleRepository.fetchArticle START");
    print("📡 Fetching articleId: $articleId");

    try {

      final doc = await _db
          .collection('Articles')
          .doc(articleId)
          .get();

      print("📡 Firestore GET completed");

      if (!doc.exists) {
        print("❌ Article doc does not exist");
        return null;
      }

      final data = doc.data();

      if (data == null) {
        print("❌ Article data is null");
        return null;
      }

      if (data['isPublished'] != true) {
        print("❌ Article not published");
        return null;
      }

      print("✅ Article parsed successfully");

      return Singlearticlemodel.fromFirestore(doc);

    } catch (e, stack) {

      print("🔥 ERROR inside fetchArticle");
      print(e);
      print(stack);

      return null;
    }
  }
}