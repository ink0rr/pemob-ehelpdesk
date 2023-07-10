import 'dart:async';

Timer? _timer;
void debounce(void Function() action, int delay) {
  _timer?.cancel();
  _timer = Timer(Duration(milliseconds: delay), action);
}
