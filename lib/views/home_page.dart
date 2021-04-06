import 'package:fastapp/bloc/home_bloc.dart';
import 'package:fastapp/notifications.dart';
import 'package:fastapp/state/home_state.dart';
import 'package:fastapp/util/colors.dart';
import 'package:fastapp/views/fasting_view.dart';
import 'package:fastapp/views/no_fasting_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  static String ID = 'HomePage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    AppNotification.stop();
    BlocProvider.of<HomeBloc>(context).close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocProvider(
        create: (context) => HomeBloc(),
        child: homeContent(),
      ),
    );
  }

  Widget homeContent() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeNotFasting) {
          return NoFastingView();
        } else if (state is HomeFasting) {
          HomeFasting homeFasting = state;
          return FastingView(homeFasting);
        } else {
          BlocProvider.of<HomeBloc>(context).add(HomeEvent.loading);
          return buildLoading();
        }
      },
    );
  }

  Widget buildLoading() {
    return Center(child: CircularProgressIndicator());
  }
}
