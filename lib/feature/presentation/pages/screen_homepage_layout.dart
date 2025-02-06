import 'package:flutter/material.dart';
import 'package:suja_shoie_app/constant/utils/responsive/responsive_layout.dart';
import 'package:suja_shoie_app/feature/presentation/pages/main_page.dart';

import '../mobile_page/mobile_home_page.dart';

class ScreenHomePageLayout extends StatelessWidget {
  const ScreenHomePageLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile:const MobileHomePage( ) ,
      tablet:const  MainPage(),
      desktop: Container() ,
    );
  }
}