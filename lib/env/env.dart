// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(defaultValue: 'no_key')
  static const String apikey = _Env.apikey;
}
