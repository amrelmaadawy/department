import 'package:get_it/get_it.dart';

import 'modules/auth_di.dart';
import 'modules/core_di.dart';
import 'modules/profile_di.dart';
import 'modules/projects_di.dart';
import 'modules/contracts_di.dart';
import 'modules/packages_di.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await registerCoreDi(sl);
  await registerAuthDi(sl);
  await registerProjectsDi(sl);
  await registerProfileDi(sl);
  await initContractsModule();
  await registerPackagesDi(sl);
}
