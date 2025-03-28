import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget{
  @override
  State<HomePage> createState() => _HomePageState();
}

//Git test

class _HomePageState extends State<HomePage> {
  Map<String, List<Map<String, dynamic>>>? tasks;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var dates = [];

  Future<void> date_update() async{
    var now = DateTime.now();
    var week = {
      1 : "Mon", 2 : "Tue", 3 : "Wed",
      4 : "Thu", 5 : "Fri", 6 : "Sat",
      7 : "Sun"
    };
    for(int i=0; i<7; i++){
      var futureDate = now.add(Duration(days: i));
      dates.add({futureDate.day : week[futureDate.weekday]});
    }
  }

  var num = 0;
  String? setDay;

  void showTasks(){
    setDay = dates[num].values.toString();
    setDay = setDay?.replaceAll("(", "").replaceAll(")", "");
  }

  Future<void> loadTasks() async {
    tasks = {};

    try {
      QuerySnapshot snapshot = await _firestore.collection('tasks').get();

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String dayKey = data['dayKey'];

        if (tasks![dayKey] == null) tasks![dayKey] = [];

        tasks![dayKey]!.add({
          'id': doc.id,
          'text': data['text'],
          'completed': data['completed'],
        });
      }

      setState(() {});
    } catch (e) {
      print('Error loading tasks: $e');
    }
  }

  Future<void> addTask(String dayKey, String taskText) async {
    try {
      DocumentReference docRef = await _firestore.collection('tasks').add({
        'dayKey': dayKey,
        'text': taskText,
        'completed': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (tasks == null) tasks = {};
      if (tasks![dayKey] == null) tasks![dayKey] = [];

      tasks![dayKey]!.add({
        'id': docRef.id,
        'text': taskText,
        'completed': false,
      });

      setState(() {});
    } catch (e) {
      print('Error adding task: $e');
    }
  }

  Future<void> updateTask(String docId, String dayKey, int index, {String? text, bool? completed}) async {
    try {
      Map<String, dynamic> updates = {};

      if (text != null) {
        updates['text'] = text;
        tasks![dayKey]![index]['text'] = text;
      }

      if (completed != null) {
        updates['completed'] = completed;
        tasks![dayKey]![index]['completed'] = completed;
      }

      await _firestore.collection('tasks').doc(docId).update(updates);
      setState(() {});
    } catch (e) {
      print('Error updating task: $e');
    }
  }

  Future<void> deleteTask(String docId, String dayKey, int index) async {
    try {
      await _firestore.collection('tasks').doc(docId).delete();
      tasks![dayKey]!.removeAt(index);
      setState(() {});
    } catch (e) {
      print('Error deleting task: $e');
    }
  }

  @override
  void initState(){
    super.initState();
    date_update();
    showTasks();
    loadTasks();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        body: Center(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage("https://img.freepik.com/premium-vector/gradient-abstract-background_1139419-99.jpg?ga=GA1.1.497320573.1740595128"),
                    fit: BoxFit.cover
                )
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 205,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Hello!", style: FontStyle(a: Colors.white, c: 40),),
                              ClipRect(
                                child: SizedBox(
                                  width: 200,
                                  child: Text("Dev..",
                                      style: FontStyle(a: Colors.white, b: FontWeight.bold, c: 50)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(),
                          CircleAvatar(
                            child: Icon(Icons.person, size: 50,),
                            backgroundColor: Colors.white38,
                            radius: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Show dialog for adding a new task
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              String newTask = '';
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                title: Text(
                                  'Add Task',
                                  style: FontStyle(a: Colors.purple.shade900, b: FontWeight.bold, c: 24),
                                  textAlign: TextAlign.center,
                                ),
                                content: TextField(
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    hintText: 'Enter your task here',
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    newTask = value;
                                  },
                                ),
                                actions: [
                                  TextButton(
                                    child: Text(
                                      'Cancel',
                                      style: FontStyle(a: Colors.grey.shade700, c: 16),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Add task to Firestore
                                      if (newTask.isNotEmpty) {
                                        String dayKey = dates[num].keys.toString().replaceAll("(", "").replaceAll(")", "");
                                        addTask(dayKey, newTask);
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.pink.shade900,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    ),
                                    child: Text(
                                      'Add',
                                      style: FontStyle(a: Colors.white, b: FontWeight.bold, c: 16),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink.shade900,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 8,
                          shadowColor: Colors.pink.shade200,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add_circle_outline,
                              size: 28,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Add New Task',
                              style: FontStyle(a: Colors.white, b: FontWeight.bold, c: 22),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: 100,
                      width: double.infinity,
                      child: ListView.builder(
                        itemBuilder: (context, index){
                          return InkWell(
                            onTap: (){
                              setState(() {
                                num = index;
                              });
                              showTasks();
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(width: 2, color: Colors.grey),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      color: Colors.pink.shade900,
                                      child: Center(
                                        child: Text(
                                            dates[index].values.toString().replaceAll("(", "").replaceAll(")", ""),
                                            style: FontStyle(a: Colors.white,b: FontWeight.bold)
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        child: Center(
                                            child: Text(
                                                dates[index].keys.toString().replaceAll("(", "").replaceAll(")", ""),
                                                style: FontStyle(a: Colors.grey.shade600, b: FontWeight.bold, c: 25)
                                            )
                                        )
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: dates.length,
                        scrollDirection: Axis.horizontal,
                        itemExtent: 100,
                      )
                  ),
                  Container(
                      height: 450,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(60), bottom: Radius.circular(0))
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              '$setDay \'s  Tasks',
                              style: FontStyle(a: Colors.purple.shade900,b: FontWeight.bold, c: 40),

                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: tasks == null ||
                                  tasks![dates[num].keys.toString().replaceAll("(", "").replaceAll(")", "")] == null ||
                                  tasks![dates[num].keys.toString().replaceAll("(", "").replaceAll(")", "")]!.isEmpty
                                  ? Center(
                                child: Text(
                                  'No tasks for this day',
                                  style: FontStyle(a: Colors.grey, c: 18),
                                ),
                              )
                                  : ListView.builder(
                                itemCount: tasks![dates[num].keys.toString().replaceAll("(", "").replaceAll(")", "")]!.length,
                                itemBuilder: (context, index) {
                                  String dayKey = dates[num].keys.toString().replaceAll("(", "").replaceAll(")", "");
                                  bool isCompleted = tasks![dayKey]![index]['completed'];
                                  String docId = tasks![dayKey]![index]['id'];

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      children: [
                                        // Checkbox
                                        GestureDetector(
                                          onTap: () {
                                            updateTask(docId, dayKey, index, completed: !isCompleted);
                                          },
                                          child: Container(
                                            height: 24,
                                            width: 24,
                                            decoration: BoxDecoration(
                                              color: isCompleted ? Colors.pink.shade900 : Colors.white,
                                              border: Border.all(
                                                color: isCompleted ? Colors.pink.shade900 : Colors.grey,
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: isCompleted
                                                ? Icon(
                                              Icons.check,
                                              size: 16,
                                              color: Colors.white,
                                            )
                                                : null,
                                          ),
                                        ),
                                        SizedBox(width: 12),

                                        Expanded(
                                          child: TextField(
                                            controller: TextEditingController(text: tasks![dayKey]![index]['text']),
                                            style: FontStyle(
                                              a: isCompleted ? Colors.grey : Colors.black,
                                              b: isCompleted ? FontWeight.normal : FontWeight.w500,
                                              c: 18,
                                            ),
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              isDense: true,
                                            ),
                                            onChanged: (value) {
                                              updateTask(docId, dayKey, index, text: value);
                                            },
                                          ),
                                        ),

                                        // Delete icon
                                        GestureDetector(
                                          onTap: () {
                                            deleteTask(docId, dayKey, index);
                                          },
                                          child: Icon(
                                            Icons.close,
                                            color: isCompleted ? Colors.grey : Colors.grey.shade700,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}

TextStyle FontStyle({
  Color a = Colors.black,
  FontWeight b = FontWeight.normal,
  double c = 20
}) {
  return TextStyle(
      color: a,
      fontWeight: b,
      fontSize: c
  );
}