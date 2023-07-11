import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../constants.dart';

final userProvider = StateProvider((ref) => auth.currentUser);
