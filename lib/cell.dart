import 'package:expancion_online/grid.dart';
import 'package:flame/components.dart';

class Cell {
  //this could be final
  final int index;
  final int row;
  final int col;
  final Vector2 offset;
  final Listgrid grid;

  Cell(
      {required this.index,
      required this.row,
      required this.col,
      required this.offset,
      required this.grid});

  //Character
  late SpriteComponent character;
  //Area
  late SpriteComponent newArea;
  //
  late SpriteComponent moveArea;
  //Influence
  late SpriteComponent influence;
  // que hay en la celda
  late int whatincell = 0;
  // quien influye en esta celda
  late int whoinfluence = -1;
  // mi index en el padre

  Future<void> onCreate() async {
    newArea =
        await createSprite(Vector2(offset.x, offset.y), "violet_alpha.png");
    grid.parent.add(newArea);
    if (whatincell == 0){
      newArea.makeTransparent();
    }
    //newArea.makeTransparent();
  }

  bool influenced() {
    return whoinfluence >= 0;
  }

  showTownArea() async {
    //if cell is empty activate area;
    if (whatincell == 1) {
      
      newArea.makeOpaque();
      whatincell = 101;
      print("change $whatincell");
    }
  }

  hideTownArea() {
    newArea.makeTransparent();
    whatincell = 1;
  }

  setCharacter() {
    print("To create the spritre");
  }

  // updateCell(
  //   int index,
  //   Vector2 offset,
  // ) async {
  //   final t = await sprite(
  //       Vector2(offset.x, offset.y), assetloader.getImageSrc("Town"));
  //   principalCellSprite[index].removeFromParent();
  //   principalCellSprite[index] = t;
  //   parent.add(t);

  //   whatincell[index] = 10;
  //   whoinfluence[index] = towns.setSelected();
  // }

  Future<SpriteComponent> createSprite(
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
