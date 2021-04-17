

import 'dart:async';

class TimerController {
  Timer timer;
  TimerController(int interval, Function() callback) {
    timer = Timer.periodic(Duration(seconds: interval), (Timer t) => callback());
  }
}