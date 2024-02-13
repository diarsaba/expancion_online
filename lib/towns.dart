import 'package:expancion_online/town.dart';

class Towns {
  int selectedTown = 0;
  List<Town> towns = [];

  Towns();

  bool isEmpty() {
    return towns.isEmpty;
  }

  Town current() {
    return towns[selectedTown];
  }

  int currentByIndex(){
    return selectedTown;
  }

  add(Town town) {
    towns.add(town);
  }

  setIndexSelected(int index) {
    selectedTown = index;
  }

  //return the index of sected at last position
  int setSelected() {
    return selectedTown = towns.length - 1;
  }

  int selected() {
    return selectedTown;
  }
}
