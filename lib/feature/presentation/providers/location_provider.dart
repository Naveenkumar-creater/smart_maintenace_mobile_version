// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/src/material/dropdown.dart';
import 'package:suja_shoie_app/feature/domain/entity/location_entity.dart';


class LocationProvider extends ChangeNotifier{

    ListOfLocationEntity ? _location;

    ListOfLocationEntity ? get location=>_location;

    void setlocation(ListOfLocationEntity ? data){
      _location=data;
      notifyListeners();
    }

  map(DropdownMenuItem<String> Function(String selectvalue) param0) {}
   
}