import 'package:path/path.dart';
import 'package:bluetooth_messenger/constants.dart';
import 'package:sqflite/sqflite.dart';

class ChatDatabase {
  static final ChatDatabase instance = ChatDatabase._init();

  static Database? _database;

  ChatDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('chats.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    print(path);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    final numberType = 'INTEGER NOT NULL';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';

    final reciepientType = 'INETGER NOT NULL';

    await db.execute('''
    CREATE TABLE $persons (
      ${PersonFields.id} $idType,
      ${PersonFields.number} $numberType,
      ${PersonFields.username} $textType,
      ${PersonFields.displayPicture} $textType,
      ${PersonFields.lastMessage} $textType
    )
    ''');

    await db.execute('''
    CREATE TABLE $messages (
      ${MessageFields.id} $idType,
      ${MessageFields.receipient} $reciepientType,
      ${MessageFields.content} $textType,
      ${MessageFields.time} $textType,
      ${MessageFields.isSender} $boolType,
      FOREIGN KEY(${MessageFields.receipient}) REFERENCES $persons(${PersonFields.id})
    )
    ''');
  }

  Future<Person> createPerson(Person person) async {
    final db = await instance.database;

    final id = await db.insert(persons, person.toJson());

    return person.copy(id: id);
  }

  Future<ChatMessage> postMessage(ChatMessage message) async {
    final db = await instance.database;

    final id = await db.insert(messages, message.toJson());
    db.update(
      persons,
      {
        PersonFields.lastMessage: message.content,
      },
      where: '${PersonFields.id} = ?',
      whereArgs: [message.receipient],
    );

    return message.copy(id: id);
  }

  Future<Person?> readPerson(int number) async {
    final db = await instance.database;

    final maps = await db.query(
      persons,
      columns: PersonFields.values,
      where: '${PersonFields.number} = ?',
      whereArgs: [number],
    );

    if (maps.isNotEmpty) {
      return Person.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<ChatMessage>> readMessages(int? receipient) async {
    final db = await instance.database;

    final result = await db.query(
      messages,
      where: '${MessageFields.receipient} = ?',
      whereArgs: [receipient],
    );

    return result.map((json) => ChatMessage.fromJson(json)).toList();
  }

  Future<List<Person>> readAllPersons() async {
    final db = await instance.database;

    final result = await db.query(persons);

    return result.map((json) => Person.fromJson(json)).toList();
  }

  /**Future<Map<String, Object?>> getLastMessage(int? receipient) async {
    final db = await instance.database;

    final lastMessage = await db.rawQuery(
        'SELECT ${MessageFields.content} FROM $messages WHERE ${MessageFields.receipient} = $receipient ORDER BY ${MessageFields.id} DESC LIMIT 1');

    print(lastMessage.first[MessageFields.content]);
    return lastMessage.first;
  }**/

  Future<int> removePerson(int id) async {
    final db = await instance.database;

    deleteAllMessages(id);

    return await db.delete(
      persons,
      where: '${PersonFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteMessage(int id) async {
    final db = await instance.database;

    return await db.delete(
      messages,
      where: '${MessageFields.id} = ?',
      whereArgs: [id],
    );
  }

  void deleteAllMessages(int receipient) async {
    final db = await instance.database;
    db.delete(
      messages,
      where: '${MessageFields.receipient} = ?',
      whereArgs: [receipient],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
