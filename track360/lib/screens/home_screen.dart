import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:Track360/components/habit_tile.dart';
import 'package:Track360/components/monthly_summary.dart';
import 'package:Track360/components/my_fab.dart';
import 'package:Track360/components/new_habit_box.dart';
import 'package:Track360/data/habit_database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HabitDatabase db = HabitDatabase();
  final _myBox = Hive.box('Habit_Database');
  @override
  void initState() {

    if(_myBox.get("CURRENT_HABIT_LIST") == null){
      db.createDefaultData();
    }
    else{
      db.loadData();
    }

    db.updateDatabase();
    super.initState();

  }

 
  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todaysHabitList[index][1] = value;
    });
     db.updateDatabase(); 
  }

  final _newHabitNameController = TextEditingController();
  void createNewHabit() {
    showDialog(
        context: context,
        builder: (context) {
          return EnterNewHabitBox(
            controller: _newHabitNameController,
            onSave: saveNewHabit,
            onCancel: cancelNewHabit,
          );
        });
  }

  void saveNewHabit() {
    setState(() {
      db.todaysHabitList.add([_newHabitNameController.text, false]);
    });
    _newHabitNameController.clear();
    Navigator.of(context).pop();
     db.updateDatabase();
  }

  void cancelNewHabit() {
    _newHabitNameController.clear();
    Navigator.of(context).pop();
  }

  void openHabitSettings(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return EnterNewHabitBox(
            controller: _newHabitNameController,
            onSave: () => saveExistingHabit(index),
            onCancel: cancelNewHabit,
          );
        });
  }

  void saveExistingHabit(int index) {
    setState(() {
      db.todaysHabitList[index][0] = _newHabitNameController.text;
    });
    _newHabitNameController.clear();
    Navigator.of(context).pop();
     db.updateDatabase();
  }

  void deleteHabit(int index) {
    setState(() {
      db.todaysHabitList.removeAt(index);
    });
     db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: MyFloatingActionButton(onPressed: createNewHabit),
      body:ListView(
        children: [
          MonthlySummary(datasets: db.heatMapDataSet , startDate: _myBox.get("START_DATE")),
           ListView.builder(
          //habit tiles
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: db.todaysHabitList.length,
          itemBuilder: (context, index) {
            return HabitTile(
                habitName: db.todaysHabitList[index][0],
                habitCompleted: db.todaysHabitList[index][1],
                onChanged: (value) => checkBoxTapped(value, index),
                settingsTapped: (context) => openHabitSettings(index),
                deleteTapped: (context) => deleteHabit(index));
          }),
        ]
      )
    );
  }
}
