import 'package:sunrise/data/data_provider_lover.dart';
import 'package:sunrise/model/model_lover.dart';

class ProviderLover {
  Lover lover = Lover(name: '');

  Future<void> setLover(Lover lover) async {
    if (lover.id.isEmpty) {
      this.lover = await DataProviderLover().create(lover);
    } else {
      this.lover = lover;
      DataProviderLover().update(lover);
    }
  }
}
