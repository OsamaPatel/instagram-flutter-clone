import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final TextInputType textInputType;
  final bool isPass;
  const TextInputField(
      {Key? key,
      required this.textEditingController,
      required this.hintText,
      required this.textInputType,
      this.isPass = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
          hintText: hintText,
          border: inputBorder,
          enabledBorder: inputBorder,
          filled: true),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
