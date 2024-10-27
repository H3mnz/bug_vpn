import 'package:flutter/material.dart';

class ConnectingTime extends StatelessWidget {
  final String value;
  const ConnectingTime({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Connecting Time',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.black54,
              ),
        ),
        Text(
          value,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
