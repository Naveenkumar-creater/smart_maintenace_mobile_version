import 'package:suja_shoie_app/feature/domain/entity/location_entity.dart';

abstract class LocationRepository{
  Future<ListOfLocationEntity> getlocation(String token, int personid);
}