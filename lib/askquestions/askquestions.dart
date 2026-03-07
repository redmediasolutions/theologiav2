import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AskQuestionBox extends StatelessWidget {
  final String articleId;

  const AskQuestionBox({super.key, required this.articleId});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isAnonymous = user == null || user.isAnonymous;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.question_answer_outlined),

          const SizedBox(width: 12),

          const Expanded(
            child: Text(
              "Have a question about this article?",
            ),
          ),

          StreamBuilder<User?>(
  stream: FirebaseAuth.instance.authStateChanges(),
  builder: (context, snapshot) {

    final user = snapshot.data;
    final isAnonymous = user == null || user.isAnonymous;

    return ElevatedButton(
      onPressed: () {

        if (isAnonymous) {
          context.push('/login');
          return;
        }

        showQuestionDialog(context, articleId);
      },

      child: Text(
        isAnonymous ? "Login to Ask" : "Ask Question",
      ),
    );
  },
)
        ],
      ),
    );
  }
}

void showQuestionDialog(BuildContext context, String articleId) {
  final controller = TextEditingController();

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Ask a Question"),
      content: TextField(
        controller: controller,
        maxLines: 4,
        decoration: const InputDecoration(
          hintText: "Write your question...",
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: const Text("Submit"),
          onPressed: () async {

            final user = FirebaseAuth.instance.currentUser;

            await FirebaseFirestore.instance
                .collection('Articles')
                .doc(articleId)
                .collection('questions')
                .add({
              "question": controller.text,
              "answer": null,
              "userId": user?.uid,
              "askedBy": user?.email,
              "createdAt": FieldValue.serverTimestamp(),
              "answered": false
            });

            Navigator.pop(context);
          },
        )
      ],
    ),
  );
}