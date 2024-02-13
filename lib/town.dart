import 'package:expancion_online/cell.dart';
import 'package:expancion_online/grid.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Town {
  int bag;
  int coins;

  bool onfit = true;
  bool selected = false;

  Listgrid grid;

  List<int> myinfluence = [];
  List<SpriteComponent> myInfluenceS = [];
  //List<int> area = [];
  List<SpriteComponent> area = [];

  List<SpriteComponent> myItems = [];

  late String currentarea = "";

  Town(this.bag, this.coins, this.grid);

  destroyed() {
    onfit = true;
  }

  select() {
    selected = true;
  }

  unselect() {
    selected = false;
  }

  setItem(int index, int item, SpriteComponent parent, String img) async {
    final coors = getCoordsByIndex(index);
    final row = coors["row"]!;
    final col = coors["col"]!;

    var offsetx = (row * 40 + 20).toDouble();
    var offsety = (col * 40 + 20).toDouble();

    final t = await sprite(Vector2(offsetx, offsety), img);
    parent.add(t);
    myItems.add(t);
  }

  addVioletCell(int row, int col, index) async {
    final offset =
        Vector2((row * 40 + 20).toDouble(), (col * 40 + 20).toDouble());

    final t = await sprite(Vector2(offset.x, offset.y), "violet_alpha.png");

    grid.parent.add(t);
    area.add(t);
    //grid.whatincell[index] = 11;
  }

  showArea(SpriteComponent parent, String areatype) async {
    switch (areatype) {
      case "Farmer":
        late Cell topcell;
        late Cell rightcell;
        late Cell bottomcell;
        late Cell leftcell;

        for (var index in myinfluence) {

          final cell = grid.cells['$index']!; 
              
          final t =
              await sprite(cell.offset, "violet_alpha.png");

          parent.add(t);
          area.add(t);

          if (cell.whatincell== 11) {
            // si esto soy el exterior

            // donde estoy

            topcell = grid.cellOnCoor(cell.row, cell.col - 1);
            rightcell = grid.cellOnCoor(cell.row + 1, cell.col);
            bottomcell = grid.cellOnCoor(cell.row, cell.col + 1);
            leftcell = grid.cellOnCoor(cell.row - 1, cell.col);

            if (topcell.whatincell == 11 && bottomcell.whatincell == 11) {
              //estoy en medio vertical
              if (leftcell.whatincell == 11 || leftcell.whatincell == 10) {
                //poner a la derecha
                addVioletCell(cell.row + 1, cell.col, rightcell.index);
              } else if (rightcell.whatincell == 11 || rightcell.whatincell == 10) {
                //poner a la izquierda
                addVioletCell(cell.row - 1, cell.col, leftcell.whatincell);
              }
            } else if (leftcell.whatincell == 11 && rightcell.whatincell == 11) {
              //estoy en medio horizontal
              if (topcell.whatincell == 11 || topcell.whatincell == 10) {
                //poner abajo
                addVioletCell(cell.row, cell.col + 1, bottomcell.whatincell);
              } else if (bottomcell.whatincell == 11 || bottomcell.whatincell == 10) {
                //poner arriba
                addVioletCell(cell.row, cell.col - 1, topcell.whatincell);
              }
            } else if (bottomcell.whatincell == 11 && rightcell.whatincell == 11) {
              // soy esquina 1 poner en izquierda y arriba
              addVioletCell(cell.row - 1, cell.col, leftcell.whatincell);
              addVioletCell(cell.row, cell.col - 1, rightcell.whatincell);
            } else if (leftcell.whatincell == 11 && bottomcell.whatincell == 11) {
              // soy esquina 2 poner en derecha y arriba
              addVioletCell(cell.row + 1, cell.col, rightcell.whatincell);
              addVioletCell(cell.row, cell.col - 1, topcell.whatincell);
            } else if (topcell.whatincell == 11 && leftcell.whatincell == 11) {
              //soy esquina 3 poner en derecha y abajo
              addVioletCell(cell.row + 1, cell.col, rightcell.whatincell);
              addVioletCell(cell.row, cell.col + 1, bottomcell.whatincell);
            } else if (rightcell.whatincell == 11 && topcell.whatincell == 11) {
              //soy esquina 4 poner en abajo e izquierda
              addVioletCell(cell.row - 1, cell.col, bottomcell.whatincell);
              addVioletCell(cell.row, cell.col + 1, leftcell.whatincell);
            }
          }
        }
        break;
      case "Knight":
        for (var index in myinfluence) {
          final coors = getCoordsByIndex(index);
          final row = coors["row"]!;
          final col = coors["col"]!;

          var offsetx = (row * 40 + 20).toDouble();
          var offsety = (col * 40 + 20).toDouble();

          final t = await sprite(Vector2(offsetx, offsety), "violet_alpha.png");

          parent.add(t);
          area.add(t);
        }
        break;
      default:
    }
  }

  hideArea() {
    for (var sc in area) {
      sc.removeFromParent();
    }
    area = [];
  }

  hideMyInfluence() {
    for (var sc in myInfluenceS) {
      sc.removeFromParent();
    }
    myInfluenceS = [];

    //print("hide my influece");
  }

  showMyInfluence(SpriteComponent parent) async {
    for (var index in myinfluence) {
      final mcoors = getCoordsByIndex(index);
      final row = mcoors["row"]!;
      final col = mcoors["col"]!;

      final offset =
          Vector2((row * 40 + 20).toDouble(), (col * 40 + 20).toDouble());
      final t = await sprite(offset, "black_alpha.png");
      parent.add(t);
      myInfluenceS.add(t);
    }
    //print("showing my influence $myinfluence");
  }

  Map<String, int> getCoordsByIndex(int index) {
    //TODO: use the grid cols value
    //WARNNING: 44 is cols
    return {"row": (index / 44).ceil() - 1, "col": index % 44};
  }

  Future<SpriteComponent> sprite(
    Vector2 position,
    String image,
  ) async {
    return SpriteComponent(
      sprite: await Sprite.load(image),
    )
      ..size = Vector2(39, 39)
      ..anchor = Anchor.center
      ..position = position
      ..priority = 1;
  }
}
