import 'package:yourjobs_app/ui/models/status.dart';

class AssetsModel {
  static List<StatusModel> generateCategories() {
    return [
      StatusModel(
        "0",
        "Todos",
      ),
      StatusModel(
        "1",
        "Pendiente",
      ),
      StatusModel(
        "2",
        "En proceso",
      ),
      StatusModel(
        "3",
        "Completado",
      ),
    ];
  }
}
