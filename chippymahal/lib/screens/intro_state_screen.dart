import 'package:sabon/screens/tab_landing_screen.dart';
import 'package:sabon/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroSliderScreen extends StatefulWidget {
  @override
  _IntroSliderScreenState createState() => _IntroSliderScreenState();
}

class _IntroSliderScreenState extends State<IntroSliderScreen> {
  List<Slide> slides = new List();

  Function goToTab;

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
          title: "Order the delicious food",
          styleTitle: TextStyle(
              color: Color(0xff3da4ab),
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'RobotoMono'),
          description: "Browse delicious food online.",
          styleDescription: TextStyle(
              color: Color(0xfffe9c8f),
              fontSize: 20.0,
              fontStyle: FontStyle.italic,
              fontFamily: 'Raleway'),
          pathImage: "assets/images/Choose.png",
          heightImage: 30.0,
          widthImage: 30.0),
    );
    slides.add(
      new Slide(
          title: "Pay for the food",
          styleTitle: TextStyle(
              color: Color(0xff3da4ab),
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'RobotoMono'),
          description:
              "Multiple payment options integrated which are fast and secured.",
          styleDescription: TextStyle(
              color: Color(0xfffe9c8f),
              fontSize: 20.0,
              fontStyle: FontStyle.italic,
              fontFamily: 'Raleway'),
          pathImage: "assets/images/Pay.png",
          heightImage: 30.0,
          widthImage: 30.0),
    );
    slides.add(
      new Slide(
          title: "Get the food delivered",
          styleTitle: TextStyle(
              color: Color(0xff3da4ab),
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'RobotoMono'),
          description: "Get the delicious food delivered at your door-steps",
          styleDescription: TextStyle(
              color: Color(0xfffe9c8f),
              fontSize: 20.0,
              fontStyle: FontStyle.italic,
              fontFamily: 'Raleway'),
          pathImage: "assets/images/enjoy.png",
          heightImage: 30.0,
          widthImage: 30.0),
    );
  }

  void onDonePress() async {
    // Back to the first tab
//    this.goToTab(0);
    print('onDonePress---');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('login', '1');

    Navigator.of(context).pop();

    Navigator.push(
        context,
        MaterialPageRoute(
            fullscreenDialog: true,
            builder: (BuildContext context) => LoginScreen()));
  }

  void onTabChangeCompleted(index) {
    // Index of current tab is focused
    print('check---');
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: Color(0xffffcc5c),
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: Color(0xffffcc5c),
    );
  }

  Widget renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: Color(0xffffcc5c),
    );
  }

  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = new List();
    for (int i = 0; i < slides.length; i++) {
      Slide currentSlide = slides[i];
      tabs.add(Container(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          margin: EdgeInsets.only(bottom: 60.0, top: 60.0),
          child: ListView(
            children: <Widget>[
              GestureDetector(
                  child: Image.asset(
                currentSlide.pathImage,
                width: 200.0,
                height: 200.0,
                fit: BoxFit.contain,
              )),
              Container(
                child: Text(
                  currentSlide.title,
                  style: currentSlide.styleTitle,
                  textAlign: TextAlign.center,
                ),
                margin: EdgeInsets.only(top: 20.0),
              ),
              Container(
                child: Text(
                  currentSlide.description,
                  style: currentSlide.styleDescription,
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                margin: EdgeInsets.only(top: 20.0),
              ),
            ],
          ),
        ),
      ));
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IntroSlider(
        // List slides
        slides: this.slides,

        // Skip button
        renderSkipBtn: this.renderSkipBtn(),
        colorSkipBtn: Color(0x33ffcc5c),
        highlightColorSkipBtn: Color(0xffffcc5c),

        // Next button
        renderNextBtn: this.renderNextBtn(),

        // Done button
        renderDoneBtn: this.renderDoneBtn(),
        onDonePress: this.onDonePress,
        colorDoneBtn: Color(0x33ffcc5c),
        highlightColorDoneBtn: Color(0xffffcc5c),

        // Dot indicator
        colorDot: Color(0xffffcc5c),
        sizeDot: 13.0,
//      typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,

        // Tabs
        listCustomTabs: this.renderListCustomTabs(),
        backgroundColorAllSlides: Colors.white,
        refFuncGoToTab: (refFunc) {
          this.goToTab = refFunc;
        },

        // Show or hide status bar
        shouldHideStatusBar: true,

        // On tab change completed
        onTabChangeCompleted: this.onTabChangeCompleted,
      ),
    );
  }
}
