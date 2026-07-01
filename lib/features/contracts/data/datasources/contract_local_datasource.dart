import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class ContractLocalDataSource {
  Future<void> saveSignatureStatus(String unitId, String contractType, bool status);
  Future<bool> getSignatureStatus(String unitId, String contractType);
  Future<int> getCustomerId();
}

class ContractLocalDataSourceImpl implements ContractLocalDataSource {
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secureStorage;

  ContractLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.secureStorage,
  });

  @override
  Future<void> saveSignatureStatus(String unitId, String contractType, bool status) async {
    // contractType can be 'unit' or 'finishing'
    await sharedPreferences.setBool('${contractType}_contract_signed_$unitId', status);
  }

  @override
  Future<bool> getSignatureStatus(String unitId, String contractType) async {
    return sharedPreferences.getBool('${contractType}_contract_signed_$unitId') ?? false;
  }

  @override
  Future<int> getCustomerId() async {
    final customerIdStr = await secureStorage.read(key: 'user_id');
    return int.tryParse(customerIdStr ?? '1') ?? 1;
  }
}
