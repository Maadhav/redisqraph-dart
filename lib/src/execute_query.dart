import 'dart:convert';
import 'package:redis/redis.dart';
import 'package:redisgraph/redisgraph.dart';
import 'package:redisgraph/src/graph_response.dart';
import 'package:redisgraph/src/query_builder.dart';

class Execute {
  static Future<GraphResponse> call(QueryBuilder query,
      {Map<String, dynamic>? params, required String initial}) async {
    final instance = RedisClient.instance;
    final Command command = instance.command;
    return await command.send_object([
      initial,
      instance.app.db,
      query.toString(),
    ]).then((value) {
      final res = List.from(value);
      return GraphResponse(
          returnedItems: List<String>.from(res[0]), data: res[1], metadata: res[2]);
    }).catchError((err) {
       if(instance.onRetry != null) {
         instance.onRetry!(err);
       }
      throw err;
    });
  }
}
