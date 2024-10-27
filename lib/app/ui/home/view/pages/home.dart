import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uicons/uicons.dart';

import '../../../configs/view/pages/configs.dart';
import '../../../vpn/view/pages/vpn.dart';
import '../providers/bottom_nav_index_provider.dart';
import '../widgets/lazy_indexed_stack.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    return Scaffold(
      body: LazyIndexedStack(
        index: currentIndex,
        children: const [VpnPage(), ConfigsPage()],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        padding: const EdgeInsets.all(0),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(UIcons.regularRounded.home),
              activeIcon: Icon(UIcons.solidRounded.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(UIcons.regularRounded.world),
              activeIcon: Icon(UIcons.solidRounded.world),
              label: 'All Configs',
            ),
          ],
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: currentIndex,
          onTap: (index) => ref.read(bottomNavIndexProvider.notifier).update(
                (state) => index,
              ),
        ),
      ),
    );
  }
}
