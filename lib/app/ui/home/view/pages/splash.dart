import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../shared/routes/routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    // Future.delayed(const Duration(seconds: 1)).then((value) {
    //   if (mounted) {

    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Animate(
          onComplete: (controller) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.homeRoute);
          },
          effects: const [
            FadeEffect(
              duration: Duration(milliseconds: 200),
            ),
            SlideEffect(
              duration: Duration(milliseconds: 350),
              begin: Offset(0, 1),
              end: Offset.zero,
            ),
            ThenEffect(),
            ShakeEffect(
              duration: Duration(milliseconds: 300),
            ),
            ThenEffect(),
            SlideEffect(
              duration: Duration(milliseconds: 350),
              begin: Offset.zero,
              end: Offset(0, -1),
            ),
            FadeEffect(
              begin: 1,
              end: 0,
              duration: Duration(milliseconds: 200),
            ),
          ],
          child: SizedBox.square(
            dimension: 128,
            child: Image.asset('images/logo.png'),
          ),
        ),
      ),
    );
  }
}
