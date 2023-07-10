import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/user.dart';
import '../not_signed_in.dart';
import 'widgets/ask_question.dart';
import 'widgets/home.dart';
import 'widgets/notifications.dart';
import 'widgets/profile.dart';
import 'widgets/search.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    if (user == null) {
      return const NotSignedInPage();
    }

    final currentIndex = useState(0);
    final pages = useMemoized(
      () => [
        Home(user: user),
        const Search(),
        const AskQuestion(),
        Notifications(user: user),
        Profile(user: user),
      ],
      [user],
    );
    return Scaffold(
      body: pages[currentIndex.value],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex.value,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        selectedFontSize: 12,
        onTap: (value) {
          currentIndex.value = value;
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Search',
            icon: Icon(Icons.search),
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
