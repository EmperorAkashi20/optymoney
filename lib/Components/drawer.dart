import 'package:flutter/material.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  List<String> texts = ['first', 'second', 'third'];

  List<bool> isHighlighted = [
    true,
    false,
    false
  ]; //here the list where you can change the highlighted item

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Center(
          child: Column(children: <Widget>[
            Expanded(
              child: ListView.builder(
                  itemCount: texts.length,
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () {
                        for (int i = 0; i < isHighlighted.length; i++) {
                          setState(() {
                            if (index == i) {
                              isHighlighted[index] = true;
                            } else { //the condition to change the highlighted item
                              isHighlighted[i] = false;
                            }
                          });
                        }
                      },
                      child: Container(
                        color: isHighlighted[index] ? Colors.red : Colors.white,
                        child: ListTile( //the item
                          title: Text(texts[index]),
                        ),
                      ),
                    );
                  }),
            ),
          ]),
        ),
      ),
    );
  }
}