import 'package:suja_shoie_app/feature/domain/entity/location_entity.dart';
import 'package:suja_shoie_app/feature/domain/repository/location_repository.dart';

class LocationUsecase{
  final LocationRepository locationRepository;

LocationUsecase(
  this.locationRepository
);
  Future<ListOfLocationEntity> execute (String token, int personid){
   return  locationRepository.getlocation(token, personid);
  }
}