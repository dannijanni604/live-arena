import 'package:flutter/material.dart';
import 'package:live_arena/components/text_styles.dart';

class SwipeAbleContainaer extends StatefulWidget {
  const SwipeAbleContainaer({Key? key}) : super(key: key);

  @override
  _SwipeAbleContainaerState createState() => _SwipeAbleContainaerState();
}

class _SwipeAbleContainaerState extends State<SwipeAbleContainaer> {
  var _tasks;
  @override
  void initState() {
    super.initState();
    setState(() {
      _tasks = TaskModel.getTask();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListView.builder(
            itemCount: _tasks.length,
            itemBuilder: (context, index) {
              return Dismissible(
                onDismissed: (DismissDirection direction) {
                  print(direction);
                },
                secondaryBackground: Container(
                  alignment: Alignment.centerRight,
                  color: Colors.red,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text("Delete", style: txt16w),
                  ),
                ),
                background: Container(
                  alignment: Alignment.centerLeft,
                  color: Colors.purple,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text("Remove", style: txt16w),
                  ),
                ),
                key: UniqueKey(),
                child: ExpansionTile(
                  childrenPadding: const EdgeInsets.symmetric(vertical: 10),
                  title: Text(_tasks[index]["name"]),
                  children: [
                    Text(
                      _tasks[index]["email"],
                    ),
                    Text(_tasks[index]["game"]),
                  ],
                ),
              );
            }),
      ),
    );
  }
}

class TaskModel {
  static List<Map<String, dynamic>> getTask() {
    return [
      {
        "name": "wakeel",
        "email": "wakeelamham786@gmail.com",
        "game": "Rowing",
      },
      {
        "name": "shakeel",
        "email": "wakeelamham786@gmail.com",
        "game": "foot ball",
      },
      {
        "name": "jameel",
        "email": "wakeelamham786@gmail.com",
        "game": "cricket",
      }
    ];
  }
}
