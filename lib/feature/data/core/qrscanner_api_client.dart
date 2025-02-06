
import 'package:intl/intl.dart';

import '../model/request_data_model.dart';
import 'api_constant.dart';

class QrScannerClient {
  dynamic getCheckList(String barcode, String token,int orgId) async {
       DateTime now = DateTime.now();
      String toDate = DateFormat('yyyy-MM-dd').format(now);
    ApiRequestDataModel requestData = ApiRequestDataModel(
      clientAuthToken: token,
      apiFor: "asset_tag_barcode_scan",
      assetbarcode: barcode,
      fromDateTime:toDate, 
      toDateTime: toDate,
      orgid: orgId
      
    );

    final apiConstant = ApiConstant();
    final headers = {
      'Content-Type': 'application/json',
    };

    return await apiConstant.makeApiRequest(
      url: ApiConstant.baseUrl,
      headers: headers,
      requestBody: requestData,
    );
  }
}
