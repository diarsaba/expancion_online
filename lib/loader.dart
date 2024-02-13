// ignore_for_file: avoid_print

import 'dart:convert';
//import 'package:flame/components.dart';
import 'package:flutter/services.dart' show rootBundle;

class AssetLoader {
  Map<String, Map<String, String>> sourcemap = {};
  Map<String, List<Map<String, String>>> mapstack = {};

  AssetLoader() {
    _read();
  }

  _read() async {
    //Loading for sources
    late String text = "{}";
    try {
      text = await loadAsset("source.json");
      // ignore: empty_catches
    } catch (e) {}

    final temp = Map<String, dynamic>.from(json.decode(text));
    temp.forEach((k, v) {
      final va = Map<String, String>.from(v);
      sourcemap.addAll({k: va});
    });
    //Loading for sources

    //Loading for stacks
    late String stacks = "{}";
    try {
      stacks = await loadAsset("stacks.json");
      // ignore: empty_catches
    } catch (e) {}

    final tempstacks = Map<String, dynamic>.from(json.decode(stacks));
    tempstacks.forEach((k, v) {
      late List<Map<String, String>> list = [];
      final listtemp = List<dynamic>.from(v);
      for (var element in listtemp) {
        list.add(Map<String, String>.from(element));
      }
      mapstack.addAll({k: list});
    });
  }

  Future<String> loadAsset(String path) async {
    return await rootBundle.loadString('assets/json/$path');
  }

  String getImageSrc(String name) {
    return sourcemap[name]?["image"] ?? "";
  }

  Map<String, String> onRute(String rute, int index) {
    return mapstack[rute]?[index] ?? {"": ""};
  }

  int getlenght(String name) {
    return mapstack[name]?.length ?? 1;
  }
}
