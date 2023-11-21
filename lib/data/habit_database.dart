// refrence our box
import 'package:habit_tracker/datetime/date_time.dart';
import 'package:hive/hive.dart';

final _myBox = Hive.box("Habit_Database");

class HabitDataBase {
  List todaysHabitList = [];

  // create initial default data
  void createDefaultData() {
    todaysHabitList = [
      ['Run', false],
      ['Read', false],
    ];

    _myBox.put("START_DATE", todaysDateFormatted());
  }

  // load the data if it already exists
  void loadData() {}

  // update database
  void updateDataBase() {}
}
