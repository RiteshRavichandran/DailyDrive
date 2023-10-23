import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:daily_drive/components/monthly_summary.dart';
import 'package:daily_drive/data/daily_Drive_Database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../components/habit_tile.dart';
import '../components/my_alert_box.dart';

class HomePage extends StatefulWidget {
      const HomePage({super.key});

      @override
      State<StatefulWidget> createState() => _HomePageState();

}

class _HomePageState  extends State<HomePage> {

  final _controller = ConfettiController();
  bool isPlaying = false;
  Timer? confettiTimer;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  DriveDatabase db = DriveDatabase();
  final _myBox = Hive.box("Daily_Drive_Database");

  @override
  void initState() {

    // if there is no current habit list, then it is the 1st time opening the app
    // the create default data
    if(_myBox.get("CURRENT_HABIT_LIST") == null) {
      db.createDefaultData();
    }
    //there already exits data, if this is not first time
    else {
      db.loadData();
    }

    // update the database
    db.updateDatabase();

    super.initState();
  }

  
  // checkbox was tapped
  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todaysHabitList[index][1] = value;
    });
    db.updateDatabase();
    bool allHabitsCompleted = db.todaysHabitList.every((habit) => habit[1] == true);
    if(allHabitsCompleted) {
      _controller.play();
      confettiTimer = Timer(Duration(seconds: 2), () {
        _controller.stop();
      });
    }
  }

  // create a new new habit
  final _newHabitNameController = TextEditingController();
  void createNewHabit() {
    // show alert dialog for the user to enter the new habit details
    showDialog(
        context: context,
        builder: (context) {
          return MyAlertBox(
            controller: _newHabitNameController,
            hintText: 'Enter New Habit...',
            onSave: saveNewHabit,
            onCancel: cancelDialogBox,
          );
        },
    );
  }

  // save new habit
  void saveNewHabit() {
    // add new habit to the list
    setState(() {
      db.todaysHabitList.add([_newHabitNameController.text, false]);
    });

    _newHabitNameController.clear();
    Navigator.of(context).pop();
    db.updateDatabase();
  }

  //cancel new habit
  void cancelDialogBox() {
    _newHabitNameController.clear();
    Navigator.of(context).pop();
  }

  openHabitEdit(int index) {
    showDialog(context: context, builder: (context){
      return MyAlertBox(
        controller: _newHabitNameController,
        hintText: db.todaysHabitList[index][0],
        onSave: () => saveExistingHabit(index),
        onCancel: cancelDialogBox,
      );
    });
  }

  // save existing habit with a new name
  void saveExistingHabit(int index) {
    setState(() {
      db.todaysHabitList[index][0] = _newHabitNameController.text;
    });
    _newHabitNameController.clear();
    Navigator.pop(context);
    db.updateDatabase();
  }

  // delete habit
  void deleteHabit(int index) {
    setState(() {
      db.todaysHabitList.removeAt(index);
    });
    db.updateDatabase();
  }


  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.grey[300],

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createNewHabit();
        },
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),

      body: ListView(
        children: [

          // monthly summary heat map
          MonthlySummary(datasets: db.heatMapDataSet, startDate: _myBox.get("START_DATE")),
          Container(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _controller,
              blastDirection: -pi/2,
            ),
          ),
          // list of habits
          ListView.builder(
            shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: db.todaysHabitList.length,
              itemBuilder: (context, index){
                return HabitTile(
                  habitName: db.todaysHabitList[index][0],
                  habitCompleted: db.todaysHabitList[index][1],
                  onChanged: (value) => checkBoxTapped(value, index),
                  editTapped: (context) => openHabitEdit(index),
                  deleteTapped: (context) => deleteHabit(index),
                );
              },
          ),
        ],
      ),
    );
  }
}