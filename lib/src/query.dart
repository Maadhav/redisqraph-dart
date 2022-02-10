import 'package:redisgraph/redisgraph.dart';
import 'package:redisgraph/src/query_builder.dart';

import 'enums/comparision.dart';
import 'execute_query.dart';
import 'utils/comparision_convertor.dart';

class Query {
  var _query = QueryBuilder();

  Query();
  Query._append(String clause, QueryBuilder query) {
    _query = query;
    _query.addClause(clause);
  }

  Query match(String node, {bool optional = true}) =>
      Query._append("${optional ? "OPTIONAL " : ''} MATCH ($node)", _query);
  Query create(String node) => Query._append("CREATE ($node)", _query);
  Query cypher(String clause) => Query._append(clause, _query);
  Query return_(String clause, {bool distinct = false}) =>
      Query._append("RETURN ${distinct ? "DISTINCT" : ""} $clause", _query);
  Query delete(String node) => Query._append("DELETE $node", _query);
  Query detachDelete(String node) =>
      Query._append("DETACH DELETE $node", _query);
  Query detach(String node) => Query._append("DETACH $node", _query);
  Query remove(String node) => Query._append("SET $node = NULL", _query);
  Query yield_(String node) => Query._append("YIELD $node", _query);
  Query with_(String node) => Query._append("WITH $node", _query);
  Query set(String node, [Object? value]) =>
      Query._append("SET $node = ${value ?? 'null'}", _query);
  Query where(String node, Comparison operator, [Object? value]) =>
      Query._append("WHERE${convertCompare(node, operator, value)}", _query);
  Query and(String node, Comparison operator, [Object? value]) =>
      Query._append("AND${convertCompare(node, operator, value)}", _query);
  Query or(String node, Comparison operator, [Object? value]) =>
      Query._append("OR${convertCompare(node, operator, value)}", _query);
  Query limit(int limit) => Query._append("LIMIT $limit", _query);
  Query skip(int skip) => Query._append("SKIP $skip", _query);
  Query orderBy(String node, {bool ascending = true}) => _query
          .toString()
          .contains("ORDER BY")
      ? Query._append(", $node ${ascending ? 'ASC' : 'DESC'}", _query)
      : Query._append("ORDER BY $node ${ascending ? 'ASC' : 'DESC'}", _query);
  Query fullTextSearch(String index, String query) => Query._append(
      'CALL db.index.fulltext.queryNodes("$index", "$query")', _query);
  Future<GraphResponse> execute(
      {Map<String, dynamic>? params, String inital = "GRAPH.QUERY"}) async {
    return await Execute.call(_query, params: params, initial: inital);
  }
} 
