import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suja_shoie_app/constant/utils/show_snakbar.dart';
import 'package:suja_shoie_app/feature/data/data_source/Remote/reomote_data_source/location_datasource_impl.dart';
import 'package:suja_shoie_app/feature/data/repository/location_repository.dart';
import 'package:suja_shoie_app/feature/presentation/providers/location_provider.dart';
import '../../domain/usecase/location_usecase.dart';

class LocationService{
  Future<void> getLocation({
 required BuildContext context,
   required int personid
  })async {


    try {
      SharedPreferences pref= await SharedPreferences.getInstance();

      String token=pref.getString("client_token") ?? "";

    LocationUsecase locationUsecase=LocationUsecase(LocationRepositoryImpl(LocationDatasourceImpl()));

    final user= await locationUsecase.execute(token, personid);

    Provider.of<LocationProvider>(context,listen: false).setlocation(user);

    } catch (e) {
      ShowError.showAlert(context, e.toString());
    }
  }



}