import 'package:suja_shoie_app/feature/data/data_source/Remote/reomote_data_source/location_datasource_impl.dart';
import 'package:suja_shoie_app/feature/data/model/location_model.dart';
import '../../domain/repository/location_repository.dart';

class LocationRepositoryImpl extends LocationRepository{
  final LocationDatasource locationDatasource;
  LocationRepositoryImpl(this.locationDatasource);

  @override
  Future<ListOfLocationModel> getlocation(String token, int personid) {

 final result=locationDatasource.getLocation(token, personid);

 return result;

  }

}