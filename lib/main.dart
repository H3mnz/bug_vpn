import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:toastification/toastification.dart';

import 'app/shared/preferences/preferences.dart';
import 'app/shared/routes/routes.dart';
import 'app/shared/theme/colors.dart';
import 'app/shared/theme/theme.dart';
import 'app/shared/utils/utils.dart';
import 'app/ui/configs/view/providers/configs_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  await Preferences.instance.init();
  runApp(
    ProviderScope(
      overrides: [
        selectedConfigProvider.overrideWith(
          (ref) => Preferences.instance.getConfig(),
        ),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      config: ToastificationConfig(
        alignment: Alignment.center,
        animationDuration: const Duration(milliseconds: 200),
        animationBuilder: (context, animation, alignment, child) {
          return ScaleTransition(
            scale: Tween<double>(begin: 0.5, end: 1).animate(animation),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
      ),
      child: GlobalLoaderOverlay(
        overlayColor: Colors.black54,
        overlayWidgetBuilder: (_) {
          return const Center(
            child: Card(
              color: Colors.white,
              elevation: 0,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  backgroundColor: Colors.black12,
                  strokeAlign: BorderSide.strokeAlignOutside,
                  strokeCap: StrokeCap.round,
                  color: AppColors.green,
                ),
              ),
            ),
          );
        },
        child: MaterialApp(
          title: AppUtils.appLabel,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme,
          initialRoute: AppRoutes.splashRoute,
          routes: AppRoutes.routes,
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            overscroll: false,
          ),
        ),
      ),
    );
  }
}
