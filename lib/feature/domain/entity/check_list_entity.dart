import 'package:equatable/equatable.dart';

class CheckListEntity extends Equatable {
  final int? responseCode;
  final CheckListData responseData;
  final int wsReqId;
  final String responseMsg;

  const CheckListEntity({
    required this.responseCode,
    required this.responseData,
    required this.wsReqId,
    required this.responseMsg,
  });

  @override
  List<Object?> get props => [responseCode, responseData, wsReqId, responseMsg];
}

class CheckListData {
  final List<CheckListDataEntity> checklist;

  CheckListData({required this.checklist});

  factory CheckListData.empty() {
    return CheckListData(checklist: []);  // Representing an empty list
  }

  factory CheckListData.fromJson(Map<String, dynamic> json) {
    final checkListJson = json['check_list']; // Updated key name

    if (checkListJson == null) {
      return CheckListData.empty();  // Return empty instance
    }

    final checkListData = (checkListJson as List)
        .map((item) => CheckListDataEntity.fromJson(item))
        .toList();

    return CheckListData(
      checklist: checkListData,
    );
  }
}



class CheckListDataEntity {
  final String checklistname;
  final String maintenancetypename;
  final String assetname;
  final int registerid;
  final int checkliststatus;
  final String assetbarcode;
  final int checklistfrequency;
  final String inspectiondate;
  final int planid;
  // ignore: prefer_typing_uninitialized_variables
  final int acrpassetId;
  //  final int acrpinspectionstatus;

  // final String acpinspectionDate;
  CheckListDataEntity(
      {required this.checklistname,
      required this.maintenancetypename,
      required this.assetname,
      required this.registerid,
      required this.checkliststatus,
      required this.assetbarcode,
      required this.checklistfrequency,
      required this.inspectiondate,
      required this.planid,
      required this .acrpassetId,
      // required this.acpinspectionDate
      // required this.acrpinspectionstatus,
      });

  factory CheckListDataEntity.fromJson(Map<String, dynamic> json) {
    return CheckListDataEntity(
      checklistname: json['check_list_name'],

      maintenancetypename: json['maintenance_type_name']
      ,
      assetbarcode: json['asset_bar_code'],

      assetname: json['asset_name'],

      registerid: json['registerid'],

      checkliststatus: json['acrp_inspection_status'],
      checklistfrequency: json['checklist_frequency'],

      inspectiondate: json['acrp_inspection_date'],
      planid: json['plan_id'],
     acrpassetId :json['acrp_asset_id'],
    //  acpinspectionDate:json['acrp_actual_inspection_to_time']
      // acrpinspectionstatus:json['acrp_inspection_status'],
    );
  }
}

    //  {
    //             "acrp_asset_id": 207,
    //             "check_list_name": "AVCMM daily maintenance check sheet",
    //             "asset_bar_code": "100207",
    //             "maintenance_type_name": "Daily Verification",
    //             "asset_name": "AVCMM 54",
    //             "registerid": 11,
    //             "checklist_frequency": 1,
    //             "acrp_inspection_date": "2024-02-29",
    //             "acrp_inspection_status": 1,
    //             "plan_id": 389,
    //             "acrp_actual_inspection_to_time": "2024-02-29 00:00:00"
    //         }



    //    {
    //             "acrp_asset_id": 205,
    //             "check_list_name": "AVCMM daily maintenance check sheet",
    //             "asset_bar_code": "100205",
    //             "maintenance_type_name": "Daily Verification",
    //             "asset_name": "AVCMM 52",
    //             "registerid": 9,
    //             "checklist_frequency": 1,
    //             "inspection_date": "2024-02-28 00:00:00.0",
    //             "acrp_inspection_status": 1,
    //             "checklist_status": 1,
    //             "plan_id": 320
    //         },



    //  "acrp_asset_id": 207,
    //             "check_list_name": "AVCMM daily maintenance check sheet",
    //             "asset_bar_code": "100207",
    //             "maintenance_type_name": "Daily Verification",
    //             "asset_name": "AVCMM 54",
    //             "registerid": 11,
    //             "checklist_frequency": 1,
    //             "acrp_inspection_date": "2024-02-29",
    //             "acrp_inspection_status": 1,
    //             "plan_id": 389,
    //             "acrp_actual_inspection_to_time": "2024-02-29 00:00:00"