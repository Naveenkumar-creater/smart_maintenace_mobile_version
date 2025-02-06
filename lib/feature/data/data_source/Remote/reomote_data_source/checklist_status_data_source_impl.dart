import 'package:suja_shoie_app/feature/data/core/checklist_status_api_client.dart';
import 'package:suja_shoie_app/feature/data/data_source/Remote/remote_abstract/checklist_status_data_source.dart';
import 'package:suja_shoie_app/feature/data/model/checklist_status_model.dart';

class CheckListDataSourceimpl extends CheckListStatusDataSource {
  final CheckListStatusClient checkListStatusClient;

  CheckListDataSourceimpl(this.checkListStatusClient);

  @override
  Future<ChecklistStatusModel> getChecklistStatusCount(
      int count, String toDate, String token,int orgId) async {
    final response =
        await checkListStatusClient.getStatusCount(count, toDate, token,orgId);

    final result = ChecklistStatusModel.fromJson(response);
    print(result);

    return result;
  }
}
