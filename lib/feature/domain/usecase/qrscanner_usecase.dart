
import 'package:suja_shoie_app/feature/domain/repository/qrscanner_repository.dart';

import '../entity/check_list_entity.dart';

class QrScannerUsecase {
  final QrScannerRepository qrScannerRepository;

  QrScannerUsecase(this.qrScannerRepository);

  Future<CheckListEntity> execute(
      String barcode, String token, int orgId) async {
    return qrScannerRepository.getCheckList(barcode, token,orgId);
  }
}