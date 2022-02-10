class QueryBuilder extends StringBuffer {
  QueryBuilder([String query = '']);

  void addClause([Object object = '']) {
    write('$object ');
  }
}
