import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../api_services/login_api .dart';
import '../providers/loginprovider.dart';
import '../providers/theme_providers.dart';

class MobileDrawer extends StatefulWidget {
  const MobileDrawer({super.key});

  @override
  State<MobileDrawer> createState() => _MobileDrawerState();
}

class _MobileDrawerState extends State<MobileDrawer> {

  @override
  Widget build(BuildContext context) {
    
     final themeProvider = Provider.of<ThemeProvider>(context);
    final themeState = Provider.of<ThemeProvider>(context);
    final LoginApiService authservice = LoginApiService();
    final personDetails=Provider.of<LoginProvider>(context).user;
    return Drawer(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Colors.white,
      elevation: 0,
      width: 250.w,
    child: Column(
      children: [
          Padding(
            padding: EdgeInsets.only(top: 70.h, left: 10.w),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30.r,
                      backgroundColor: Color.fromARGB(255, 80, 96, 203),
                      child: Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello,',
                          style: TextStyle(
                            fontSize: 14.w,
                            color: Color.fromARGB(255, 80, 96, 203),
                            fontFamily: "Lexend",
                          ),
                        ),
                        Text(
                          '${personDetails!.loginId}',
                          style: TextStyle(
                            fontSize: 20.w,
                            color: Color.fromARGB(255, 80, 96, 203),
                            fontFamily: "Lexend",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),


      SizedBox(height: 30.h),
          ListTile(
            leading: SvgPicture.asset(
              'assets/svg/log-out.svg',
              color: Colors.red,
              width: 25.w,
            ),  
            title: Text(
              'LOGOUT',
              style: TextStyle(fontSize: 16.sp, color: Colors.black, fontFamily: "Lexend"),
            ),
            onTap: () {
              authservice.logOutUSer(context);
            },
          ),
      ],
      
    ),
    );

  }
}