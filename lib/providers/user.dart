import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../constants.dart';
import '../models/user_data.dart';

final userProvider = StateProvider((ref) => auth.currentUser);

final userDataProvider = FutureProvider((ref) async {
  final user = ref.read(userProvider);
  final userData = await db.collection('users').doc(user!.uid).get();
  return UserData.fromJson(userData.data()!);
});
