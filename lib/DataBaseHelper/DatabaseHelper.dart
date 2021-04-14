import 'dart:io';

import 'package:optymoney/complete_profile/components/complete_profile_form.dart';
import 'package:optymoney/otp/components/otp_form.dart';
import 'package:optymoney/sign_in_screen/components/sign_in_form.dart';
import 'package:optymoney/sign_up_screen/components/sign_up_form.dart';
import 'package:sqlite3/sqlite3.dart';

void openDatabase() {
  print('Using sqlite3 ${sqlite3.version}');
  print(SignForm.email);

  // Create a new in-memory database. To use a database backed by a file, you
  // can replace this with sqlite3.open(yourFilePath).
  final db = sqlite3.openInMemory();

  // Create a table and insert some data
  db.execute('''
    CREATE TABLE users (
      id TEXT NOT NULL PRIMARY KEY,
      name TEXT NOT NULL,
      email TEXT NOT NULL
    );
  ''');

  // Prepare a statement to run it multiple times:
  final stmt =
      db.prepare('INSERT INTO users (id, name, email) VALUES (?, ?, ?)');
  stmt
    ..execute(
        [OtpForm.status, CompleteProfileForm.firstName, SignUpForm.email]);

  // Dispose a statement when you don't need it anymore to clean up resources.
  stmt.dispose();

  // You can run select statements with PreparedStatement.select, or directly
  // on the database:
  final ResultSet resultSet = db.select('SELECT * FROM users');

  // You can iterate on the result set in multiple ways to retrieve Row objects
  // one by one.
  resultSet.forEach((element) {
    print(element);
  });
  for (final Row row in resultSet) {
    print(
        'User[id: ${row['id']}, name: ${row['name']}, email: ${row['email']}]');
  }

  // Register a custom function we can invoke from sql:
  db.createFunction(
    functionName: 'dart_version',
    argumentCount: const AllowedArgumentCount(0),
    function: (args) => Platform.version,
  );
  print(db.select('SELECT dart_version()'));

  // Don't forget to dispose the database to avoid memory leaks
  db.dispose();
}
