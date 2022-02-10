import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:redisgraph/redisgraph.dart';

Future<void> main() async {
  var redis = await RedisClient.init(
    app: RedisApp(
        url: 'redis-12448.c103.us-east-1-mz.ec2.cloud.redislabs.com',
        port: 12448,
        password: 'Syu5waPfDSQTSs6d9SAxYpV1ddElVZB0',
        db: 'osfy-pms'),
  );
  test('query builder', () async {
    final response = await redis.query.match("p:Person").return_("p").execute();
    print(response.get(["p"]));
  });
}
