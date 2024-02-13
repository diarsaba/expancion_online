import 'package:flutter/material.dart';

class CardInfoWidget extends StatelessWidget {
  final String image;
  final String field;
  final String command;
  final String expense;
  final String spending;
  final String damage;

  const CardInfoWidget({
    super.key,
    required this.image,
    required this.field,
    required this.command,
    required this.expense,
    required this.spending,
    required this.damage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 120,
      child: Card(
          color: Colors.black.withOpacity(0.2),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
          ),
          child: Row(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      "assets/images/$image",
                      width: 80,
                    ),
                  ),
                  Text(
                    field,
                    style: const TextStyle(
                        color: Colors.white70, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        child: Image.asset(
                          "assets/images/saco.png",
                          width: 30,
                        ),
                      ),
                      Text(
                        expense,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 15, top: 3, bottom: 3 ),
                        child: Image.asset(
                          "assets/images/moneda.png",
                          width: 20,
                        ),
                      ),
                      Text(
                        spending,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: Image.asset(
                          "assets/images/semiespada.png",
                          width: 30,
                        ),
                      ),
                      Text(
                        damage,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
