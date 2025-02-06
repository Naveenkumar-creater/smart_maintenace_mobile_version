
import '../entity/check_list_entity.dart';
import '../repository/checklist_repository.dart';

class CheckListUsecase {
  final CheckListRepository checkListRepository;

  CheckListUsecase(this.checkListRepository);

  Future<CheckListEntity> execute(
      int id, String toDate, String token,int orgId) async {
    return checkListRepository.getCheckList(id, toDate, token,orgId);
  }
}
