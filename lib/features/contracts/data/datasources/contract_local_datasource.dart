import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class ContractLocalDataSource {
  Future<void> saveSignatureStatus(String unitId, String contractType, bool status);
  Future<bool> getSignatureStatus(String unitId, String contractType);
  Future<int> getCustomerId();

  /// Persists the finishing order IDs for a given apartment so they survive
  /// app restarts and can be used in the contract-resume flow.
  Future<void> saveFinishingOrderIds(int apartmentId, List<int> ids);

  /// Returns the cached finishing order IDs for the apartment, or an empty
  /// list if none have been saved yet.
  Future<List<int>> getFinishingOrderIds(int apartmentId);
}

class ContractLocalDataSourceImpl implements ContractLocalDataSource {
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secureStorage;

  ContractLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.secureStorage,
  });

  static String _finishingIdsKey(int apartmentId) =>
      'finishing_order_ids_apt_$apartmentId';

  @override
  Future<void> saveSignatureStatus(String unitId, String contractType, bool status) async {
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

  @override
  Future<void> saveFinishingOrderIds(int apartmentId, List<int> ids) async {
    final encoded = ids.map((id) => id.toString()).join(',');
    await sharedPreferences.setString(_finishingIdsKey(apartmentId), encoded);
  }

  @override
  Future<List<int>> getFinishingOrderIds(int apartmentId) async {
    final raw = sharedPreferences.getString(_finishingIdsKey(apartmentId)) ?? '';
    if (raw.isEmpty) return [];
    return raw
        .split(',')
        .map((s) => int.tryParse(s.trim()))
        .whereType<int>()
        .toList();
  }
}
