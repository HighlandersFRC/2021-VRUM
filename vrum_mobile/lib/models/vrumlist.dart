//import 'package:best_flutter_ui_templates/design_course/home_design_course.dart';
import 'package:vrum_mobile/app_theme.dart';
import 'package:vrum_mobile/roaduser_app/roaduser_home_screen.dart';
import 'package:vrum_mobile/pedestrian_app/pedestrian_app_home_screen.dart';
import 'package:flutter/widgets.dart';

class HomeList {
  HomeList({
    this.navigateScreen,
    this.imagePath = '',
  });

  Widget navigateScreen;
  String imagePath;

  static List<HomeList> homeList = [
    HomeList(
      imagePath: 'assets/fitness_app/Vehicle.png',
      navigateScreen: HotelHomeScreen(),
    ),
    HomeList(
      imagePath: 'assets/pedestrian_app/Active_img.png',
      navigateScreen: FitnessAppHomeScreen(),
    ),
   // HomeList(
   //   imagePath: 'assets/design_course/design_course.png',
   //   navigateScreen: DesignCourseHomeScreen(),
   // ),
  ];
}
