import 'dart:convert';

import '../../redisgraph.dart';

String convertCompare(String node, Comparison operator, Object? value) {
  if (!value.toString().contains(".")) value = jsonEncode(value);

  switch (operator) {
    case Comparison.lessThan:
      return " $node < $value";
    case Comparison.lessThanEqualTo:
      return " $node <= $value";
    case Comparison.inequality:
      return " $node <> $value";
    case Comparison.equality:
      return " $node = $value";
    case Comparison.greaterThan:
      return " $node > $value";
    case Comparison.greaterThanEqualTo:
      return " $node >= $value";
    case Comparison.contains:
      return " $node CONTAINS $value";
    case Comparison.notContains:
      return " NOT $node CONTAINS $value";
    case Comparison.endsWith:
      return " $node ENDS WITH $value";
    case Comparison.in_:
      return " $node IN $value";
    case Comparison.isNotNull:
      return " $node IS NOT NULL";
    case Comparison.isNull:
      return " $node IS NULL";
    case Comparison.not:
      return " NOT $node";
    case Comparison.startsWith:
      return " $node STARTS WITH $value";
    default:
      throw ArgumentError('Unknown operator: $operator');
  }
}
