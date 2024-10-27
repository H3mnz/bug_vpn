import 'package:flutter/material.dart';

class ConnectionStatus extends StatelessWidget {
  final bool connected;
  const ConnectionStatus({
    super.key,
    required this.connected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Status',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.black54,
              ),
        ),
        Text(
          connected ? 'Connected' : 'Disconnected',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
