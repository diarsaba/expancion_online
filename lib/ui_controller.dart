// ignore_for_file: avoid_print

import 'dart:ui';

import 'package:expancion_online/card_event_widget.dart';
import 'package:expancion_online/card_info_widget.dart';
import 'package:expancion_online/loader.dart';
import 'package:expancion_online/main.dart';
import 'package:expancion_online/routermap.dart';
//import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

class UIDataController {
  late void Function() enableUndo;
  late void Function() disableUndo;
  late void Function(int, int) updateMoney;
  late void Function() goback;
}

class UIController extends StatefulWidget {
  final UIDataController controller;
  final MyExpancionOnline game;
  final AssetLoader assetloader;
  final Routermap routermap;
  const UIController(
      {super.key,
      required this.game,
      required this.controller,
      required this.assetloader,
      required this.routermap});

  @override
  State<UIController> createState() => _UIControllerState(controller);
}

class _UIControllerState extends State<UIController> {
  _UIControllerState(UIDataController controller) {
    controller.disableUndo = disableUndo;
    controller.enableUndo = enableUndo;
    controller.updateMoney = updateMoney;
    controller.goback = goBack;
  }

  late int saco_ = 0;
  late int moneda_ = 0;
  late bool undoisenble = false;
  late bool playsound = true;
  late bool showgrid = false;

  @override
  void initState() {
    super.initState();
    widget.game.money();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     playsound == true
        //         ? IconButton(
        //             icon: const Icon(Icons.volume_off_rounded),
        //             onPressed: () {
        //               playsound = false;
        //               FlameAudio.bgm.stop();
        //               setState(() {});
        //             },
        //           )
        //         : IconButton(
        //             icon: const Icon(Icons.volume_up_rounded),
        //             onPressed: () {
        //               playsound = true;
        //               FlameAudio.bgm.play("Ambient3.mp3");
        //               setState(() {});
        //             },
        //           ),
        //     IconButton(
        //       icon: const Icon(Icons.save_outlined),
        //       onPressed: () {
        //         widget.game.saveStatus();
        //       },
        //     ),
        //     // showgrid == false
        //     //     ? IconButton(
        //     //         icon: const Icon(Icons.grid_off_rounded),
        //     //         onPressed: () {
        //     //           showgrid = true;
        //     //           setState(() {});
        //     //           widget.game.hidegrid();
        //     //         },
        //     //       )
        //     //     : IconButton(
        //     //         icon: const Icon(Icons.grid_3x3),
        //     //         onPressed: () {
        //     //           showgrid = false;
        //     //           setState(() {});
        //     //           widget.game.showgrid();
        //     //         },
        //     //       )
        //   ],
        // ),
        SizedBox(
          height: 200,
          child: Container(
            color: Colors.black.withOpacity(0.5),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Image.asset(
                                  "assets/images/saco.png",
                                  width: 40,
                                ),
                              ),
                              Text(
                                saco_.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Image.asset(
                                  "assets/images/monedas.png",
                                  width: 40,
                                ),
                              ),
                              Text(
                                moneda_.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        widget.routermap.isOnMain()
                            ? Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.arrow_right_alt_rounded,
                                        size: 55,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        widget.game.nextDay();
                                      },
                                    ),
                                  ),
                                  if (undoisenble)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.undo_rounded,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          widget.game.undo();
                                        },
                                      ),
                                    )
                                ],
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back_rounded,
                                    size: 55,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    widget.routermap.back();
                                    widget.game.userback();
                                    setState(() {});
                                  },
                                ),
                              ),
                      ],
                    )
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.assetloader
                          .getlenght(widget.routermap.command()),
                      itemBuilder: (_, int index) => selected(index)),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget selected(int index) {
    if (widget.routermap.currentIsOf("info")) {
      final stack_ = widget.assetloader.onRute(widget.routermap.command(), 0);

      return CardInfoWidget(
        image: widget.assetloader.getImageSrc(stack_["name"] ?? "test"),
        field: stack_["field"] ?? "field",
        command: stack_["command"] ?? "dd",
        expense: stack_["price"] ?? "dd",
        spending: stack_["charge"] ?? "dd",
        damage: stack_["damage"] ?? "dd",
      );
    } else {
      final stack_ =
          widget.assetloader.onRute(widget.routermap.current(), index);

      return CardEventWidget(
        image: widget.assetloader.getImageSrc(stack_["name"] ?? ""),
        field: stack_["field"] ?? "field",
        command: stack_["command"] ?? "dd",
        onTap: cardOnTap,
      );
    }
  }

  void cardOnTap(String command) {
    widget.routermap.nextRoute(command);
    if (widget.routermap.currentIsOf("_info")) {
      widget.game.showArea();
    }
    setState(() {});
  }

  void enableUndo() {
    undoisenble = true;
    setState(() {});
  }

  void disableUndo() {
    undoisenble = false;
    setState(() {});
  }

  void updateMoney(int ssaco, int smoneda) {
    saco_ = ssaco;
    moneda_ = smoneda;
    setState(() {});
  }

  void goBack() {
    widget.routermap.back();
    setState(() {});
  }
}
