import 'package:flutter/material.dart';
import 'package:habit_tracker/components/habit_tile.dart';
import 'package:habit_tracker/components/my_fab.dart';
import 'package:habit_tracker/data/habit_database.dart';
import 'package:hive_flutter/adapters.dart';

import '../components/my_alert_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box("Habit_Database");
  // data structure for todays list
  HabitDataBase db = HabitDataBase();

  @override
  void initState() {
// if there is no current habit list , then it is the 1st time ever opening the app
// there already exists data, then create a default data
    if (_myBox.get("CURRENT_HABIT_LIST") == null) {
      db.createDefaultData();
    }

// this is not the first time
    else {
      db.loadData();
    }

    // update the database
    db.updateDataBase();

    super.initState();
  }

  // checkbox was tapped
  void checkboxTapped(bool? value, int index) {
    setState(() {
      db.todaysHabitList[index][1] = value!;
    });
  }

// create a new habit
  final _newHabitNameController = TextEditingController();
  void createNewHabit() {
    // show alert dialog for user to enter new habit details
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          onSave: saveNewHabit,
          onCancel: cancelDialogBox,
          hintText: 'Enter habit name...',
        );
      },
    );
  }

  // save new habit
  void saveNewHabit() {
    // add new habit to todays list
    db.todaysHabitList.add(
      [_newHabitNameController.text, false],
    );

    // clear textfield
    _newHabitNameController.clear();
    // pop dialog box
    Navigator.of(context).pop();
    setState(() {});
  }

  // cancel new habit
  void cancelDialogBox() {
    // clear textfield
    _newHabitNameController.clear();
    // pop dialog box
    Navigator.of(context).pop();
  }

  // open habit settings to edit
  void openHabitSetting(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          onSave: () => saveExistingHabit(index),
          onCancel: cancelDialogBox,
          hintText: db.todaysHabitList[index][0],
        );
      },
    );
  }

  // save existing habit whith a new name
  void saveExistingHabit(int index) {
    setState(() {
      db.todaysHabitList[index][0] = _newHabitNameController.text;
    });
    _newHabitNameController.clear();
    Navigator.pop(context);
  }

  // delete habit
  void deleteHabit(int index) {
    setState(() {
      db.todaysHabitList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: MyFloatingActionButton(
        onPressed: createNewHabit,
      ),
      backgroundColor: Colors.grey[300],
      body: ListView.builder(
        itemCount: db.todaysHabitList.length,
        itemBuilder: (context, index) {
          return HabitTile(
            habitCompleted: db.todaysHabitList[index][1],
            habitName: db.todaysHabitList[index][0],
            onChanged: (value) => checkboxTapped(value, index),
            settingTapped: (context) => openHabitSetting(index),
            deleteTapped: (context) => deleteHabit(index),
          );
        },
      ),
    );
  }
}
