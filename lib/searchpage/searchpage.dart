import 'package:flutter/material.dart';
import 'package:theologia_app_1/articlepage/articlepage.dart';

import 'package:flutter/material.dart';
import 'package:theologia_app_1/searchpage/searchresultpage.dart';

class SearchPage extends StatefulWidget implements PreferredSizeWidget {
  const SearchPage({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final TextEditingController controller = TextEditingController();

  void _search(String query) {

    if (query.trim().isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchResultsPage(query: query),
      ),
    );
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

              /// Search Bar
              SearchBar(
                controller: controller,
                leading: const Icon(Icons.search,color: Colors.grey),
                hintText: 'Search articles, topics, categories...',
                backgroundColor: const WidgetStatePropertyAll(Colors.white),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onSubmitted: _search,
              ),

              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 20),

              /// Recent Searches
              Row(
                children: [
                  const Icon(Icons.access_time,color: Colors.grey,size: 18),
                  const SizedBox(width: 10),
                  Text(
                    'Recent Searches',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 15,fontWeight: FontWeight.w500),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              Row(
                children: [
                  SuggestionButton(topic: 'Grace', onTap: _search),
                  const SizedBox(width: 10),
                  SuggestionButton(topic: 'Holy Spirit', onTap: _search),
                ],
              ),

              const SizedBox(height: 10),

              SuggestionButton(topic: 'Biblical Manhood', onTap: _search),

              const SizedBox(height: 30),

              /// Trending
              Row(
                children: [
                  const Icon(Icons.trending_up,color: Color(0xFF642E1A)),
                  const SizedBox(width: 10),
                  Text(
                    'Trending Topics',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 15,fontWeight: FontWeight.w500),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  SuggestionButton2(topic: 'Holy Spirit', onTap: _search),
                  SuggestionButton2(topic: 'Grace', onTap: _search),
                  SuggestionButton2(topic: 'Faith', onTap: _search),
                  SuggestionButton2(topic: 'Prayer', onTap: _search),
                  SuggestionButton2(topic: 'Salvation', onTap: _search),
                  SuggestionButton2(topic: 'Trinity', onTap: _search),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class SuggestionButton2 extends StatelessWidget {

  final String topic;
  final Function(String) onTap;

  const SuggestionButton2({
    super.key,
    required this.topic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return ElevatedButton(
      onPressed: () => onTap(topic),

      style: const ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Color(0xFFEFEBE6)),
        side: WidgetStatePropertyAll(
            BorderSide(color: Color(0xFFE7D4CD))),
        elevation: WidgetStatePropertyAll(0),
      ),

      child: Padding(
        padding: const EdgeInsets.fromLTRB(0,10,0,10),
        child: Text(topic,
            style: const TextStyle(color: Colors.black,fontSize: 13)),
      ),
    );
  }
}

class SuggestionButton extends StatelessWidget {

  final String topic;
  final Function(String) onTap;

  const SuggestionButton({
    super.key,
    required this.topic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return ElevatedButton(
      onPressed: () => onTap(topic),

      style: ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll(Colors.white),
        side: const WidgetStatePropertyAll(
            BorderSide(color: Color.fromARGB(255,219,218,218))),
        elevation: const WidgetStatePropertyAll(0),
      ),

      child: Padding(
        padding: const EdgeInsets.fromLTRB(0,10,0,10),
        child: Text(topic,
            style: const TextStyle(color: Colors.black,fontSize: 13)),
      ),
    );
  }
}