import 'dart:async';
import 'dart:io';

import 'package:flutter_nb/constants/constants.dart';
import 'package:flutter_nb/database/database_config.dart';
import 'package:flutter_nb/entity/message_entity.dart';
import 'package:flutter_nb/utils/sp_util.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class MessageDataBase {
  static final MessageDataBase _messageDataBase =
      new MessageDataBase._internal();

  static MessageDataBase get() {
    return _messageDataBase;
  }

  MessageDataBase._internal();

  Future<Database> _init() async {
    // Get a location using path_provider
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(
        documentsDirectory.path,
        SPUtil.getString(Constants.KEY_LOGIN_ACCOUNT) +
            '_' +
            DataBaseConfig.DATABASE_NAME);
    return await openDatabase(path, version: DataBaseConfig.VERSION_CODE,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table，数据库名：登录帐号_nb_db
      //创建2个表，一个存放消息类型（表名固定），一个存放某个类型的所有消息（表名为发送方帐号）
      await db.execute(
          "CREATE TABLE IF NOT EXISTS ${DataBaseConfig.MESSAGE_TABLE} ("
          "${MessageTypeEntity.DB_ID} INTEGER PRIMARY KEY AUTOINCREMENT,"
          "${MessageTypeEntity.IS_UNREAD_COUNT} INTEGER,"
          "${MessageTypeEntity.SENDER_ACCOUNT} TEXT"
          ")");
      await db.execute(
          "CREATE TABLE IF NOT EXISTS nb_${Constants.MESSAGE_TYPE_SYSTEM} ("
          "${MessageEntity.DB_ID} INTEGER PRIMARY KEY AUTOINCREMENT,"
          "${MessageEntity.TYPE} TEXT,"
          "${MessageEntity.IMAGE_URL} TEXT,"
          "${MessageEntity.IS_UNREAD} INTEGER,"
          "${MessageEntity.SENDER_ACCOUNT} TEXT,"
          "${MessageEntity.TITLE_NAME} TEXT,"
          "${MessageEntity.CONTENT} TEXT,"
          "${MessageEntity.CONTENT_TYPE} TEXT,"
          "${MessageEntity.CONTENT_URL} TEXT,"
          "${MessageEntity.TIME} TEXT,"
          "${MessageEntity.NOTE} TEXT,"
          "${MessageEntity.METHOD} TEXT,"
          "${MessageEntity.STATUS} TEXT,"
          "${MessageEntity.THUMBPATH} TEXT,"
          "${MessageEntity.LATITUDE} TEXT,"
          "${MessageEntity.LONGITUDE} TEXT,"
          "${MessageEntity.LOCATIONADDRESS} TEXT,"
          "${MessageEntity.MESSAGE_OWNER} INTEGER,"
          "${MessageEntity.IS_REMIND} INTEGER,"
          "${MessageEntity.LENGTH} INTEGER"
          ")");
    });
  }

  Future _createTypeTable(Database db, String senderAccount) async {
    await db.execute("CREATE TABLE IF NOT EXISTS nb_$senderAccount ("
        "${MessageEntity.DB_ID} INTEGER PRIMARY KEY AUTOINCREMENT,"
        "${MessageEntity.TYPE} TEXT,"
        "${MessageEntity.IMAGE_URL} TEXT,"
        "${MessageEntity.IS_UNREAD} INTEGER,"
        "${MessageEntity.SENDER_ACCOUNT} TEXT,"
        "${MessageEntity.TITLE_NAME} TEXT,"
        "${MessageEntity.CONTENT} TEXT,"
        "${MessageEntity.CONTENT_TYPE} TEXT,"
        "${MessageEntity.CONTENT_URL} TEXT,"
        "${MessageEntity.TIME} TEXT,"
        "${MessageEntity.NOTE} TEXT,"
        "${MessageEntity.METHOD} TEXT,"
        "${MessageEntity.STATUS} TEXT,"
        "${MessageEntity.THUMBPATH} TEXT,"
        "${MessageEntity.LATITUDE} TEXT,"
        "${MessageEntity.LONGITUDE} TEXT,"
        "${MessageEntity.LOCATIONADDRESS} TEXT,"
        "${MessageEntity.MESSAGE_OWNER} INTEGER,"
        "${MessageEntity.IS_REMIND} INTEGER,"
        "${MessageEntity.LENGTH} INTEGER"
        ")");
  }

  /*
  *  查询消息列表的类别
  */
  Future<List<MessageTypeEntity>> getMessageTypeEntity() async {
    var db = await _init();
    var result =
        await db.rawQuery('SELECT * FROM ${DataBaseConfig.MESSAGE_TABLE}');
    List<MessageTypeEntity> res = [];
    for (Map<String, dynamic> item in result) {
      res.add(new MessageTypeEntity.fromMap(item));
    }
    return res;
  }

  /*
  *  查询消息类别的未读数
  */
  Future<int> getOneMessageUnreadCount(String senderAccount) async {
    var db = await _init();
    var result = await db.rawQuery(
        'SELECT ${MessageTypeEntity.IS_UNREAD_COUNT} FROM ${DataBaseConfig.MESSAGE_TABLE} '
        'where ${MessageTypeEntity.SENDER_ACCOUNT} = "$senderAccount"');
    List<MessageTypeEntity> res = [];
    for (Map<String, dynamic> item in result) {
      res.add(new MessageTypeEntity.fromMap(item)); //数组只有一个，因为每个类型只有一条数据
    }
    return res.length > 0 ? res.elementAt(0).isUnreadCount : 0;
  }

  /*
  * 查出某个消息类型（某个用户的对话即算一个消息类型）的所有消息
  */
  Future<List<MessageEntity>> getMessageEntityInType(
      String senderAccount) async {
    var db = await _init();
    await _createTypeTable(db, senderAccount);
    var result = await db.rawQuery('SELECT * FROM nb_$senderAccount');
    List<MessageEntity> books = [];
    for (Map<String, dynamic> item in result) {
      books.add(new MessageEntity.fromMap(item));
    }
    return books;
  }

  /*
  * 查出某个消息类型（某个用户的对话即算一个消息类型）的所有消息
  */
  Future<List<MessageEntity>> getMessageEntityInTypeLimit(String senderAccount,
      {int offset = 0, int count = 20}) async {
    var db = await _init();
    await _createTypeTable(db, senderAccount);
    var result = await db.query('nb_$senderAccount',
        orderBy: '${MessageEntity.DB_ID} desc', offset: offset, limit: count);
    List<MessageEntity> books = [];
    for (Map<String, dynamic> item in result) {
      books.add(new MessageEntity.fromMap(item));
    }
    return books;
  }

  Future insertMessageEntity(String senderAccount, MessageEntity entity) {
    return updateMessageEntity(senderAccount, entity);
  }

  Future insertMessageTypeEntity(MessageTypeEntity entity) {
    getMessageTypeEntity().then((list) {
      bool isExit = false;
      for (MessageTypeEntity item in list) {
        if (item.senderAccount == entity.senderAccount) {
          isExit = true;
        }
      }
      if (!isExit) {
        _updateMessageTypeEntity(entity);
      } else {
        deleteMessageTypeEntity(entity: entity).then((res) {
          _updateMessageTypeEntity(entity);
        });
      }
    });
    return null;
  }

  Future _updateMessageTypeEntity(MessageTypeEntity entity) async {
    var db = await _init();
    await db.rawUpdate(
        'INSERT OR REPLACE INTO '
        '${DataBaseConfig.MESSAGE_TABLE}(${MessageTypeEntity.SENDER_ACCOUNT},${MessageTypeEntity.IS_UNREAD_COUNT})'
        ' VALUES(?,?)',
        [
          entity.senderAccount,
          entity.isUnreadCount,
        ]);
  }

  Future updateAllMessageTypeEntity(String sender) async {
    var db = await _init();
    await db.rawUpdate(
        'UPDATE ${DataBaseConfig.MESSAGE_TABLE} SET ${MessageTypeEntity.IS_UNREAD_COUNT} = 0 WHERE ${MessageTypeEntity.SENDER_ACCOUNT} = "$sender"');
  }

  Future updateMessageEntity(String senderAccount, MessageEntity entity) async {
    var db = await _init();
    _createTypeTable(db, entity.senderAccount).then((res) async {
      await db.rawInsert(
          'INSERT OR REPLACE INTO '
          'nb_$senderAccount('
          '${MessageEntity.TYPE},'
          ' ${MessageEntity.IMAGE_URL},'
          ' ${MessageEntity.IS_UNREAD},'
          ' ${MessageEntity.SENDER_ACCOUNT},'
          ' ${MessageEntity.TITLE_NAME},'
          ' ${MessageEntity.CONTENT},'
          ' ${MessageEntity.CONTENT_TYPE},'
          ' ${MessageEntity.CONTENT_URL},'
          ' ${MessageEntity.TIME},'
          ' ${MessageEntity.MESSAGE_OWNER},'
          ' ${MessageEntity.IS_REMIND},'
          ' ${MessageEntity.NOTE},'
          ' ${MessageEntity.METHOD},'
          ' ${MessageEntity.LENGTH},'
          ' ${MessageEntity.LATITUDE},'
          ' ${MessageEntity.LONGITUDE},'
          ' ${MessageEntity.LOCATIONADDRESS},'
          ' ${MessageEntity.THUMBPATH},'
          ' ${MessageEntity.STATUS})'
          ' VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
          [
            entity.type,
            entity.imageUrl,
            entity.isUnread,
            entity.senderAccount,
            entity.titleName,
            entity.content,
            entity.contentType,
            entity.contentUrl,
            entity.time,
            entity.messageOwner,
            entity.isRemind,
            entity.note,
            entity.method,
            entity.length,
            entity.latitude,
            entity.longitude,
            entity.locationAddress,
            entity.thumbPath,
            entity.status
          ]);
    });
  }

  Future deleteMessageTypeEntity({MessageTypeEntity entity}) async {
    var db = await _init();
    if (entity == null) {
      await db.delete(DataBaseConfig.MESSAGE_TABLE);
    } else {
      await db.rawDelete(
          'DELETE FROM ${DataBaseConfig.MESSAGE_TABLE} WHERE ${MessageTypeEntity.SENDER_ACCOUNT} = "${entity.senderAccount}"');
    }
  }

  Future deleteMessageEntity(String senderAccount,
      {MessageEntity entity}) async {
    var db = await _init();
    _createTypeTable(db, senderAccount).then((res) async {
      if (entity == null) {
        await db.delete('nb_$senderAccount');
      } else {
        await db.delete('nb_$senderAccount',
            where: "${MessageEntity.DB_ID} = ?", whereArgs: [entity.id]);
      }
    });
  }

  Future close() async {
    var db = await _init();
    db.close();
    return db = null;
  }
}
