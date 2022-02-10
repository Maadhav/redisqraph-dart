import 'dart:async';

import 'package:redis/redis.dart';
import 'package:redisgraph/src/query.dart';
import 'redis_app.dart';

typedef RetryCallback = FutureOr<void> Function(Exception);

class RedisClient {
  late RedisApp app;
  late Command command;
  RetryCallback? onRetry;
  RedisClient._();

  static final conn = RedisConnection();
  static final RedisClient _instance = RedisClient._();

  static RedisClient get instance => _instance;

  static Future<RedisClient> init({required RedisApp app, RetryCallback? onRetry}) async {
    _instance.app = app;
    _instance.onRetry = onRetry;
    await conn.connect(app.url, app.port).then((Command command) {
      command.send_object(["AUTH", app.password]);
      _instance.command = command;
    });
    return _instance;
  }

  Query get query => Query();
}
