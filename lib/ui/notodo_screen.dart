import 'package:flutter/material.dart';

class NoToDoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NoToDo"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFormDialog,
                ),
            );
          }
        
         void _showFormDialog() {

         }
}