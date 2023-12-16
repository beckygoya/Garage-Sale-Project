import 'package:flutter/material.dart';

class Item {
  String user = '';
  String title = '';
  String price = '';
  String description = '';
  String p0 = '';
  String p1 = '';
  String p2 = '';
  String p3 = '';

  List<String> pictures = [];
  List<String> urls = [];
}

class MyItem extends StatelessWidget {
  final String label;
  final bool price;
  final bool description;
  final TextEditingController controller;

  const MyItem(
      {Key? key,
        required this.label,
        required this.controller,
        this.price = false,
        this.description = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autofocus: label == 'title',
      showCursor: true,
      autocorrect: true,
      keyboardType: price
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      minLines: description ? 1 : 1,
      maxLines: description ? 5 : 1,
      decoration: InputDecoration(
        prefixIcon:
        price == true ? const Icon(Icons.attach_money, size: 17.0) : null,
        border: const UnderlineInputBorder(),
        labelText: label,
      ),
    );
  }
}
