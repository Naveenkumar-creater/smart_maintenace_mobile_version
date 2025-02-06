import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:suja_shoie_app/feature/presentation/mobile_page/moblie_drawer.dart';
import 'package:suja_shoie_app/feature/presentation/widget/home_page_widget/work_schedule/workorder_widget/work_order.dart';

import '../../../constant/utils/font_styles.dart';
import '../providers/theme_providers.dart';
import '../widget/home_page_widget/work_schedule/chart/bar_chart.dart';
import '../widget/home_page_widget/work_schedule/qr_workorder_data/scan_barcode.dart';
import '../widget/main_page_widget/user_locations.dart';

class MobileHomePage extends StatelessWidget {
  const MobileHomePage({super.key});

  @override
  Widget build(BuildContext context) {
        final themeState = Provider.of<ThemeProvider>(context);
    return Scaffold(


    drawer: const MobileDrawer(),

      appBar: AppBar(
        backgroundColor:  const Color(0xFF25476A),
         iconTheme: IconThemeData(color: Colors.white),
        title:   Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Text(
                          'Smart Maintenance',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        //  Row(children: [

                        // UserDetails(),
                        // ],)
                      ]
                     ,
      ),
    ),

    body: Padding(
      padding:  EdgeInsets.all(10.sp),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
           Headings(
      subHeading: "User Location",              ),
          
                UserLocationDetails()
              ],
            ),
      
      SizedBox(height: 8.h,),  
            WorkOrder(crossAxisCount: 2,childAspectRatio: 2,),
            SizedBox(height: 8.h,), 
            ScanBarcode(themeState: themeState),
            
      SizedBox(height: 8.h,),
      BarChart(themeState: themeState)
      
          ],
        ),
      ),
    ),
    );

  }
}