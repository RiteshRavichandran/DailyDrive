// reference our box
import 'package:daily_drive/datetime/date_time.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

// reference our box
final _myBox = Hive.box("Daily_Drive_Database");

class DriveDatabase {
  List todaysHabitList = [];
  Map<DateTime, int> heatMapDataSet = {};

  // create initial default data
  void createDefaultData() {
    todaysHabitList= [
      ["Run", false],
      ["Read", false],
    ];

    _myBox.put("START_DATE", todaysDateFormatted());
  }

  // load existing data
  void loadData() {
    final String currentDate = todaysDateFormatted();
    final String storedDate = _myBox.get("CURRENT_DATE") ?? "";

    if (currentDate != storedDate) {
      // It's a new day, reset habit completions to false
      todaysHabitList = List.generate(todaysHabitList.length, (index) => [todaysHabitList[index][1], false]);
      _myBox.put("CURRENT_DATE", currentDate);
    } else {
      // It's not a new day, load today's list
      todaysHabitList = _myBox.get(todaysDateFormatted()) ?? [];
    }
  }

  // update the database
  void updateDatabase() {
    // update today's entry
    _myBox.put(todaysDateFormatted(), todaysHabitList);

    //update universal habit list in case it changed (new habit, edit habit, delete habit)
    _myBox.put("CURRENT_HABIT_LIST", todaysHabitList);

    // Calculate habit complete percentage
    calculateHabitPercentages();


    // load heatmap
    loadHeatMap();
  }

  void calculateHabitPercentages() {
    int countCompleted = 0;
    for(int i=0; i<todaysHabitList.length; i++)
      {
        if( todaysHabitList[i][1] == true) {
          countCompleted++;
        }
      }
    String percent = todaysHabitList.isEmpty
        ? '0.0'
        : (countCompleted / todaysHabitList.length).toStringAsFixed(1);

    // key: "PERCENTAGE_SUMMARY_yyyymmdd"
    // value: string of 1dp number between 0.0-1.0 inclusive
    _myBox.put("PERCENTAGE_SUMMARY_${todaysDateFormatted()}", percent);
  }

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(_myBox.get("START_DATE"));

    // Count the number of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;
    // go from start date to today and add each percentage to the dataset
    // "PERCENTAGE_SUMMARY_yyyymmdd" will be the key in the database
    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );

      double strengthAsPercent = double.parse(
        _myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0",
      );

      // split the datetime up like below so it doesn't worry about hours/mins/secs etc.

      // year
      int year = startDate
          .add(Duration(days: i))
          .year;

      // month
      int month = startDate
          .add(Duration(days: i))
          .month;

      // day
      int day = startDate
          .add(Duration(days: i))
          .day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strengthAsPercent).toInt(),
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);
      if (kDebugMode) {
        print(heatMapDataSet);
      }
    }
  }
}