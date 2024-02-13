class Routermap {
  String mainroute;
  List<String> rutes = [];


  late String prevRoute;
  Routermap(this.mainroute) {
    rutes.add(mainroute);
  }

  nextRoute(String rute) {
    rutes.add(rute);
  }

  back() {
    if (!isOnMain()) {
      prevRoute = rutes.removeLast();
    }
  }

  toMain() {
    //rutes = [mainroute];
  }

  String current() {
    return rutes.last;
  }

  bool currentIsOf(String sub) {
    return rutes.last.contains(sub);
  }

  bool isOn(String route) {
    return rutes.last == route;
  }

  bool isOnMain() {
    // if (rutes.length > 10) {
    //   rutes.removeAt(0);
    // }
    return mainroute == current();
  }

  String command() {
    return rutes.last.replaceFirst("_info", "");
  }

  String prev() {
    return prevRoute;
  }
}
