import 'package:equatable/equatable.dart';

class ListOfLocationEntity extends Equatable {
    ListOfLocationEntity({
        required this.listOfLocation,
    });

    final List<LocationEntity> listOfLocation; 

    @override
    List<Object?> get props => [
    listOfLocation, ];
}

class LocationEntity extends Equatable {
    LocationEntity({
        required this.orgId,
        required this.locName,
        required this.locId,
        required this.orgName,
    });

    final int? orgId;
    final String? locName;
    final int? locId;
    final String? orgName;


    @override
    List<Object?> get props => [
    orgId, locName, locId, orgName, ];
}
