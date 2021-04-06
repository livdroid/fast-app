import 'package:fastapp/bloc/home_bloc.dart';
import 'package:flutter/cupertino.dart';

class HomeNotFasting extends HomeState {
  const HomeNotFasting();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeFasting extends HomeState {
  final Program program;
  final DateTime startTime;
  final DateTime endTime;
  HomeFasting({@required this.startTime, @required this.endTime, @required this.program});
}

abstract class HomeState {
  const HomeState();
}
