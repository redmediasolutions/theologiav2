import 'package:flutter/material.dart';
import 'package:theologia_app_1/services/updateservice.dart';

class UpdateChecker extends StatefulWidget {
  final Widget child;

  const UpdateChecker({super.key, required this.child});

  @override
  State<UpdateChecker> createState() => _UpdateCheckerState();
}

class _UpdateCheckerState extends State<UpdateChecker> {

  bool showSoftUpdate = false;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {

    final status = await UpdateService.checkForUpdate();

    if (!mounted) return;

    if (status == UpdateStatus.force) {
      _showForceUpdate();
    }

    if (status == UpdateStatus.soft) {
      setState(() {
        showSoftUpdate = true;
      });
    }
  }

  void _showForceUpdate() {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Update Required"),
        content: const Text(
          "Please update the app to continue using Theologia.",
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              // open store
            },
            child: const Text("Update"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

        /// SOFT UPDATE BANNER
        if (showSoftUpdate)
          Container(
            width: double.infinity,
            color: Colors.amber.shade800,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [

                  const Icon(Icons.system_update, color: Colors.white),

                  const SizedBox(width: 10),

                  const Expanded(
                    child: Text(
                      "A new version of Theologia is available.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      // open store
                    },
                    child: const Text(
                      "UPDATE",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      setState(() {
                        showSoftUpdate = false;
                      });
                    },
                    icon: const Icon(Icons.close, color: Colors.white),
                  )
                ],
              ),
            ),
          ),

        Expanded(child: widget.child),
      ],
    );
  }
}