import 'package:flutter/material.dart';

class NoDoItem extends StatelessWidget {
  String _itemName;
  String _dateCreated;
  int id;

NoDoItem(this._itemName, this._dateCreated);

NoDoItem.map(dynamic obj){
  this._itemName = obj["itemName"];
  this._dateCreated = obj["dateCreated"];
  this.id = obj["id"];
}

String get itemName => _itemName;
String get dateCreated => _dateCreated;

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}