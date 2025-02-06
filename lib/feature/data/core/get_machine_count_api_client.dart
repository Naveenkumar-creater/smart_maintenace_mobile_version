import 'package:suja_shoie_app/feature/data/core/api_constant.dart';
import 'package:suja_shoie_app/feature/data/model/request_data_model.dart';

class GetMachineCountClient {
  dynamic getmachinecount(
    int machineStatus,
    String todate,
    String token,
    int orgId
  ) async {
 ApiRequestDataModel requestData = ApiRequestDataModel(
      clientAuthToken: token,
      apiFor: "machine_count",
      machineStaus: machineStatus,
      fromDateTime: ApiConstant.fromDate,
      toDateTime: todate,
      orgid: orgId
    );
    final apiConstant = ApiConstant();

    final headers = {"content-Type": "application/json"};

    return await apiConstant.makeApiRequest(
        url: ApiConstant.baseUrl, headers: headers, requestBody: requestData);
  }
}
