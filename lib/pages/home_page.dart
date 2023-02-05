import 'package:flutter/material.dart';
import 'package:habit_tracker/Data/habit_database.dart';
import 'package:habit_tracker/components/monthly_summary.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../components/habit_tile.dart';
import '../components/my_fab.dart';
import '../components/new_alert_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HabitDatabase db = HabitDatabase();
  final _myBox = Hive.box("Habit_Database");
  @override
  void initState() {
    // if there is no current habit list,
    //then this is the first time of the app
    if (_myBox.get("current_habit_list") == null) {
      db.createDefaultData();
    }
    //not the first time of the app
    else {
      db.loadData();
    }
    //update the database
    db.updataData();
    super.initState();
  }

  //checkbox was tapped
  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todayHabitList[index][1] = value;
    });
    db.updataData();
  }

  final _newhabitcontroller = TextEditingController();
  //create a new habit
  void createNewhabit() {
    //show alert dialog box for user to enter new habit
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newhabitcontroller,
          hintText: "Enter Habit Name",
          Create: save,
          Cancel: cancel,
        );
      },
    );
  }

  //save new habit
  void save() {
    //add new habit to the list
    setState(() {
      db.todayHabitList.add([_newhabitcontroller.text, false]);
    });
    //clear text in text field
    _newhabitcontroller.clear();
    //exit the dialog box
    Navigator.of(context).pop();

    db.updataData();
  }

  //cancel new habit
  void cancel() {
    //clear text in text field
    _newhabitcontroller.clear();
    //exit the dialog box
    Navigator.of(context).pop();
  }

  //open habit settings
  void opensettings(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newhabitcontroller,
          hintText: db.todayHabitList[index][0],
          Create: () => savehabit(index),
          Cancel: cancel,
        );
      },
    );
  }

  //save existing habit
  void savehabit(int index) {
    setState(() {
      db.todayHabitList[index][0] = _newhabitcontroller.text;
    });
    _newhabitcontroller.clear();
    Navigator.pop(context);
    db.updataData();
  }

  //delete habit
  void deletehabit(int index) {
    setState(() {
      db.todayHabitList.removeAt(index);
    });
    db.updataData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      floatingActionButton: MyFloatingActionButton(
        onPressed: createNewhabit,
      ),
      body: ListView(
        children: [
          //monthly summary
          MonthlySummary(
              datasets: db.heatMapDataSet, startDate: _myBox.get("start_date")),

          //list of habits
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: db.todayHabitList.length,
            itemBuilder: (context, index) {
              return HabitTile(
                habitname: db.todayHabitList[index][0],
                habitCompleted: db.todayHabitList[index][1],
                onChanged: (value) => checkBoxTapped(value, index),
                settingTapped: (context) => opensettings(index),
                deleteTapped: (context) => deletehabit(index),
              );
            },
          )
        ],
      ),
    );
  }
}
