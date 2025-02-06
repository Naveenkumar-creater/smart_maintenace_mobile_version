import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:suja_shoie_app/feature/presentation/widget/login_page_widget/auth.dart';

class MobileLoginPage extends StatelessWidget {
  const MobileLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
             image: AssetImage('assets/images/bg1.jpg'),
              fit: BoxFit.cover
              )
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
         Padding(
                     padding:  EdgeInsets.only(top: 60.h,left: 20.w),
                     child: SizedBox(
                      height: 80.h,
                      child: Image.asset('assets/images/Prominous-logo-white.png')),
                   ),
                  ],
                ),

SizedBox(height: 125,),
                Container(

decoration: BoxDecoration(
         color: Color.fromARGB(98, 225, 229, 255),
                borderRadius: BorderRadius.circular(5),
),
                  width: 350,
                  height: 350,
                  child: Auth(),
                )
              ],
            ),
          )
        ],
      )
    );
  }
}