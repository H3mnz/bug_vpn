import 'package:flutter/material.dart';
import 'package:uicons/uicons.dart';

class ConfigErrorWidget extends StatelessWidget {
  final VoidCallback onError;
  const ConfigErrorWidget({
    super.key,
    required this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            UIcons.regularRounded.exclamation,
            size: 56,
            color: Colors.black54,
          ),
          const SizedBox(height: 16),
          Text(
            "You're offline",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            "Check your connection",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: onError,
            child: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}
