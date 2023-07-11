import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/user.dart';
import '../../utils/debounce.dart';
import '../not_signed_in.dart';
import 'widgets/ask_question.dart';
import 'widgets/home.dart';
import 'widgets/notifications.dart';
import 'widgets/profile.dart';
import 'widgets/tickets.dart';

final pageProvider = StateProvider((ref) => 0);

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    if (user == null) {
      return const NotSignedInPage();
    }

    final controller = usePageController();
    final currentIndex = ref.watch(pageProvider);

    useValueChanged(currentIndex, (_, __) {
      return controller.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });

    return Scaffold(
      body: PageView(
        controller: controller,
        onPageChanged: (value) {
          debounce(() => ref.read(pageProvider.notifier).state = value, 250);
        },
        children: const [
          Home(),
          Tickets(),
          AskQuestion(),
          Notifications(),
          Profile(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        selectedFontSize: 12,
        onTap: (value) {
          ref.read(pageProvider.notifier).state = value;
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Tickets',
            icon: Icon(Icons.help_outline),
            activeIcon: Icon(Icons.help),
          ),
          BottomNavigationBarItem(
            label: 'Ask',
            icon: Icon(Icons.add_box_outlined),
            activeIcon: Icon(Icons.add_box),
          ),
          BottomNavigationBarItem(
            label: 'Notifications',
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
