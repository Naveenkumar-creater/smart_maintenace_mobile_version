import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suja_shoie_app/constant/utils/lottieLoadingAnimation.dart';
import 'package:suja_shoie_app/constant/utils/theme_styles.dart';

import '../../../../api_services/checklist_service.dart';
import '../../../../api_services/qrscanner_service.dart';
import '../../../../mobile_page/mobile_home_page.dart';
import '../../../../pages/main_page.dart';
import '../../../../providers/checklist_provider.dart';
import '../../../../providers/orgid_provider.dart';
import '../../../../providers/theme_providers.dart';
import 'asset_list_expended.dart';

class CheckListCardView extends StatefulWidget {
  final int assetId;
  // final String asstName;
  // final String location;
  // final String barcode;

  const CheckListCardView(
      this.assetId, {super.key}
      // this.asstName, this.location, this.barcode);
  );
  @override
  _CheckListCardViewState createState() => _CheckListCardViewState();
}

class _CheckListCardViewState extends State<CheckListCardView> {
  final CheckListService _checkListService = CheckListService();

  final QrScannerService _qrScannerService = QrScannerService();
  bool isLoading = true;

@override
void initState() {
  _fetchCheckList();
}

Future<void> _fetchCheckList() async {
  try {
    // // Simulate a 2-second loading delay
    // await Future.delayed(const Duration(seconds: 1));
final orgId=Provider.of<OrgIdProvider>(context,listen: false).orgid;
    await _checkListService.getCheckList(
      context: context,
      id: widget.assetId,
      orgid: orgId ?? 0
    ); 

    setState(() {
      isLoading = false;
    });
  } catch (e) {
    // ignore: avoid_print
    print('Error fetching checklist: $e');
    setState(() {
      isLoading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final size= MediaQuery.of(context).size.width< 600;
    return size ?
    
    
    WillPopScope(
      onWillPop: () async {
        // Navigate back to MainPage and replace the current page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MobileHomePage(),
          ),
        );
        return true; // Prevent default back button behavior
      },
      child: Scaffold(
       appBar: AppBar(
         automaticallyImplyLeading: true,
                       iconTheme: const IconThemeData(
    color: Colors.white, 
  ),
  toolbarHeight: 70,

         title: PreferredSize(
            preferredSize: const Size.fromHeight(20),
            child: Consumer<CheckListProvider>(
              builder: (context, checkListProvider, _) {
                final responseData = checkListProvider.user?.responseData;
                final asset = responseData?.checklist ?? [];
                String firstChecklistItem = '';
       
                if (asset.isNotEmpty) {
                  firstChecklistItem = asset[0].assetname;
                }
       
                return Container(
                  color: themeProvider.isDarkTheme
                      ? const Color(0xFF212121)
                      : const Color(0xFF25476A),
       
              
                  child: Text(
                    firstChecklistItem,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
       ),
        body: Consumer<CheckListProvider>(
          builder: (context, checkListProvider, _) {
            final responseData = checkListProvider.user?.responseData;
            final checklist = responseData?.checklist ?? [];
    
            return 
            
            
            isLoading
                ?  Center(
                    child: LottieLoadingAnimation(),
                  )
                : checklist.isEmpty
                    ? const Center(
                        child: Text("No checklist data"),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            ChecklistWidget(
                              checklist: checklist,
                              assetId: widget.assetId,
                              title: 'CheckList',
                            ),
                           
                            
               
                          ],
                        ),
                      );
          },
        ),
      ),
    ):
    
    WillPopScope(
      onWillPop: () async {
        // Navigate back to MainPage and replace the current page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ),
        );
        return true; // Prevent default back button behavior
      },
      child: Scaffold(
       appBar: AppBar(
         automaticallyImplyLeading: true,
                       iconTheme: const IconThemeData(
    color: Colors.white, 
  ),
  toolbarHeight: 90,
         title: PreferredSize(
            preferredSize: const Size.fromHeight(90),
            child: Consumer<CheckListProvider>(
              builder: (context, checkListProvider, _) {
                final responseData = checkListProvider.user?.responseData;
                final asset = responseData?.checklist ?? [];
                String firstChecklistItem = '';
       
                if (asset.isNotEmpty) {
                  firstChecklistItem = asset[0].assetname;
                }
       
                return Container(
                  color: themeProvider.isDarkTheme
                      ? const Color(0xFF212121)
                      : const Color(0xFF25476A),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: 100,
                  child: SafeArea(
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                firstChecklistItem,
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              // You can add other widgets for the right side of the app bar here.
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
       ),
        body: Consumer<CheckListProvider>(
          builder: (context, checkListProvider, _) {
            final responseData = checkListProvider.user?.responseData;
            final checklist = responseData?.checklist ?? [];
    
            return 
            
            isLoading
                ?  Center(
                    child: LottieLoadingAnimation(),
                  )
                : checklist.isEmpty
                    ? const Center(
                        child: Text("No checklist data"),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            ChecklistWidget(
                              checklist: checklist,
                              assetId: widget.assetId,
                              title: 'CheckList',
                            ),
                           
                            Expanded(
                                flex: 1,
                                child: Container(
                                  padding:
                                      const EdgeInsets.only(left: defaultPadding * 5),
                                  child: const Text(
                                    "Work Order",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                            Expanded(
                                flex: 1,
                                child: Container(
                                  padding:
                                      const EdgeInsets.only(left: defaultPadding * 5),
                                  child: const Text(
                                    "Support Ticket",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                                 Expanded(
                                flex: 1,
                                child: Container(
                                  padding:
                                      const EdgeInsets.only(left: defaultPadding * 5),
                                  child: const Text(
                                    "Other Task",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
    
                            //  ChecklistWidget(checklist: checklist, title: 'Work Order',),
                            //  ChecklistWidget(checklist: checklist, title: 'Support Ticket',),
                            //  ChecklistWidget(checklist: checklist, title: 'CheckList',)
                          ],
                        ),
                      );
          },
        ),
      ),
    );
  }
}

// class OtherPage extends StatelessWidget {
//   const OtherPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Other Page"),
//       ),
//       body: const Center(
//         child: Text("Other Page Contents"),
//       ),
//     );
//   }
// }
