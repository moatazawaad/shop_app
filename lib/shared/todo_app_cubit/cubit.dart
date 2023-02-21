import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_udemy_shop_app/shared/todo_app_cubit/states.dart';
import 'package:sqflite/sqflite.dart';

import '../network/local/cache_helper.dart';

// import '../cubit/states.dart';

// import '../../modules/archive_task/archive_tasks_screen.dart';
// import '../../modules/done_task/done_taska_screen.dart';
// import '../../modules/new_task/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  // List<Widget> screens = [
  //   NewTasksScreen(),
  //   DoneTasksScreen(),
  //   ArchiveTasksScreen(),
  // ];

  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archive Tasks',
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppBotNavBarState());
  }

  Database? database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  void createDataBase() {
    openDatabase(
      'ToDoApp.db',
      version: 1,
      onCreate: (database, version) {
        //print('database created');
        database
            .execute(
                'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) => {
                  //print('table created'),
                })
            .catchError((error) {
          //print('error when creating database ${error.toString()}');
        });
      },
      onOpen: (database) {
        getFromDataBase(database);
        //print('database opened');
      },
    ).then((value) => {
          database = value,
          emit(AppCreateDatabaseState()),
        });
  }

  Future insertDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database?.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks (title, date, time, status) VALUES("$title", "$date", "$time", "New")')
          .then((value) => {
                //print('$value inserted successfully'),
                emit(AppInsertDatabaseState()),
                getFromDataBase(database),
              })
          .catchError((error) {});
    }).catchError((error) {
      //print('error when inserting new record ${error.toString()}');
    });
    // return null;
  }

  void getFromDataBase(database) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];

    emit(AppGetDatabaseLoadingState());
    database!.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'New') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archiveTasks.add(element);
        }
      });

      emit(AppGetDatabaseState());
    });
  }

  void updateData({
    required String status,
    required int id,
  }) async {
    database!.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?', [
      status,
      '$id'
    ]).then((value) => {
          getFromDataBase(database),
          emit(AppUpdateDatabaseState()),
        });
  }

  void deleteData({
    required int id,
  }) async {
    database!
        .rawDelete('DELETE FROM tasks WHERE id = ?', ['$id']).then((value) => {
              getFromDataBase(database),
              emit(AppDeleteDatabaseState()),
            });
  }

  bool isBottomSheet = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheet = isShow;
    fabIcon = icon;

    emit(AppChangeBottomSheetState());
  }

  bool isDark = false;
  // ThemeMode appMode = ThemeMode.dark;

  void changeAppMode({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(AppChangeModeState());
    } else {
      isDark = !isDark;
      CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value) {});
      emit(AppChangeModeState());
    }
  }
}
