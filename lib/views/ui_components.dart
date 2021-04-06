import 'package:fastapp/util/colors.dart';
import 'package:fastapp/util/hard_data.dart';
import 'package:fastapp/util/styles.dart';
import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  final Widget content;

  HomeCard(this.content);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: content,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: AppColors.card,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: Offset(1.0, 1.0),
            blurRadius: 6.0,
          ),
        ],
      ),
    );
  }
}

class HeaderColumn extends StatelessWidget {
  final String label;
  final String value;
  final bool isResting;

  HeaderColumn(this.label, this.value, {this.isResting = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isResting ? 140 : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: isResting ? AppStyles.HeaderCardLabelStyleResting : AppStyles.HeaderCardLabelStyle),
          SizedBox(height: 10),
          Text(value, style: isResting ? AppStyles.HeaderCardValueStyleResting : AppStyles.HeaderCardValueStyle),
        ],
      ),
    );
  }
}

class ProgressView extends StatelessWidget {
  final double progress;

  ProgressView(this.progress);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: 32,
        padding: const EdgeInsets.all(2),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: LinearProgressIndicator(
                value: progress,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.progress),
                backgroundColor: AppColors.card,
              ),
            ),
            Positioned(right: 10, child: Text((progress * 100).toStringAsFixed(2) + ' %', style: AppStyles.ProgressStyle)),
          ],
        ));
  }
}

class CircleView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 23, top: 10),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.blue_dark,
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final bool isFasting;
  final Function() onClicked;

  ActionButton(this.isFasting, this.onClicked);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClicked();
      },
      child: Container(
        width: 180,
        height: 50,
        child: Center(
            child: Text(
          isFasting ? 'Arrêter' : 'Commencer',
          style: isFasting ? AppStyles.StopFasting : AppStyles.StartFasting,
        )),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: AppColors.card,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.16),
              offset: Offset(1.0, 1.0),
              blurRadius: 6.0,
            ),
          ],
        ),
      ),
    );
  }
}

class StageStep extends StatelessWidget {
  final String title;
  final String subTitle;

  StageStep(this.title, this.subTitle);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StepIndicator(),
        Container(
          margin: const EdgeInsets.only(left: 20),
          width: MediaQuery.of(context).size.width * 0.70,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppStyles.StageLabel),
              SizedBox(height: 10),
              Text(subTitle),
            ],
          ),
        ),
      ],
    );
  }
}

class StepIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              margin: EdgeInsets.only(left: 30),
              color: AppColors.blue_light,
              height: 150,
              width: 6,
            ),
            CircleView(),
          ],
        )
      ],
    );
  }
}

class StartFastDialogContainer extends StatefulWidget {
  final Function(String) onSelected;

  StartFastDialogContainer(this.onSelected);

  @override
  _StartFastDialogContainerState createState() => _StartFastDialogContainerState();
}

class _StartFastDialogContainerState extends State<StartFastDialogContainer> {
  String _currentProg = '16:8';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 230,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Programe :',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 20),
          Container(
            width: 100,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: programs.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 50,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                        width: _currentProg == programs[index] ? 2 : 1, color: _currentProg == programs[index] ? AppColors.blue_dark : Colors.grey),
                  ),
                  margin: const EdgeInsets.all(8),
                  child: Center(
                      child: TextButton(
                          style: TextButton.styleFrom(
                            primary: _currentProg == programs[index] ? AppColors.blue_dark : Colors.black54,
                            textStyle: TextStyle(
                              color: _currentProg == programs[index] ? AppColors.blue_dark : Colors.black54,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _currentProg = programs[index];
                              widget.onSelected(_currentProg);
                            });
                          },
                          child: Container(
                              width: 100,
                              child: Center(
                                  child: Text(
                                '${programs[index]}',
                                style: TextStyle(color: Colors.white),
                              ))))),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
