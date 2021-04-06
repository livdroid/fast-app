import 'dart:async';

import 'package:fastapp/bloc/home_bloc.dart';
import 'package:fastapp/state/home_state.dart';
import 'package:fastapp/util/colors.dart';
import 'package:fastapp/util/styles.dart';
import 'package:fastapp/views/ui_components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FastingView extends StatefulWidget {
  final HomeFasting homeFasting;

  FastingView(this.homeFasting);

  @override
  _FastingViewState createState() => _FastingViewState();
}

format(Duration d) => d.toString().split('.').first.padLeft(8, "0").replaceAll('-', '0');

class _FastingViewState extends State<FastingView> {
  Timer timer;
  DateTime start;
  DateTime end;
  Program program;

  @override
  void initState() {
    super.initState();
    start = widget.homeFasting.startTime;
    end = widget.homeFasting.endTime;
    program = widget.homeFasting.program;
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    BlocProvider.of<HomeBloc>(context).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    Duration progDuration = BlocProvider.of<HomeBloc>(context).getDurationFromProg(program);
    String progString = BlocProvider.of<HomeBloc>(context).getStringFromProg(program);

    Duration diffStartAndNow = start.difference(now); //time done
    Duration diffEndAndNow = end.difference(now); //time left

    String left = format(diffEndAndNow);
    String done = format(diffStartAndNow);

    var total = end.millisecondsSinceEpoch - start.millisecondsSinceEpoch;
    var progress = now.millisecondsSinceEpoch - start.millisecondsSinceEpoch;
    var percent = (progress / total);

    if (percent >= 1) {
      percent = 1;
      timer.cancel();
      WidgetsBinding.instance.addPostFrameCallback((_) => showSuccessDialog(context, format(progDuration), () {
            BlocProvider.of<HomeBloc>(context).saveSuccess();
            BlocProvider.of<HomeBloc>(context).add(HomeEvent.notFasting);
            Navigator.of(context).pop();
          }));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ActionButton(true, () {
        finishFastingDialog(context);
      }),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.only(top: (MediaQuery.of(context).size.height * 0.10), left: 20, right: 20),
                    width: double.infinity,
                    child: Text('Jeûne en cours', style: AppStyles.HeaderTextStyle, textAlign: TextAlign.center)),
                SizedBox(height: 40),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: HomeCard(Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [HeaderColumn('Restant', left), HeaderColumn('Fait', done), HeaderColumn('Programme', progString)],
                  )),
                ),
                SizedBox(height: 20),
                Container(width: double.infinity, margin: EdgeInsets.only(left: 20, right: 20), child: ProgressView(percent)),
              ],
            )
          ],
        ),
      ),
    );
  }

  showSuccessDialog(BuildContext context, String timeDone, Function() onPressed) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
              titlePadding: const EdgeInsets.all(0),
              title: Stack(
                children: [
                  Image.asset('assets/dialog_header.png'),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Center(
                        child: Text(
                      'Terminé ! !',
                      style: AppStyles.DialogTitle,
                    )),
                  ),
                ],
              ),
              content: Text('Bravo :) Tu viens de fini ton jeûne !'),
              actions: <Widget>[
                FlatButton(
                  child: Container(
                    width: 100,
                    height: 40,
                    child: Center(
                      child: Text(
                        'Merci',
                        style: AppStyles.DialogValid,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.blue_dark,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () {
                    onPressed();
                  },
                ),
              ],
            ));
  }

  void finishFastingDialog(BuildContext ctx) {
    showDialog(
        context: ctx,
        builder: (_) => AlertDialog(
              backgroundColor: AppColors.card,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
              titlePadding: const EdgeInsets.all(0),
              title: Stack(
                children: [
                  Image.asset(
                    'assets/dialog_header.png',
                    color: AppColors.blue,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Center(
                        child: Text(
                      'Arrêter le jeûne',
                      style: AppStyles.DialogTitle,
                    )),
                  ),
                ],
              ),
              content: Text('Étes-vous sûre ? \nVous perdrez votre progression.', style: TextStyle(color: Colors.white)),
              actions: <Widget>[
                FlatButton(
                  child: Container(
                    width: 100,
                    height: 40,
                    child: Center(
                      child: Text(
                        'Annuler',
                        style: AppStyles.DialogCancel,
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(color: AppColors.blue),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Container(
                    width: 100,
                    height: 40,
                    child: Center(
                      child: Text(
                        'Arrêter',
                        style: AppStyles.DialogValid,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () {
                    timer.cancel();
                    BlocProvider.of<HomeBloc>(ctx).add(HomeEvent.notFasting);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }
}
