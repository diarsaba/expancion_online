//import 'dart:math';
// ignore_for_file: avoid_print
import 'dart:ui';

//import 'package:expancion_online/cell.dart';
import 'package:expancion_online/grid.dart';
//import 'package:expancion_online/town.dart';
import 'package:expancion_online/loader.dart';
import 'package:expancion_online/routermap.dart';
import 'package:expancion_online/towns.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
//import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
//import 'package:flame/palette.dart';
//import 'package:flame/sprite.dart';
//import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'ui_controller.dart';

final UIDataController uidatacontroller = UIDataController();
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();

  final routermap = Routermap("Entry");
  final assetloader = AssetLoader();

  runApp(
    MaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch}),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GameWidget(
          game: MyExpancionOnline(routermap, assetloader),
          overlayBuilderMap: {
            'UIController': (BuildContext context, MyExpancionOnline game) {
              return UIController(
                game: game,
                controller: uidatacontroller,
                routermap: routermap,
                assetloader: assetloader,
              );
            }
          },
        ),
      ),
    ),
  );
}

class MyExpancionOnline extends FlameGame
    with ScaleDetector, TapDetector, ScrollDetector {
  MyExpancionOnline(this.router, this.assetloader);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.viewfinder
      ..zoom = scale
      ..anchor = Anchor.topLeft;

    background = SpriteComponent()..sprite = await loadSprite("map.jpg");

    world.add(background);
    overlays.add('UIController');

    // final currentPosition = camera.viewfinder.position;
    // camera.viewfinder.position = currentPosition.translated(
    //   originx,
    //   originy,
    // );

    grid = Listgrid(
        name: "cero_one",
        rows: 70,
        cols: 44,
        width: 40,
        towns: towns,
        assetloader: assetloader,
        parent: background,
        uicontroller: uidatacontroller,
        router: router);
  }

  final Routermap router;
  final AssetLoader assetloader;
  late SpriteComponent background;
  final towns = Towns();
  late Listgrid grid;

  //game statements

  Future<void> showArea() async {
    grid.showArea(router.command());
  }

  @override
  Future<void> onTapUp(TapUpInfo info) async {
    grid.handleTap(camera.globalToLocal(info.eventPosition.global));
  }

  void undo() {
    //Deshacer movimiento
    print("UNDO");
  }

  void nextDay() {
    //Pasar turno
    print("NEXT DAY");
  }

  money() {
    grid.money();
  }

  void userback() {
    grid.userBack();
  }
  
  //------------------------------------------------

  void saveStatus() {
    //Guardar en modo developer
    //grid.save();
    print("save status");
  }

  final double _maxZoom = 2;
  final double _minZoom = 0.3;
  double scale = .5;
  double originx = 500;
  double originy = 100;
  double oldscale = 1;
  @override
  void onScroll(PointerScrollInfo info) {
    final currentPosition = camera.viewfinder.position;

    var mousex = info.eventPosition.global.x;
    var mousey = info.eventPosition.global.y;

    //final mapSize = Offset(background.width, background.height);
    final worldRect = camera.visibleWorldRect;

    var deltaZoom = info.scrollDelta.global.y > 0 ? 0.01 : -0.01;

    final newZoom = camera.viewfinder.zoom + deltaZoom;
    var clampedZoom = newZoom.clamp(_minZoom, _maxZoom);
    final oldscale = camera.viewfinder.zoom;

    originx = (mousex / oldscale) - (mousex / clampedZoom);
    originy = (mousey / oldscale) - (mousey / clampedZoom);

    if (worldRect.topLeft.dx + originx < 0) {
      originx = 0;
    }
    if (worldRect.topLeft.dy + originy < 0) {
      originy = 0;
    }

    camera.viewfinder.zoom = clampedZoom;

    camera.viewfinder.position = currentPosition.translated(
      originx,
      originy,
    );
  }
}
