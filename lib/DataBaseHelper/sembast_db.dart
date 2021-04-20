// import 'dart:async';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sembast/sembast.dart';
// import 'package:sembast/sembast_io.dart';
// import 'DatabaseHelper.dart';

// class SembastDb {
//   DatabaseFactory dbFactory = databaseFactoryIo;
//   Database _db;

//   final store = intMapStoreFactory.store('passwords');
//  // static SembastDb _singleton = SembastDb._internal();

//   //SembastDb._internal() {}

//   factory SembastDb() {
//     return _singleton;
//   }

//   Future<Database> init() async {
//     // ignore: unnecessary_null_comparison
//     if (_db == null) {
//       _db = await _openDb();
//     }
//     return _db;
//   }

//   Future _openDb() async {
//     final docsDir = await getApplicationDocumentsDirectory();
//     final dbPath = join(docsDir.path, 'pass.db');
//     final db = await dbFactory.openDatabase(dbPath);
//     return db;
//   }

//   Future<int> addUser(UserInfoDb userInfoDb) async {
//     int id = await store.add(_db, userInfoDb.toMap());
//     return id;
//   }

//   Future getData() async {
//     final finder = Finder(sortOrders: [SortOrder('name')]);
//     final snapshot = await store.find(_db, finder: finder);
//     return snapshot.map((item) {
//       final pwd = UserInfoDb.fromMap(item.value);
//       pwd.userId = item.key.toString();
//     });
//   }
// }
