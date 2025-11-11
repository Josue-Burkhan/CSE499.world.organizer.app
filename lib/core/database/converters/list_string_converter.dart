import 'dart:convert';
import 'package:drift/drift.dart';

class ListStringConverter extends TypeConverter<List<String>, String> {
  const ListStringConverter();

  @override
  List<String> fromSql(String fromDb) {
    if (fromDb.isEmpty) {
      return [];
    }
    final List<dynamic> decoded = json.decode(fromDb) as List<dynamic>;
    return decoded.map((item) => item.toString()).toList();
  }

  @override
  String toSql(List<String> value) {
    return json.encode(value);
  }
}