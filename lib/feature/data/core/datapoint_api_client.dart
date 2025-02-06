import '../model/request_data_model.dart';
import 'api_constant.dart';

class DataPointClient {
  dynamic getDataPoint(int acrdId, String token,int planId, int orgId) async {
    ApiRequestDataModel requestData = ApiRequestDataModel(
      clientAuthToken: token,
      apiFor: "get_check_list_datapoints",
       acrdId: acrdId,
      datapoinPlanid: planId,
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