import 'package:flutter/foundation.dart';

class GraphResponse {
  final List<String> returnedItems;
  final List data;
  final List metadata;
  GraphResponse({
    required this.returnedItems,
    required this.data,
    required this.metadata,
  });

  factory GraphResponse.fromMap(Map<String, dynamic> map) {
    return GraphResponse(
      returnedItems: List<String>.from(map['returnedItems']),
      data: List.from(map['data']),
      metadata: List.from(map['metadata']),
    );
  }

  List<dynamic> get(List<String> toGet) {
    var output = data
        .map((e) => e
            .map((g) => g is List ? {for (var v in g) v[0]: v[1]} : g)
            .toList())
        .toList();
    var _outs = [];
    for (var e in toGet) {
      final index = returnedItems.indexOf(e);
      _outs.add(output.map((e) => _format(e[index])).toList());
    }
    output = _outs;
    return output;
  }

  dynamic _format(dynamic item) {
    if (item is Map) {
      item['properties'] = {for (var v in item['properties']) v[0]: v[1]};
      if (item.length == 3) {
        return Node.fromMap(Map<String, dynamic>.from(item));
      } else if (item.length == 5) {
        return Relation.fromMap(Map<String, dynamic>.from(item));
      }
    }
    return item;
  }

  @override
  String toString() =>
      'GraphResponse(returnedItems: $returnedItems, data: $data, metadata: $metadata)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GraphResponse &&
        listEquals(other.returnedItems, returnedItems) &&
        listEquals(other.data, data) &&
        listEquals(other.metadata, metadata);
  }

  @override
  int get hashCode =>
      returnedItems.hashCode ^ data.hashCode ^ metadata.hashCode;
}

class Node {
  final int id;
  final List<String> labels;
  final Map<String, dynamic> properties;
  Node({
    required this.id,
    required this.labels,
    required this.properties,
  });

  factory Node.fromMap(Map<String, dynamic> map) {
    return Node(
      id: map['id']?.toInt() ?? 0,
      labels: List<String>.from(map['labels']),
      properties: Map<String, dynamic>.from(map['properties']),
    );
  }

  @override
  String toString() =>
      'Node(id: $id, labels: $labels, properties: $properties)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Node &&
        other.id == id &&
        listEquals(other.labels, labels) &&
        mapEquals(other.properties, properties);
  }

  @override
  int get hashCode => id.hashCode ^ labels.hashCode ^ properties.hashCode;
}

class Relation {
  final int id;
  final String type;
  final int srcNode;
  final int destNode;
  final Map<String, dynamic> properties;
  Relation({
    required this.id,
    required this.type,
    required this.srcNode,
    required this.destNode,
    required this.properties,
  });

  factory Relation.fromMap(Map<String, dynamic> map) {
    return Relation(
      id: map['id']?.toInt() ?? 0,
      type: map['type'] ?? '',
      srcNode: map['srcNode']?.toInt() ?? 0,
      destNode: map['destNode']?.toInt() ?? 0,
      properties: Map<String, dynamic>.from(map['properties']),
    );
  }

  @override
  String toString() {
    return 'Relation(id: $id, type: $type, srcNode: $srcNode, destNode: $destNode, properties: $properties)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Relation &&
        other.id == id &&
        other.type == type &&
        other.srcNode == srcNode &&
        other.destNode == destNode &&
        mapEquals(other.properties, properties);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        type.hashCode ^
        srcNode.hashCode ^
        destNode.hashCode ^
        properties.hashCode;
  }
}
