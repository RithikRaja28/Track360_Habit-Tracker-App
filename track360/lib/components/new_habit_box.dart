import 'package:flutter/material.dart';

class EnterNewHabitBox extends StatelessWidget {
  final controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const EnterNewHabitBox({super.key,required this.controller, required this.onSave, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content:  TextField(
        controller: controller,
        decoration:const InputDecoration(
          hintText: "Enter habit name",
          hintStyle: TextStyle(color: Color.fromARGB(255, 119, 118, 118)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 79, 78, 78))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 79, 78, 78))),
        ),
      ),
      actions: [
        MaterialButton(
          onPressed: onSave,
          color: Colors.purpleAccent,
          child:  const Text(
            "Add",
            style: TextStyle(color: Colors.white),
          ),
        ),
        MaterialButton(
          onPressed: onCancel,
          color: Colors.purpleAccent,
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}
