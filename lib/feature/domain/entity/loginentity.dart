import 'package:equatable/equatable.dart';

// ignore: camel_case_types
class loginEntity extends Equatable {
  final String? loginId;
  final String? password;

  final String? clientauthToken;
 final int?deptId;
 final int?orgId;
 final int?personid;

  const loginEntity({
    this.loginId,
    this.password,
    this.orgId,
    this.deptId,
    this.clientauthToken,
    this.personid
  });

  @override
  List<Object?> get props => [
        loginId,
        password,
     deptId,
        clientauthToken,
      ];
}
