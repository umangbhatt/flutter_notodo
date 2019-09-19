import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:todo_app/ui/nodo_item.dart';
import 'package:todo_app/util/database_client.dart';

class NoToDoScreen extends StatefulWidget {
  @override
  _NoToDoScreenState createState() => _NoToDoScreenState();
}

class _NoToDoScreenState extends State<NoToDoScreen> {
  final TextEditingController _textEditingController =
      new TextEditingController();

  final List<NoDoItem> _itemsList = <NoDoItem>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _readNoDoList();
  }

  var db = new DatabaseHelper();

  void _handleSubmitted(String text) async {
    _textEditingController.clear();

    NoDoItem noDoItem =
        new NoDoItem(text, new DateTime.now().toIso8601String());
    int savedItemId = await db.saveItem(noDoItem);

    NoDoItem addedItem = await db.getItem(savedItemId);
    setState(() {
      _itemsList.insert(0, addedItem);
    });

    print("item Saved id: $savedItemId");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NoToDo"),
      ),
      body: new Column(
        children: <Widget>[
          Flexible(child: ListView.builder(
            padding: EdgeInsets.all(8.0),
            reverse: false,
            itemCount: _itemsList.length,
            itemBuilder: (_,int index){
            return Card(
              color: Colors.white10,
              child: new ListTile(
                title: Text(_itemsList[index].itemName),
                subtitle: Text(_itemsList[index].dateCreated),
                onLongPress: ()=>debugPrint(""),
                trailing: new Listener(
                  key: new Key(_itemsList[index].itemName),
                  child: Icon(Icons.remove_circle,color: Colors.redAccent,),
                  onPointerDown: (PointerEvent)=>debugPrint(""),
                ),
              ),
            );
            },
          ),)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        tooltip: "Add",
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: _showFormDialog,
      ),
    );
  }

  void _showFormDialog() {
    var alert = AlertDialog(
      content: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textEditingController,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: "Item",
                  hintText: "eg. Don't spend unnecessarily",
                  icon: Icon(Icons.note_add)),
            ),
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            _handleSubmitted(_textEditingController.text);
            _textEditingController.clear();
          },
          child: Text("Save"),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  _readNoDoList() async {
    List items = await db.getItems();
    items.forEach((item) {
      NoDoItem noDoItem = NoDoItem.map(item);
      setState(() {
       _itemsList.add(noDoItem); 
      });
      print("Db items :${noDoItem.itemName}");
    });
  }
}
