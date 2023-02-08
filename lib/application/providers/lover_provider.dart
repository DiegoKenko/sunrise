import 'package:sunrise/data/data_provider_lover.dart';
import 'package:sunrise/model/model_lover.dart';

class ProviderLover {
  Lover lover = Lover(name: '', age: 0);

  Future<void> setLover(Lover lover) async {
    this.lover = await DataProviderLover().get(lover.id);
  }
}
