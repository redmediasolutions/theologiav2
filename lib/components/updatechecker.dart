import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
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

  /// 🔹 OPEN STORE FROM REMOTE CONFIG
  Future<void> _openStore() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    final androidUrl = remoteConfig.getString('android_store_url');
    final iosUrl = remoteConfig.getString('ios_store_url');

    final url = Platform.isIOS ? iosUrl : androidUrl;

    if (url.isEmpty) return;

    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// 🔹 FORCE UPDATE (NON-DISMISSABLE)
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
            onPressed: _openStore,
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
        /// 🔹 SOFT UPDATE BANNER
        if (showSoftUpdate)
          Container(
            width: double.infinity,
            color: Colors.amber.shade900,
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
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600
                        ),
                    ),
                  ),

                  TextButton(
                    onPressed: _openStore,
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
                  ),
                ],
              ),
            ),
          ),

        /// 🔹 MAIN APP CONTENT
        Expanded(child: widget.child),
      ],
    );
  }
}