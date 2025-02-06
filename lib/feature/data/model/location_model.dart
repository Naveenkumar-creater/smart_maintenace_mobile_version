import 'package:suja_shoie_app/feature/domain/entity/location_entity.dart';

class ListOfLocationModel extends ListOfLocationEntity {
    ListOfLocationModel({
        required this.listOfLocation,
    }):super(listOfLocation: listOfLocation);

    final List<ListOfLocation> listOfLocation;

    factory ListOfLocationModel.fromJson(Map<String, dynamic> json){ 
        return ListOfLocationModel(
            listOfLocation: json["response_data"]["List_Of_Location"] == null ? [] : List<ListOfLocation>.from(json["response_data"]["List_Of_Location"]!.map((x) => ListOfLocation.fromJson(x))),
        );
    }

}

class ListOfLocation  extends LocationEntity{
    ListOfLocation({
        required this.orgId,
        required this.locName,
        required this.locId,
        required this.orgName,
    }):super(locId: locId,locName:locName ,orgId:orgId,orgName: orgName);

    final int? orgId;
    final String? locName;
    final int? locId;
    final String? orgName;

    factory ListOfLocation.fromJson(Map<String, dynamic> json){ 
        return ListOfLocation(
            orgId: json["org_id"],
            locName: json["loc_name"],
            locId: json["loc_id"],
            orgName: json["org_name"],
        );
    
    }

}
