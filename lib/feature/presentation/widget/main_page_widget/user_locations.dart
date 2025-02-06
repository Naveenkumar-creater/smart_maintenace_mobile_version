import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suja_shoie_app/feature/presentation/mobile_page/mobile_home_page.dart';
import 'package:suja_shoie_app/feature/presentation/pages/main_page.dart';
import 'package:suja_shoie_app/feature/presentation/providers/location_provider.dart';
import 'package:suja_shoie_app/feature/presentation/providers/loginprovider.dart';
import 'package:suja_shoie_app/feature/presentation/providers/orgid_provider.dart';

import '../../api_services/location_service.dart';

class UserLocationDetails extends StatefulWidget {
  const UserLocationDetails({super.key});

  @override
  State<UserLocationDetails> createState() => _UserLocationDetailsState();
}

class _UserLocationDetailsState extends State<UserLocationDetails> {
  final LocationService locationService = LocationService();
  String? dropdownValue;

  @override
  void initState() {
    super.initState();
    final locationPersonId = Provider.of<LoginProvider>(context, listen: false).user?.personid;
    locationService.getLocation(context: context, personid: locationPersonId ?? 0);

    // Set the first location name as the initial dropdown value
    Future.delayed(Duration.zero, () {
      final locationDetails = Provider.of<LocationProvider>(context, listen: false).location?.listOfLocation;
      if (locationDetails != null && locationDetails.isNotEmpty) {
        setState(() {
          dropdownValue = locationDetails.first.locName;  // Set the first location as initial value
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationDetails = Provider.of<LocationProvider>(context, listen: false).location?.listOfLocation;
final size=MediaQuery.of(context).size.width < 600;
    return Container(
      width: 200,
      height: 50,
      child: DropdownButtonFormField<String>(
        value: dropdownValue,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.all(8),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black, width: 1),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
          ),
        ),
        isExpanded: true,
        onChanged: (String? value) {

       final selectlocation=locationDetails?.firstWhere((location){
        return location.locName==value;
       },);
         int orgid=selectlocation?.orgId ?? 0;
         print(orgid);
          setState(() {
            dropdownValue = value;
            Provider.of<OrgIdProvider>(context,listen: false).setOrgid(orgid);
          });

 
          if (value != null) {

size?            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MobileHomePage()), // Replace with your target page
            ) :

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainPage()), // Replace with your target page
            );
          }
        },
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
        items: locationDetails?.map((location) {
          return DropdownMenuItem<String>(
            value: location.locName,

            child: Text(location.locName ?? "", style: const TextStyle(color: Colors.black)),
          );
        }).toList(),
      ),
    );
  }
}
