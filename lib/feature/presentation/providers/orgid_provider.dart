import 'package:flutter/material.dart';

class OrgIdProvider extends ChangeNotifier{

  int ? _orgid;

  int ? get orgid=>_orgid;

  void setOrgid(int org){
    _orgid=org;
    
    notifyListeners();
  }
}