import 'package:fastapp/bloc/home_bloc.dart';
import 'package:fastapp/util/colors.dart';
import 'package:fastapp/util/styles.dart';
import 'package:fastapp/views/ui_components.dart';
import 'package:fastapp/views/webview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoFastingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: ActionButton(false, () {
          showStartFastDialog(context, (value) {
            BlocProvider.of<HomeBloc>(context).setFastProgram(value);
            BlocProvider.of<HomeBloc>(context).add(HomeEvent.startFast);
            Navigator.of(context).pop();
          }, () {
            Navigator.of(context).pop();
          });
        }),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  FutureBuilder<List<String>>(
                      future: BlocProvider.of<HomeBloc>(context).getPrefsData(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Container(
                                margin: EdgeInsets.only(top: (MediaQuery.of(context).size.height * 0.10), left: 20, right: 20),
                                width: double.infinity,
                                child: Text('On jeûne ?', style: AppStyles.HeaderTextStyle, textAlign: TextAlign.center)),
                            SizedBox(height: 40),
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: HomeCard(Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      HeaderColumn('Dernier jeûne', snapshot.data[0], isResting: true),
                                      HeaderColumn('Dernier programme', snapshot.data[1], isResting: true),
                                    ],
                                  ),
                                  SizedBox(height: 30),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      HeaderColumn('Total heures', snapshot.data[2], isResting: true),
                                      HeaderColumn('Total jeûnes', snapshot.data[3], isResting: true),
                                    ],
                                  ),
                                ],
                              )),
                            ),
                            SizedBox(height: 20),
                            Center(
                              child: HomeCard(
                                ListTile(
                                  onTap: () {
                                    launchBottomFastingSteps(context);
                                  },
                                  title: Text('Étapes du jeûne', style: AppStyles.CardTitle),
                                  trailing: Icon(Icons.arrow_forward, color: AppColors.green_light),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Center(
                              child: HomeCard(
                                ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) => Webview(url: 'https://yuka.io/sante-jeune/'),
                                      ),
                                    );
                                  },
                                  title: Text('Plus d\informations', style: AppStyles.CardTitle),
                                  trailing: Icon(Icons.arrow_forward, color: AppColors.green_light),
                                ),
                              ),
                            ),
                          ],
                        );
                      })
                ],
              ),
            ],
          ),
        ));
  }

  void launchBottomFastingSteps(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          backgroundColor: AppColors.card,
          scrollable: true,
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Quitter'))
          ],
          content: Column(
            children: [
              ListTile(
                title: Text(
                  '4h à 8h ',
                  style: AppStyles.Steps,
                ),
                subtitle: Text(
                  'Baisse du niveau de sucre et d\'insuline dans le sang',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              ListTile(
                title: Text(
                  '8h à 12h ',
                  style: AppStyles.Steps,
                ),
                subtitle: Text(
                  'Repos du systeme digestif\n'
                  'Toute la nourriture à été digerée\n'
                  'Augmentation de l\'hormone de croissance',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              ListTile(
                title: Text(
                  '12h à 14h ',
                  style: AppStyles.Steps,
                ),
                subtitle: Text(
                  'La graisse comment à brûler\n',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              ListTile(
                title: Text(
                  '16h à 20h ',
                  style: AppStyles.Steps,
                ),
                subtitle: Text(
                  'La graisse continue de brûler\n'
                  'L\'autophagie commence\n'
                  'Diffusier de cétones\n',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              ListTile(
                title: Text(
                  '20h à 36h ',
                  style: AppStyles.Steps,
                ),
                subtitle: Text(
                  'L\'autophagie augmente fortement\n',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              ListTile(
                title: Text(
                  '36h à 48h ',
                  style: AppStyles.Steps,
                ),
                subtitle: Text(
                  'Début de la régénération cellulaire\n',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              ListTile(
                title: Text(
                  '48h à 72h ',
                  style: AppStyles.Steps,
                ),
                subtitle: Text(
                  'Pic de l\'autophagie\n',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

void showStartFastDialog(BuildContext context, Function(String) onValid, Function onCancel) {
  String _currentProg = '16:8';

  showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
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
                margin: const EdgeInsets.only(top: 12),
                child: Center(
                    child: Text(
                  "New fast",
                  style: AppStyles.DialogTitle,
                )),
              ),
            ],
          ),
          content: StartFastDialogContainer((value) {
            _currentProg = value;
          }),
          actions: <Widget>[
            FlatButton(
              child: Container(
                width: 110,
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
                onCancel();
              },
            ),
            FlatButton(
              child: Container(
                width: 110,
                height: 40,
                child: Center(
                  child: Text(
                    'Commencer',
                    style: AppStyles.DialogValid,
                  ),
                ),
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              onPressed: () {
                onValid(_currentProg);
              },
            ),
          ],
        );
      });
}
