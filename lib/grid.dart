// ignore_for_file: avoid_print
//import 'dart:math';
import 'dart:convert';
import 'package:expancion_online/cell.dart';
import 'package:expancion_online/loader.dart';
import 'package:expancion_online/routermap.dart';
import 'package:expancion_online/town.dart';
import 'package:expancion_online/towns.dart';
import 'package:expancion_online/ui_controller.dart';
import 'package:flame/components.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Listgrid {
  final String name;
  final int rows;
  final int cols;
  final int width;
  final Towns towns;
  final AssetLoader assetloader;
  final SpriteComponent parent;
  final UIDataController uicontroller;
  final Routermap router;

  late int centerwidth;

  late Map<String, Cell> cells = {};

  late String currentAreaString = "";

  int bag = 100;
  int coins = 8;

  //int townindex = -1;

  Listgrid(
      {required this.name,
      required this.rows,
      required this.cols,
      required this.width,
      required this.towns,
      required this.assetloader,
      required this.parent,
      required this.uicontroller,
      required this.router}) {
    centerwidth = width ~/ 2;
    _read();
  }
  _read() async {
    late String text = "[]";
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/$name.grid');
      text = await file.readAsString();
      // ignore: empty_catches
    } catch (e) {}

    List<int> temp = List<int>.from(json.decode(text));

    if (temp.isEmpty) {
      late int i = 0;
      for (var identifier in List.generate(rows * cols, (index) => 0)) {
        final coord = coordByIndex(i);
        final cell = Cell(
            index: i,
            row: coord["row"]!,
            col: coord["cool"]!,
            offset: vector2offset(coord["row"]!, coord["cool"]!),
            grid: this);
        cell.whatincell = identifier;
        cells['$i'] = cell;
        i++;
        cells['$i'] = cell;
        i++;
      }
      //save();
    } else {
      late int i = 0;

      for (var identifier in temp) {
        final coord = coordByIndex(i);
        //print("$i ${coord}");
        // if (identifier == 1) {
        //   final cell = Cell(
        //       index: i,
        //       row: coord["row"]!,
        //       col: coord["col"]!,
        //       offset: vector2offset(coord["row"]!, coord["col"]!),
        //       grid: this);
        //   cell.whatincell = identifier;
        //   cells['$i'] = cell;
        //   cell.onCreate();
        // }

        final cell = Cell(
            index: i,
            row: coord["row"]!,
            col: coord["col"]!,
            offset: vector2offset(coord["row"]!, coord["col"]!),
            grid: this);
        cell.whatincell = identifier;
        cells['$i'] = cell;
        cell.onCreate();
        i++;
      }
    }
  }

  //TODO: hacer que se vean las cosas como van
  // save() async {
  //   final Directory directory = await getApplicationDocumentsDirectory();
  //   final File file = File('${directory.path}/$name.grid');
  //   await file.writeAsString(whatincell.toString());
  // }

  showArea(String name) {
    if (name == "Town") {
      showTownArea();
    } else {
      showCharacterArea(name);
    }
  }

  hideArea() async {
    if (isAreaActive()) {
      await hideTownArea();
    } else {
      towns.current().hideArea();
    }
  }

  showTownArea() async {
    final price = int.parse(assetloader.mapstack["Town"]![0]["price"]!);
    late int onprice = 0;
    if (towns.isEmpty()) {
      onprice = bag;
    } else {
      onprice = towns.current().bag;
    }
    if (onprice >= price) {
      setArea("Town");
      //this is the area avalible only for the town item
      //so you go for each cell enable, and see if is valid for town area
      for (var cell in cells.values) {
        cell.showTownArea();
      }
    }
  }

  hideTownArea() async {
    //
    for (var cell in cells.values) {
      cell.hideTownArea();
    }
  }

  bool isArea(String area) {
    return currentAreaString == area;
  }

  setArea(String area) {
    currentAreaString = area;
  }

  bool isAreaActive() {
    return currentAreaString.isNotEmpty;
  }

  showCharacterArea(String name) {
    //     final price = int.parse(assetloader.mapstack["Farmer"]![0]["price"]!);
    //     if (towns.isEmpty()) {
    //       print("No tower exist");
    //     } else {
    //       if (towns.current().bag >= price) {
    //         towns.current().showArea(background, "Farmer");
    //         grid.setArea("Farmer");
    //       }
    //     }
  }

  Cell cellOnCoor(int row, int col) {
    final index = '${row * cols + col}';
    if (cells.containsKey(index)) {
      return cells[index]!;
    } else {
      return Cell(index: -1, row: 0, col: 0, offset: Vector2(0, 0), grid: this);
    }
  }

  Vector2 vector2offset(int row, int col) {
    return Vector2((row * width + centerwidth).toDouble(),
        (col * width + centerwidth).toDouble());
  }

  Map<String, int> coordByIndex(int index) {
    return {"row": (index / cols).floor(), "col": (index % cols)};
  }

  handleTap(Vector2 tap) async {
    final row = (tap.x / 40).floor();
    final col = (tap.y / 40).floor();

    final cell = cellOnCoor(row, col);
    //print("r:$row, c:$col ${cell.whatincell} r:${cell.row}, c:${cell.col}");
    print("${cell.whatincell}");
    if (cell.index > 0) {
      if (router.currentIsOf("_info")) {
        switch (currentAreaString) {
          case "Town":
            print(cell.whatincell);

            // final price = int.parse(assetloader.mapstack["Town"]![0]["price"]!);
            // if (towns.current().bag >= price && cell.whatincell == 101) {
            //   if (towns.isEmpty()) {
            //     towns.add(Town(bag, coins, this));
            //   } else {
            //     towns.add(Town(20, 0, this));
            //     towns.current().hideMyInfluence();
            //   }

            //   towns.current().bag -= price;

            //   cell.setCharacter();

            //   //TODO: create the arrown area
            //   // late Cell cellin;
            //   // cellin = cellOnCoor(row - 1, col - 1);
            //   // cellin.whatincell == 11;
            //   // towns.current().myinfluence.add(cellin.index);
            //   // cellin.whoinfluence = towns.selected();
            // }

            // await hideArea();

            // if (towns.current().bag >= price) {
            //   await showArea("Town");
            // } else {
            //   uicontroller.goback();
            // }
            break;
          case "Farmer":
            if (towns.selectedTown == cell.whoinfluence) {
              if (cell.whatincell == 11) {
                //grid.influence[index] = 13;
                towns.current().setItem(
                    cell.index, 13, parent, assetloader.getImageSrc("Farmer"));
              }
            } else {
              if (cell.whatincell == 11 || cell.whatincell == 10) {
                towns.current().hideArea();
                uicontroller.goback();
              }
            }
            break;
          case "Knight":
            if (towns.selectedTown == cell.whoinfluence) {
              if (cell.whatincell == 11) {
                //grid.influence[index] = 13;
                towns.current().setItem(
                    cell.index, 14, parent, assetloader.getImageSrc("Knight"));
              }
            } else {
              if (cell.whatincell == 11 || cell.whatincell == 10) {
                towns.current().hideArea();
                uicontroller.goback();
              }
            }
            break;

          default:
            print("default");
        }
      }

      if (cell.influenced()) {
        towns.current().hideMyInfluence();
        towns.setIndexSelected(cell.whoinfluence);
        towns.current().showMyInfluence(parent);
        money();
      }
    }
  }

  current() {}

  money() {
    towns.isEmpty()
        ? uicontroller.updateMoney(bag, coins)
        : uicontroller.updateMoney(towns.current().bag, towns.current().coins);
  }

  userBack() {
    if (router.prev().contains("_info")) {
      if (isArea("Town")) {
        hideArea();
      } else {
        towns.current().hideArea();
      }
    }
  }
}
