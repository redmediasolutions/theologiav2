import 'package:flutter/material.dart';
import 'package:theologia_app_1/articlepage/articlepage.dart';
import 'package:theologia_app_1/services/firestore.dart';
import 'package:theologia_app_1/models/articlemodels.dart';
import 'package:theologia_app_1/components/categorytopiccard.dart';

class SearchResultsPage extends StatefulWidget {
  final String query;

  const SearchResultsPage({super.key, required this.query});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {

  final FirestoreService firestore = FirestoreService();
  final TextEditingController _controller = TextEditingController();

  late Future<List<ArticleModel>> results;

  @override
  void initState() {
    super.initState();

    _controller.text = widget.query;

    results = firestore.searchArticles(widget.query);
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;

    setState(() {
      results = firestore.searchArticles(query);
    });
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// SEARCH BAR
              SearchBar(
                controller: _controller,
                leading: const Icon(Icons.search,color: Colors.grey),
                hintText: "Search articles, topics, categories...",
                elevation: const WidgetStatePropertyAll(0),
                backgroundColor: const WidgetStatePropertyAll(Colors.white),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onSubmitted: _performSearch,
              ),

              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 20),

              /// RESULTS
              Expanded(
                child: FutureBuilder<List<ArticleModel>>(

                  future: results,

                  builder: (context, snapshot) {

                    /// LOADING
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    /// ERROR
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Error: ${snapshot.error}"),
                      );
                    }

                    final articles = snapshot.data ?? [];

                    /// EMPTY
                    if (articles.isEmpty) {
                      return const Center(
                        child: Text("No results found"),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// RESULT COUNT
                        Text(
                          "${articles.length} result${articles.length == 1 ? '' : 's'} found",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                        ),

                        const SizedBox(height: 20),

                        /// RESULTS LIST
                        Expanded(
                          child: ListView.builder(
                            itemCount: articles.length,
                            itemBuilder: (context, index) {

                              final article = articles[index];

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),

                                child: GestureDetector(
                                  onTap: () {

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ArticlePage(articleId: article.id),
                                      ),
                                    );

                                  },

                                  child: CategoryTopicCard(
                                    title: article.title,
                                    summary: article.excerpt,
                                    readtime: "5 min read",
                                    date: _formatDate(article.createdAt),
                                    category: "Article",
                                    imageUrl: article.featuredImage ?? "",
                                    views: "0", 
                                    articleId: article.id,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}