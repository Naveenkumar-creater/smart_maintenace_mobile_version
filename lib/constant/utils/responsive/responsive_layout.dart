import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  const Responsive({
     this.mobile,
     this.desktop,
     this.tablet

  });
  final Widget ? mobile;
  final Widget ? tablet;
  final Widget ? desktop;

  @override
  Widget build(BuildContext context) {
    final ScreenWidth=MediaQuery.of(context).size.width;

    if(ScreenWidth>=1300){
      return desktop ?? Container();
    }
    else if (ScreenWidth>=600 && ScreenWidth<1300){
      return tablet ?? Container();

    }
    else{
      return mobile ?? Container();
    }


  }
}