import 'package:fastapp/data/app_shared_pref.dart';
import 'package:fastapp/notifications.dart';
import 'package:fastapp/state/home_state.dart';
import 'package:fastapp/util/hard_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

enum Program { sixteen, eighteen, twenty }

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeLoading());

  Program currentProgram;

  void setFastProgram(String value) {
    var index = programs.indexOf(value);
    currentProgram = Program.values[index];
    AppSharedPreferences.saveData(AppSharedPreferences.SELECTED_PROGRAM, value);
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    switch (event) {
      case HomeEvent.fasting:
        yield* fasting();
        break;
      case HomeEvent.notFasting:
        yield* dontFast();
        break;
      case HomeEvent.startFast:
        yield* startFast();
        break;
      case HomeEvent.loading:
        yield* loading();
        break;
      default:
        yield* loading();
    }
  }

  Stream<HomeState> loading() async* {
    var isFasting = await AppSharedPreferences.getFastingStatus();
    if (isFasting) {
      yield* fasting();
    } else {
      yield* dontFast();
    }
  }

  Stream<HomeState> fasting() async* {
    Duration duration;
    //Meh, refacto necessary
    String curtProgram = await AppSharedPreferences.getData(AppSharedPreferences.SELECTED_PROGRAM);
    currentProgram = getEnumFromString(curtProgram);
    if (currentProgram == Program.sixteen) {
      duration = Duration(hours: 16);
    } else if (currentProgram == Program.eighteen) {
      duration = Duration(hours: 18);
    } else if (currentProgram == Program.twenty) {
      duration = Duration(hours: 20);
    }

    var startTime = await AppSharedPreferences.getData(AppSharedPreferences.PROGRAM_START_TIME);
    var start = DateTime.parse(startTime);
    var endTime = await AppSharedPreferences.getData(AppSharedPreferences.PROGRAM_END_TIME);
    var end = DateTime.parse(endTime);
    yield HomeFasting(startTime: start, endTime: end, program: currentProgram);
  }

  Stream<HomeState> startFast() async* {
    Duration duration;
    //Meh, refacto necessary
    String curtProgram = await AppSharedPreferences.getData(AppSharedPreferences.SELECTED_PROGRAM);
    currentProgram = getEnumFromString(curtProgram);
    if (currentProgram == Program.sixteen) {
      duration = Duration(hours: 16);
    } else if (currentProgram == Program.eighteen) {
      duration = Duration(hours: 18);
    } else if (currentProgram == Program.twenty) {
      duration = Duration(hours: 20);
    }

    DateTime now = DateTime.now();
    DateTime endTime = now.add(duration);

    await AppSharedPreferences.saveData(AppSharedPreferences.PROGRAM_END_TIME, endTime.toIso8601String());
    await AppSharedPreferences.saveData(AppSharedPreferences.PROGRAM_START_TIME, now.toIso8601String());
    AppSharedPreferences.setFastingStatus(AppSharedPreferences.IS_FASTING, true);

    AppNotification.schedule(duration, endTime);
    yield HomeFasting(startTime: now, endTime: endTime, program: currentProgram);
  }

  Stream<HomeState> dontFast() async* {
    AppSharedPreferences.setFastingStatus(AppSharedPreferences.IS_FASTING, false);
    AppNotification.clearPendingNotifications();
    yield HomeNotFasting();
  }

  String getStringFromProg(Program prog) {
    return programs[prog.index];
  }

  Duration getDurationFromProg(Program program) {
    if (currentProgram == Program.sixteen) {
      return Duration(hours: 16);
    } else if (currentProgram == Program.eighteen) {
      return Duration(hours: 18);
    } else if (currentProgram == Program.twenty) {
      return Duration(hours: 20);
    }
  }

  saveSuccess() async {
    var today = DateTime.now();
    var format = DateFormat('dd/MM');
    AppSharedPreferences.saveData(AppSharedPreferences.LAST_FAST_DAY, format.format(today));
    AppSharedPreferences.saveData(AppSharedPreferences.LAST_PROGRAM, getStringFromProg(currentProgram));

    var totalFastTime = await AppSharedPreferences.getData(AppSharedPreferences.TOTAL_FAST_TIME);
    var addedTime = int.parse(totalFastTime) + getDurationFromProg(currentProgram).inHours;
    AppSharedPreferences.saveData(AppSharedPreferences.TOTAL_FAST_TIME, addedTime.toString());

    var longest = await AppSharedPreferences.getData(AppSharedPreferences.TOTAL_FAST_COUNT);
    var addedCount = int.parse(longest) + 1;
    AppSharedPreferences.saveData(AppSharedPreferences.TOTAL_FAST_COUNT, addedCount.toString());
  }

  @override
  void onEvent(HomeEvent event) {
    super.onEvent(event);
  }

  @override
  void onChange(Change<HomeState> change) {
    super.onChange(change);
  }

  @override
  void onTransition(Transition<HomeEvent, HomeState> transition) {
    super.onTransition(transition);
  }

  Future<List<String>> getPrefsData() async {
    List<String> data = List<String>();
    data.add(await AppSharedPreferences.getData(AppSharedPreferences.LAST_FAST_DAY));
    data.add(await AppSharedPreferences.getData(AppSharedPreferences.LAST_PROGRAM));
    data.add(await AppSharedPreferences.getData(AppSharedPreferences.TOTAL_FAST_TIME));
    data.add(await AppSharedPreferences.getData(AppSharedPreferences.TOTAL_FAST_COUNT));
    return data;
  }

  Program getEnumFromString(String curtProgram) {
    int index = programs.indexWhere((element) => element == curtProgram);
    return Program.values[index];
  }

  void dispose() {
    AppNotification.stop();
  }
}

enum HomeEvent { fasting, notFasting, loading, startFast }
