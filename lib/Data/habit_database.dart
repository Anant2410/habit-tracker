import 'package:habit_tracker/datetime/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

//reference our box
final _myBox = Hive.box("Habit_Database");

class HabitDatabase {
  List todayHabitList = [];
  Map<DateTime, int> heatMapDataSet = {};

  //create initial derfault data
  void createDefaultData() {
    todayHabitList = [
      ["Run", false],
      ["Read", false],
    ];
    _myBox.put("start_date", todayDateFormatted());
  }

  //load data if exist
  void loadData() {
    //if new day get habit from database
    if (_myBox.get(todayDateFormatted()) == null) {
      todayHabitList = _myBox.get("current_habit_list");
      //set all the habit to false
      for (int i = 0; i < todayHabitList.length; i++) {
        todayHabitList[i][1] = false;
      }
    }
    //if not a new day,load today list
    else {
      todayHabitList = _myBox.get(todayDateFormatted());
    }
  }

  //update databse
  void updataData() {
    //update today entry
    _myBox.put(todayDateFormatted(), todayHabitList);

    //update universal habit list
    _myBox.put("current_habit_list", todayHabitList);

    //calculate habit complete percentage for each day
    calculateHabitPercentage();

    //load heat map
    loadHeatMap();
  }

  void calculateHabitPercentage() {
    int countCompleted = 0;
    for (int i = 0; i < todayHabitList.length; i++) {
      if (todayHabitList[i][1] == true) {
        countCompleted++;
      }
    }

    String percent = todayHabitList.isEmpty
        ? '0.0'
        : (countCompleted / todayHabitList.length).toStringAsFixed(1);
    //key: "percentage_summary_yyyymmdd"
    //value: string of 1 dp number between 0-1 inclusive
    _myBox.put("percentage_summary_${todayDateFormatted()}", percent);
  }

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(_myBox.get("start_date"));

    //count the nuber of days to load
    int daysInbetween = DateTime.now().difference(startDate).inDays;

    for (int i = 0; i < daysInbetween + 1; i++) {
      String yyyymmdd = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );

      double strength = double.parse(
        _myBox.get("percentage_summary_$yyyymmdd") ?? "0.0",
      );

      int year = startDate.add(Duration(days: i)).year;

      int month = startDate.add(Duration(days: i)).month;

      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strength).toInt(),
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);
      print(heatMapDataSet);
    }
  }
}
