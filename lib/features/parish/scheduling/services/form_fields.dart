import 'package:flutter/material.dart';

InputDecoration inputDecoration(String labelText) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: const TextStyle(color: Colors.black54),
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: Colors.black54),
    ),
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: Colors.black54),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: Colors.black54),
    ),
  );
}

Widget buildDropdownField<T>(String labelText, T? value,
    List<DropdownMenuItem<T>> items, ValueChanged<T?> onChanged) {
  return DropdownButtonFormField<T>(
    value: value,
    items: items,
    onChanged: onChanged,
    decoration: inputDecoration(labelText),
  );
}

Widget buildTextField(TextEditingController controller, String labelText,
    {TextInputType keyboardType = TextInputType.text}) {
  return TextFormField(
    controller: controller,
    decoration: inputDecoration(labelText),
    keyboardType: keyboardType,
    validator: (value) =>
        value == null || value.isEmpty ? 'Please enter $labelText' : null,
  );
}
