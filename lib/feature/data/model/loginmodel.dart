import 'package:suja_shoie_app/feature/domain/entity/loginentity.dart'; // Import your login entity class

class LoginModel extends loginEntity {
  const LoginModel({
    String? loginId,
    String? password,
    int?deptId,
     int?orgId,
    String? clientauthToken,
    int ? personid

  }) : super(
          loginId: loginId,
          password: password,
          deptId: deptId,
          orgId:orgId,
          personid: personid,
          clientauthToken: clientauthToken,
        );

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    final userLogin = json['response_data']['user_login'];

    return LoginModel(
      loginId: userLogin['login_id'],
      password: userLogin['login_password'],
      clientauthToken: userLogin['client_aut_token'],
      deptId:userLogin['dept_id'],
      orgId:userLogin['org_id'],
     personid: userLogin ["person_id"]
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'login_id': loginId,
  //     'login_password': password,
  //     'person_fname': personFname,
  //     'dept_name': deptName,
  //     'org_name': orgName,
  //     'client_aut_token': clientauthToken
    
  //   };
  // }
}
