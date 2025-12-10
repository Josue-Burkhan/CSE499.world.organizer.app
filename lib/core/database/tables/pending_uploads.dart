import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'worlds.dart';

@DataClassName('PendingUploadEntity')
class PendingUploads extends Table {
  TextColumn get localId => text().clientDefault(() => Uuid().v4())();
  TextColumn get worldLocalId => text().references(Worlds, #localId, onDelete: KeyAction.cascade)();
  TextColumn get filePath => text()();
  TextColumn get storagePath => text()();
  
  @override
  Set<Column> get primaryKey => {localId};
}
