import 'dart:async';
import 'dart:io';
import 'package:app_sqlite/modele/article.dart';
import 'package:app_sqlite/modele/item.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseClient {
  late Database? _database = null;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      // Création de la base de données
      _database = await create();
      return _database;
    }
  }

  Future create() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String databaseDirectory = join(directory.path, 'database.db');

    var bdd =
        await openDatabase(databaseDirectory, version: 2, onCreate: _onCreate);
    return bdd;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE item (
            id INTEGER PRIMARY KEY,
            nom TEXT NOT NULL)
         ''');

    await db.execute('''
      CREATE TABLE article(
      id INTEGER PRIMAY KEY,
      nom TEXT NOT NULL,
      item INTEGER,
      prix TEXT,
      magasin TEXT,
      image TEXT)
    ''');
  }

  // Ecriture des données
  Future<Item> ajoutItem(Item item) async {
    Database? db = await database;
    item.id = await db?.insert('item', item.toMap() as Map<String, dynamic>);
    return item;
  }

  Future<int> update(Item item) async {
    Database? db = await database;
    return await db!.update('item', item.toMap() as Map<String, dynamic>,
        where: 'id = ?', whereArgs: [item.id]);
  }

  Future<Item> upsertItem(Item item) async {
    Database? db = await database;
    if (item.id == null) {
      item.id = await db!.insert('item', item.toMap() as Map<String, dynamic>);
    } else {
      await db!.update('item', item.toMap() as Map<String, dynamic>,
          where: 'id = ?', whereArgs: [item.id]);
    }
    return item;
  }

  Future<Article> upsertArticle(Article article) async {
    Database? db = await database;
    if (article.id == null) {
      article.id =
          await db!.insert('article', article.toMap() as Map<String, dynamic>);
    } else {
      await db!.update('article', article.toMap() as Map<String, dynamic>,
          where: 'id = ?', whereArgs: [article.id]);
    }
    return article;
  }

  Future<int> delete(int id, String table) async {
    Database? db = await database;
    await db!.delete('article', where: 'item = ?', whereArgs: ['id']);
    return await db!.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  // Lecture de données
  Future<List<Item>> allItem() async {
    Database? db = await database;
    List<Map<String, dynamic>>? resultat =
        await db?.rawQuery("SELECT * FROM item");
    List<Item> items = [];
    resultat?.forEach((map) {
      Item item = Item();
      item.fromMap(map);
      items.add(item);
    });
    return items;
  }

  // Lecture de données
  Future<List<Article>> allArticle(int item) async {
    Database? db = await database;
    List<Map<String, dynamic>>? resultat =
        await db?.query('article', where: 'item = ?', whereArgs: [item]);
    List<Article> articles = [];
    resultat?.forEach((map) {
      Article article = Article();
      article.fromMap(map);
      articles.add(article);
    });
    return articles;
  }
}
