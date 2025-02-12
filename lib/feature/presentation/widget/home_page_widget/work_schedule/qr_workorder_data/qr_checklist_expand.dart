import 'package:flutter/cupertino.dart';
import 'package:suja_shoie_app/feature/presentation/widget/home_page_widget/work_schedule/qr_workorder_data/qr_checklist_status_card.dart';

import '../../../../../../constant/utils/theme_styles.dart';
import '../assetlist_workschedule/asset_staus_color.dart';


// Pass the instance of your AssetStatusColor
class QrChecklistWidget extends StatelessWidget {
  final List checklist; // Replace with your data model
  final String title; // The dynamic title you want to show

  const QrChecklistWidget({super.key, 
    required this.checklist,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    AssetStatusColor assetStatusColor = AssetStatusColor();
        final size= MediaQuery.of(context).size.width<600;

    return Expanded(
      child: Column(
        children: [
size ?   Padding(
       padding: const EdgeInsets.only(left:25,top: 15,bottom:15),
       child: Container(
         alignment: Alignment.centerLeft,
         
         child:  Text(
                    title,
                style:  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
         ),
     ):

          Padding(
            padding: const EdgeInsets.only(left: defaultPadding / 2,bottom: 30),
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: checklist.length,
              itemBuilder: (context, index) {
                final asset = checklist[index];
                final statusText = assetStatusColor.getStatusText(asset.checkliststatus, asset.inspectiondate);
                final statusColor = assetStatusColor.getStatusColor(asset.checkliststatus, asset.inspectiondate);

                return 
                
                
                 QrChecklistCard(
                  statusColor: statusColor,
                  checklistName: asset.checklistname,
                  statusText: statusText,
                  inspectionDate: asset.inspectiondate,
                  checklistStatus: asset.checkliststatus,
                  planId: asset.planid,
                  barcode: asset.assetbarcode, assetName: asset.assetname,
                  
               
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
