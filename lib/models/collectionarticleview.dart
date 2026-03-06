class CollectionArticleViewModel {
  final String itemId;        // collection_articles doc id
  final String articleId;
  final String title;
  final String summary;
  final int order;
  final String? featuredImage;

  CollectionArticleViewModel({
    required this.itemId,
    required this.articleId,
    required this.title,
    required this.summary,
    required this.order,
    this.featuredImage,
  });
}