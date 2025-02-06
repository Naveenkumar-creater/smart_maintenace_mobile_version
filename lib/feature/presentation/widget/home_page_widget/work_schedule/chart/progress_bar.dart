import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suja_shoie_app/constant/utils/font_styles.dart';
import 'package:suja_shoie_app/feature/presentation/api_services/get_machine_count_service.dart';
import 'package:suja_shoie_app/feature/presentation/providers/get_machine_count_provider.dart';

import '../../../../../../constant/utils/theme_styles.dart';
import '../../../../providers/orgid_provider.dart';
import '../../../../providers/theme_providers.dart';
import 'progress_bar/circular_progress_bar.dart';
import '../dropdown_code/workorder_widget/dropdown_circularbar.dart';


class ProgressBar extends StatefulWidget {
  const ProgressBar({
    Key? key,
    required this.themeState,
  }) : super(key: key);

  final ThemeProvider themeState;

  @override
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  int selectedValueIndex = 0;

  // Store fetched data for each machine status
  final Map<int, Map<String, dynamic>> _machineStatusData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllMachineStatusData();
  }

  // Callback to handle dropdown changes
  void onDropdownChanged(int index) {
    setState(() {
      selectedValueIndex = index;
    });
  }

  // Fetch data for all machine statuses
  Future<void> _fetchAllMachineStatusData() async {
    const machineStatuses = [300, 400, 500, 600];

    try {
      final orgId = Provider.of<OrgIdProvider>(context, listen: false).orgid;

      for (final status in machineStatuses) {
        final data = await _loadStatusCount(status, orgId);
        _machineStatusData[status] = data;
      }
    } catch (e) {
      // Handle errors
      for (final status in machineStatuses) {
        _machineStatusData[status] = {
          'acrpInspectionStatusCount': 0,
          'acrpAssetIdCount': 0,
        };
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Load machine status count
  Future<Map<String, dynamic>> _loadStatusCount(int machineStatus, int? orgId) async {
    final getMachineCountService = GetmachineCountService();

    try {
      await getMachineCountService.getMachineCount(
        context: context,
        machineStatus: machineStatus,
        orgid: orgId ?? 0,
      );

      final getmachineStatusCountProvider =
          Provider.of<GetMachineCountProvider>(context, listen: false);

      return {
        'acrpInspectionStatusCount': getmachineStatusCountProvider.user?.acrpInspectionStatusCount ?? 0,
        'acrpAssetIdCount': getmachineStatusCountProvider.user?.acrpAssetIdCount ?? 0,
      };
    } catch (e) {
      return {'acrpInspectionStatusCount': 0, 'acrpAssetIdCount': 0};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Colors.black,
      child: Container(
        decoration: BoxDecoration(
          color: widget.themeState.isDarkTheme
              ? const Color(0xFF424242)
              : Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        height: 248,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              DropdownMenuCircular(
                option: const Text('ALL Machine'),
                inProgress: const Text('Open Machine Count'),
                complete: const Text('InProgress Machine Count '),
                overdue: const Text('Overdue Machine Count'),
                widgetOptions: [
                  _buildProgressBar(300), // Complete
                  _buildProgressBar(400), // InProgress
                  _buildProgressBar(500), // Overdue
                  _buildProgressBar(600), // Overdue
                ],
                onDropdownChanged: onDropdownChanged,
              ),
              const SizedBox(height: 74),
              const Headings(text: "Machine"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(int machineStatus) {
    if (_isLoading) {
      return const CircularProgressIndicator();
    }

    final data = _machineStatusData[machineStatus] ??
        {'acrpInspectionStatusCount': 0, 'acrpAssetIdCount': 0};

    final statusCount = data['acrpInspectionStatusCount'] as int;
    final assetIdCount = data['acrpAssetIdCount'] as int;

    return CustomPaint(
      foregroundPainter: CircularProgressBar(
        acrpAssetIdCount: assetIdCount,
        acrpInspectionStatusCount: statusCount,
      ),
      child: Column(
        children: [
          const SizedBox(height: defaultPadding / 2),
          Center(
            child: Text(
              '$statusCount/$assetIdCount',
              style: const TextStyle(fontSize: 30),
            ),
          ),
        ],
      ),
    );
  }
}



// class ProgressBar extends StatelessWidget {
//   const ProgressBar({
//     super.key,
//     required this.themeState,
//   });

//   final ThemeProvider themeState;

//   @override
//   Widget build(BuildContext context) {
//     return Card(elevation: 5,
//     shadowColor: Colors.black,
//       child: Container(
//         decoration: BoxDecoration(
           
//           color: themeState.isDarkTheme
//               ? const Color(0xFF424242)
//               : Colors.white,
//           borderRadius: const BorderRadius.all(Radius.circular(5)),
//         ),
//         height: 248,
    
//         child:const SizedBox(width: double.infinity,
//           child:  Column(children: [
//             DropdownMenuCircular(
//               option: Text('Option Widget'),
//               inProgress: Text('In Progress Widget'),
//               complete: Text('Complete Widget'),
//               overdue: Text('Overdue Widget'),
//               widgetOptions: [
//                 CompleteProgressBar(),
//                 Text('Overdue Widget'),
//                 CompleteProgressBar(),
//                 Text('Overdue Widget'),
        
//               ],
    
//             ),SizedBox(height: 74),
//             Headings(text: "Machine",)
          
//           ]),
//         ), // Include DropdownMenuExample widget here
//       ),
//     );
//   }
// }


// class CompleteProgressBar extends StatefulWidget {
//   const CompleteProgressBar({
//     super.key,
//   });

//   @override
//   State<CompleteProgressBar> createState() => _CompleteProgressBarState();
// }

// class _CompleteProgressBarState extends State<CompleteProgressBar>
//     with SingleTickerProviderStateMixin {

//       GetmachineCountService getmachineCountService=  GetmachineCountService();
//   @override
//   void initState() {
//     super.initState();
//     getmachineCount();
//   }

//   void getmachineCount(){
//     getmachineCountService.getMachineCount(context: context, machineStatus: 3);
//   }
  

//   @override
//   Widget build(BuildContext context) {
//     final machinecount= Provider.of<GetMachineCountProvider>(context,listen:false).user;
//     var  acrpAssetIdCount =machinecount?.acrpAssetIdCount ??0;
//     var  acrpInspectionStatusCount=machinecount?.acrpInspectionStatusCount ?? 0;
//     return CustomPaint(
//         foregroundPainter: CircularProgressBar( 
//   acrpAssetIdCount:acrpAssetIdCount,acrpInspectionStatusCount: acrpInspectionStatusCount,),
//         child:  Column(
//           children: [const SizedBox(height: defaultPadding/2,),
//             Center(
//                 child: Text(
//               '$acrpInspectionStatusCount/$acrpAssetIdCount',
//               style: const TextStyle(fontSize: 30),
//             )),
//           ],
//         ));
//   }
// }
