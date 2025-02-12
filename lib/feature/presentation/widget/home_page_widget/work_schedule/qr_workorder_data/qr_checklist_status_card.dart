import 'package:flutter/material.dart';

import '../../../../../../constant/utils/theme_styles.dart';
import '../../../../pages/captureimage.dart';
import '../../../../pages/cheklist_details_page.dart';
import '../assetlist_workschedule/asset_list_workschedule.dart';

class QrChecklistCard extends StatelessWidget {
  final Color statusColor;
  final String checklistName;
  final String statusText;
  final String inspectionDate;
  final int checklistStatus;
  final int planId;
  final String barcode;
  final String assetName;

  
  const QrChecklistCard({super.key,
  
    required this.statusColor,
    required this.checklistName,
    required this.statusText,
    required this.inspectionDate,
    required this.checklistStatus,
    required this.planId,
    required this.barcode,
    required this.assetName
 
  });

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    // Parse the inspection string into a DateTime object
    DateTime inspection = DateTime.parse(inspectionDate);

    // Extract the date part as a string in "yyyy-MM-dd" format
    String inspectionDateStr =
        "${inspection.year}-${inspection.month.toString().padLeft(2, '0')}-${inspection.day.toString().padLeft(2, '0')}";
    String nowDateStr =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

final size=MediaQuery.of(context).size.width <600 ;

    return 
    size ?
    
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  checklistStatus == 3 || checklistStatus == 4
                        ?  CheckPointDetails(planId:planId,acrpinspectionstatus: checklistStatus, assetname: assetName,)
                        : CaptureImage(context,planId,scannerPage,checklistStatus,0,assetName),
            ),
          );
        },
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              /// Left Status Indicator
              Container(
                width: 10,
                height: 90,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
              ),
              
              /// Checklist Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Checklist Name
                      Text(
                        checklistName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),

                      /// Status
                      Text(
                        "Status: $statusText",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: statusColor,
                        ),
                      ),
                      const SizedBox(height: 6),

                      /// Inspection Date
                      Text(
                        "Inspection Date: ${inspectionDate.substring(0, 10)}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// Right Arrow Icon
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Icon(
                  Icons.chevron_right,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    ) 
   
   
   : Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border(
            left: BorderSide(
              color: statusColor,
              width: 10,
            ),
            top: BorderSide(
              width: 2,
              color: statusColor,
            ),
            right: BorderSide(
              width: 2,
              color: statusColor,
            ),
            bottom: BorderSide(
              width: 2,
              color: statusColor,
            ),
          ),
        ),
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                checklistName,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                "Status: $statusText",
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                "Inspection date: ${inspectionDate.substring(0, 10)}",
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    checklistStatus == 3|| checklistStatus == 4
                        ?  CheckPointDetails(planId:planId,acrpinspectionstatus: checklistStatus, assetname: assetName,)
                        : CaptureImage(context,planId,scannerPage,checklistStatus,0,assetName)
              ),
            );
          },
        ),
      ),
    );
  }
}







