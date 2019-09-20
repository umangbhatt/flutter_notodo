
import 'package:flutter/material.dart';
import 'package:todo_app/ui/nodo_item.dart';
import 'package:todo_app/util/database_client.dart';
import 'package:todo_app/util/date_formatter.dart';

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

    NoDoItem noDoItem = new NoDoItem(text, dateFormatted());
    int savedItemId = await db.saveItem(noDoItem);

    NoDoItem addedItem = await db.getItem(savedItemId);
    setState(() {
      _itemsList.insert(0, addedItem);
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NoToDo"),
      ),
      body: new Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: false,
              itemCount: _itemsList.length,
              itemBuilder: (_, int index) {
                return Card(
                  color: Colors.white10,
                  child: new ListTile(
                    title: Text(_itemsList[index].itemName),
                    subtitle: Text(_itemsList[index].dateCreated),
                    onLongPress: () => _updateItem(_itemsList[index], index),
                    trailing: new Listener(
                      key: new Key(_itemsList[index].itemName),
                      child: Icon(
                        Icons.remove_circle,
                        color: Colors.redAccent,
                      ),
                      onPointerDown: (PointerEvent) =>
                          _deleteNoDo(_itemsList[index].id, index),
                    ),
                  ),
                );
              },
            ),
          )
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
    });
  }

  _deleteNoDo(int id, int index) async {
    await db.deleteItem(id);

    setState(() {
      _itemsList.removeAt(index);
    });
  }

  _updateItem(NoDoItem item, int index) {
    var alert = new AlertDialog(
      title: Text("Update Item"),
      content: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textEditingController,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: "Item",
                  hintText: "eg.Don't buy stuff",
                  icon: new Icon(Icons.update)),
            ),
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () async {
            NoDoItem newItemUpdated = NoDoItem.fromMap({
              "itemName": _textEditingController.text,
              "dateCreated": dateFormatted(),
              "id": item.id
            });
            _handleSubmittedUpdate(index, item);
            await db.updateItem(newItemUpdated);
            _textEditingController.clear();
            setState(() {
             _readNoDoList(); 
            });
          },
          child: Text("Update"),
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

  void _handleSubmittedUpdate(int index, NoDoItem item) {
    setState(() {
     _itemsList.removeWhere((element){
      _itemsList[index].itemName == item.itemName;
     }); 
    });

    Navigator.pop(context);
  }
}
