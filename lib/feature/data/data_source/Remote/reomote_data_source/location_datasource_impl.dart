
import 'package:http/http.dart';
import 'package:suja_shoie_app/feature/data/core/api_constant.dart';
import 'package:suja_shoie_app/feature/data/model/location_model.dart';
import 'package:suja_shoie_app/feature/data/model/request_data_model.dart';

abstract class LocationDatasource{

  Future<ListOfLocationModel> getLocation(String token,int personid);

}


class LocationDatasourceImpl  implements LocationDatasource {
  @override
  Future<ListOfLocationModel> getLocation(String token, int personid)async {
     final headers = {
      'Content-Type': 'application/json',
    };


final request=ApiRequestDataModel(apiFor: "list_of_location",clientAuthToken: token,logpersonid:personid,orgid: 0);

final response = await ApiConstant().makeApiRequest(url: ApiConstant.baseUrl, headers: headers, requestBody: request);

final result= ListOfLocationModel.fromJson(response);

return result;
   
  }



}