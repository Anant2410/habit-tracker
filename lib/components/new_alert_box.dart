import 'package:flutter/material.dart';

class MyAlertBox extends StatelessWidget {
  final controller;
  final String hintText;
  final VoidCallback Create;
  final VoidCallback Cancel;
  const MyAlertBox(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.Create,
      required this.Cancel,
      });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey.shade800,
      content: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration:  InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade700),
            enabledBorder:
              const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            focusedBorder:
              const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white))),
      ),
      actions: [
        MaterialButton(
          onPressed: Create,
          child: Text(
            "Create",
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.green,
        ),
        MaterialButton(
          onPressed: Cancel,
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.green,
        ),
      ],
    );
  }
}
