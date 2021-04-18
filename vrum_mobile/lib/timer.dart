import 'dart:async';

class Periodic {
  Timer timer;
  int numSeconds;
  Function callback;

  Periodic();

  startProcess(int numSeconds, Function callback) {
    this.numSeconds = numSeconds;
    this.callback = callback;
    timer = Timer.periodic(Duration(seconds: numSeconds), (Timer t) => callback());
  }

  bool restartProcess() {
    if (numSeconds != null && callback != null) {
      timer = Timer.periodic(Duration(seconds: numSeconds), (Timer t) => callback());
      return true;
    }
    else {
      return false;
    }
  }

  bool stopProcess() {
    if (timer != null) {
      timer.cancel();
      return true;
    }
    else {
      return false;
    }
  }
}