import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../pedestrian_app_theme.dart';

class AreaListView extends StatefulWidget {
  const AreaListView(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController mainScreenAnimationController;
  final Animation<dynamic> mainScreenAnimation;
  @override
  _AreaListViewState createState() => _AreaListViewState();
}

class _AreaListViewState extends State<AreaListView>
    with TickerProviderStateMixin {
  bool buttonHighlightState = false;
  AnimationController animationController;
  List<String> areaListData = <String>[
    'assets/pedestrian_app/Active_img.png',
    'assets/pedestrian_app/Bicycle_img.png',
    'assets/pedestrian_app/Blind_img.png',
    'assets/pedestrian_app/Wheelchair_img.png',
    'assets/pedestrian_app/Crosswalk_img.png',
    'assets/pedestrian_app/Walker_dog_img.png',
  ];
  List<bool> isSelectedList;

  void buttonPressed(indexPressed) {
    final _isSelectedList = isSelectedList;
    isSelectedList.asMap().forEach((index, value) {
      if (indexPressed == index) {
        _isSelectedList[index] = !value;
      }
      else {
        _isSelectedList[index] = false;
      }
    });

    setState(() {
      isSelectedList = _isSelectedList;
    });
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    isSelectedList = List.filled(areaListData.length, false);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation.value), 0.0),
            child: Container(
              height: areaListData.length * 100.0,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: GridView(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 16),
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  children: List<Widget>.generate(
                    areaListData.length,
                    (int index) {
                      final int count = areaListData.length;
                      final Animation<double> animation =
                          Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animationController,
                          curve: Interval((1 / count) * index, 1.0,
                              curve: Curves.fastOutSlowIn),
                        ),
                      );
                      animationController.forward();
                      return AreaView(
                        imagepath: areaListData[index],
                        animation: animation,
                        animationController: animationController,
                        onPressed: () {
                          buttonPressed(index);
                        },
                        isSelected: isSelectedList[index],
                      );
                    },
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 24.0,
                    crossAxisSpacing: 24.0,
                    childAspectRatio: 1.0,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AreaView extends StatefulWidget {
  AreaView({
    Key key,
    this.imagepath,
    this.animationController,
    this.animation,
    this.onPressed,
    this.isSelected,
  }) : super(key: key);
  final String imagepath;
  final AnimationController animationController;
  final Animation<dynamic> animation;
  final Function() onPressed;
  bool isSelected;
  @override
  _AreaViewState createState() => _AreaViewState();
}

class _AreaViewState extends State <AreaView>{
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - widget.animation.value), 0.0),
            child: Container(
              decoration: BoxDecoration(
                color: widget.isSelected ? FitnessAppTheme.deactivatedText : FitnessAppTheme.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    topRight: Radius.circular(8.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: FitnessAppTheme.grey.withOpacity(0.4),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10.0),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  splashColor: FitnessAppTheme.nearlyDarkBlue.withOpacity(0.2),
                  onTap: () {
                    widget.onPressed();
                    setState(() {
                      widget.isSelected = !widget.isSelected;
                    });
                    },
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 16, left: 16, right: 16),
                        child: Image.asset(widget.imagepath),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
