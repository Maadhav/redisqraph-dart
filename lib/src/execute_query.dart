import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:redis/redis.dart';
import 'package:redisgraph/redisgraph.dart';
import 'package:redisgraph/src/graph_response.dart';
import 'package:redisgraph/src/query_builder.dart';

class Execute {
  static Future<GraphResponse> call(QueryBuilder query,
      {Map<String, dynamic>? params, required String initial}) async {
    final instance = RedisClient.instance;
    final Command command = instance.command;
    if (kDebugMode) {
      log(buildParamsHeader(params) + query.toString());
    }
    return await command.send_object([
      initial,
      instance.app.db,
      buildParamsHeader(params) + query.toString(),
    ]).then((value) {
      final res = List.from(value);
      return GraphResponse(
          returnedItems: List<String>.from(res[0]),
          data: res.length>1? [] :res[1],
          metadata: res.length>2? []:res[2],);
    }).catchError((err) {
      if (instance.onRetry != null) {
        instance.onRetry!(err);
      }
      throw err;
    });
  }

  static String buildParamsHeader(Map<String, dynamic>? params) {
    if (params == null) {
      return '';
    }
    String paramsHeader = "CYPHER ";
    for (var key in params.keys) {
      if (params[key] is String) {
        params[key] = _quotify(params[key]);
      } else if (params[key] == null) {
        params[key] = "null";
      }
      paramsHeader += "$key = ${params[key]} ";
    }
    return paramsHeader;
  }

  static String _quotify(String v) {
    if (v is String) {
      if (v.isEmpty) {
        return '""';
      }
      if (v[0] != '"') {
        v = '"' + v;
      }
      if (v[v.length - 1] != '"') {
        v = v + '"';
      }
      return v;
    }
    return v;
  }
}
