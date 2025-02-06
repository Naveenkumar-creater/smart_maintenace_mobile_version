import 'package:flutter/material.dart';
import 'package:suja_shoie_app/constant/utils/responsive.dart';
import 'package:suja_shoie_app/feature/presentation/pages/login_page.dart';

import '../mobile_page/mobile_login_page.dart';

class ResponsiveLoginPage extends StatelessWidget {
  const ResponsiveLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Responsive(
      
      mobile: MobileLoginPage(), tablet: Loginpage(), desktop: Text(""));
  }
}