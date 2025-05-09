import '../model/request_data_model.dart';
import 'api_constant.dart';

class CheckListClient {
  dynamic getCheckList(int id, String toDate, String token, int orgId) async {
 ApiRequestDataModel requestData = ApiRequestDataModel(
      clientAuthToken: token,
      apiFor: "get_check_list",
      assetid: id,
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
