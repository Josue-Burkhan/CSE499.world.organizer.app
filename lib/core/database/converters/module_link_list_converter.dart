import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../models/api_models/module_link.dart';

class ModuleLinkListConverter extends TypeConverter<List<ModuleLink>, String> {
  const ModuleLinkListConverter();

  @override
  List<ModuleLink> fromSql(String fromDb) {
    if (fromDb.isEmpty) {
      return [];
    }
    try {
      final List<dynamic> jsonList = jsonDecode(fromDb);
      return jsonList.map((j) => ModuleLink.fromJson(j)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  String toSql(List<ModuleLink> value) {
    return jsonEncode(value.map((e) => e.toJson()).toList());
  }
}
