import 'package:fastapp/util/colors.dart';
import 'package:flutter/material.dart';

class AppStyles {
  static const TextStyle HeaderTextStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26);

  static const TextStyle HeaderCardLabelStyle = TextStyle(color: AppColors.blue_light, fontWeight: FontWeight.normal, fontSize: 16);
  static const TextStyle HeaderCardLabelStyleResting = TextStyle(color: AppColors.green_light, fontWeight: FontWeight.normal, fontSize: 16);

  static const TextStyle HeaderCardValueStyle = TextStyle(color: AppColors.blue_dark, fontWeight: FontWeight.bold, fontSize: 24);
  static const TextStyle HeaderCardValueStyleResting = TextStyle(color: AppColors.green_dark, fontWeight: FontWeight.bold, fontSize: 26);

  static const TextStyle ProgressStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20);
  static const TextStyle ProgressStyleHigh = TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20);
  static const TextStyle StageLabel = TextStyle(color: AppColors.blue_dark, fontWeight: FontWeight.bold, fontSize: 18);
  static const TextStyle StageValue = TextStyle(color: AppColors.blue_dark, fontWeight: FontWeight.bold, fontSize: 26);
  static const TextStyle StopFasting = TextStyle(color: AppColors.red, fontWeight: FontWeight.bold, fontSize: 20);
  static const TextStyle StartFasting = TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20);

  static const TextStyle CardTitle = TextStyle(color: AppColors.green_dark, fontWeight: FontWeight.bold, fontSize: 16);

  static const TextStyle DialogTitle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18);
  static const TextStyle DialogCancel = TextStyle(color: Colors.white, fontSize: 16);
  static const TextStyle DialogValid = TextStyle(color: Colors.white, fontSize: 16);

  static const TextStyle Steps = TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.progress);
}
