import 'package:drift/drift.dart';

@DataClassName('UserProfileEntity')
class UserProfiles extends Table {
  
  IntColumn get id => integer().withDefault(const Constant(1))();
  
  TextColumn get serverId => text().named('server_id')();
  TextColumn get firstName => text().named('first_name')();
  TextColumn get email => text().named('email')();
  TextColumn get pictureUrl => text().named('picture_url').nullable()();
  TextColumn get lang => text().named('lang')();

  TextColumn get plan => text().named('plan').nullable()();
  DateTimeColumn get planExpiresAt => dateTime().named('plan_expires_at').nullable()();
  BoolColumn get autoRenew => boolean().named('auto_renew').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}