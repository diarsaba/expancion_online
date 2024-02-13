import 'package:flutter/material.dart';

class CardEventWidget extends StatelessWidget {
  final String image;
  final String field;
  final String command;
  final Function(String) onTap;

  const CardEventWidget({
    super.key,
    required this.image,
    required this.field,
    required this.onTap,
    required this.command,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap(command);
      },
      child: SizedBox(
        width: 100,
        height: 120,
        child: Card(
          color: Colors.black.withOpacity(0.2),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset("assets/images/$image"),
              ),
              Text(
                field,
                style: const TextStyle(
                    color: Colors.white70, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
