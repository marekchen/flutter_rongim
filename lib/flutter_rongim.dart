library flutter_rongim;

import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

part 'dao.dart';

part 'utils.dart';

part 'send_message_task.dart';

class FlutterRongim {

  static String TAG = "FlutterRongim";

  static MethodChannel _channel =
  MethodChannel('plugins.marekchen.github.com/flutter_rongim');

  static MethodChannel _channel_send_message =
  MethodChannel('plugins.marekchen.github.com/flutter_rongim_send_message');

  static EventChannel _channel_event =
  EventChannel('plugins.marekchen.github.com/flutter_rongim_event');

  static EventChannel _eventChannelFor(String method) {
    return EventChannel(
        'plugins.marekchen.github.com/flutter_rongim_event#$method');
  }

  static bool _initialized = false;

  static FlutterRongim _instance = FlutterRongim();

  static FlutterRongim get instance => _instance;

  FlutterRongim() {
    if (_initialized) return;
    _channel_send_message.setMethodCallHandler((MethodCall call) async {
      _methodStreamController.add(call);
    });
  }

  static final StreamController<MethodCall> _methodStreamController =
  new StreamController<MethodCall>.broadcast();

  Stream<MethodCall> get _methodStream => _methodStreamController.stream;

  static Future<ConnectCallback> connect(String token) async {
    final Map<dynamic, dynamic> result = await _channel
        .invokeMethod('connect', <String, dynamic>{'token': token});
    ConnectCallback callback = ConnectCallback.fromJson(result);
    return callback;
  }

  static Future<void> disconnect() async {
    await _channel.invokeMethod('disconnect');
  }

  static Future<void> logout() async {
    await _channel.invokeMethod('logout');
  }

  static Future<ResultCallback<bool>> clearMessages(String targetId,
      ConversationType conversationType) async {
    final Map<dynamic, dynamic> result =
    await _channel.invokeMethod('clearMessages', <String, dynamic>{
      'targetId': targetId,
      'conversationType': conversationType.index,
    });
    ResultCallback<bool> callback = new ResultCallback<bool>.fromJson(result);
    return callback;
  }

  static Future<ResultCallback<bool>> deleteMessages(String targetId,
      ConversationType conversationType) async {
    final Map<dynamic, dynamic> result =
    await _channel.invokeMethod('deleteMessages', <String, dynamic>{
      'targetId': targetId,
      'conversationType': conversationType.index,
    });
    ResultCallback<bool> callback = new ResultCallback<bool>.fromJson(result);
    return callback;
  }

  // dart don't support overload
  static Future<ResultCallback<bool>> deleteMessagesByIds(
      List<int> messageIds) async {
    final Map<dynamic, dynamic> result =
    await _channel.invokeMethod('deleteMessages', <String, dynamic>{
      'messageIds': messageIds,
    });
    ResultCallback<bool> callback = new ResultCallback<bool>.fromJson(result);
    return callback;
  }

  static Future<ResultCallback<List<Message>>> getHistoryMessages(
      String targetId,
      ConversationType conversationType, int oldestMessageId, int count) async {
    final Map<dynamic, dynamic> result =
    await _channel.invokeMethod('getHistoryMessages', <String, dynamic>{
      'targetId': targetId,
      'conversationType': conversationType.index,
      'oldestMessageId': oldestMessageId,
      'count': count,
    });
    // TODO
    ResultCallback<List<Message>> callback = new ResultCallback<
        List<Message>>.fromJson(result);
    return callback;
  }

  static Future<ResultCallback<bool>> clearMessagesUnreadStatus(String targetId,
      ConversationType conversationType,
      [int timestamp]) async {
    Map<String, dynamic> arguments = {
      "targetId": targetId,
      "conversationType": conversationType.index
    };
    arguments.putIfAbsent("timestamp", () => timestamp);
    final Map<dynamic, dynamic> result =
    await _channel.invokeMethod('clearMessagesUnreadStatus', arguments);
    ResultCallback<bool> callback = new ResultCallback<bool>.fromJson(result);
    return callback;
  }

  static Future<ResultCallback<bool>> setMessageReceivedStatus(int messageId,
      ReceivedStatus receivedStatus,) async {
    final Map<dynamic, dynamic> result = await _channel
        .invokeMethod('setMessageReceivedStatus', <String, dynamic>{
      'messageId': messageId,
      'receivedStatus': pow(2, receivedStatus.index),
    });
    ResultCallback<bool> callback = new ResultCallback<bool>.fromJson(result);
    return callback;
  }

  static Future<ResultCallback<Conversation>> getConversation(String targetId,
      ConversationType conversationType) async {
    final Map<dynamic, dynamic> result =
    await _channel.invokeMethod('getConversation', <String, dynamic>{
      'targetId': targetId,
      'conversationType': conversationType.index,
    });
    ResultCallback<Conversation> callback = new ResultCallback<
        Conversation>.fromJson(result);
    return callback;
  }

  static Future<ResultCallback<List<Conversation>>> getConversationList(
      List<ConversationType> conversationTypes) async {
    List<int> conversationTypeList = conversationTypes.map((
        conversationType) => conversationType.index).toList();
    final Map<dynamic, dynamic> result = await _channel.invokeMethod(
        'getConversationList',
        <String, dynamic>{"conversationTypes": conversationTypeList});
    ResultCallback<List<Conversation>> callback = new ResultCallback<
        List<Conversation>>.fromJson(result);
    return callback;
  }

  static Future<ResultCallback<List<Conversation>>> getConversationListByPage(
      String targetId,
      List<ConversationType> conversationTypes,
      int timeStamp,
      int count) async {
    List<int> conversationTypeList = conversationTypes.map((
        conversationType) => conversationType.index).toList();
    final Map<dynamic, dynamic> result = await _channel
        .invokeMethod('getConversationListByPage', <String, dynamic>{
      'targetId': targetId,
      'conversationTypes': conversationTypeList,
      'timeStamp': timeStamp,
      'count': count,
    });
    ResultCallback<List<Conversation>> callback = new ResultCallback<
        List<Conversation>>.fromJson(result);
    return callback;
  }

  static Future<ResultCallback<bool>> removeConversation(String targetId,
      ConversationType conversationType) async {
    final Map<dynamic, dynamic> result =
    await _channel.invokeMethod('removeConversation', <String, dynamic>{
      'targetId': targetId,
      'conversationType': conversationType,
    });
    ResultCallback<bool> callback = new ResultCallback<bool>.fromJson(result);
    return callback;
  }

  static Future<ResultCallback<
      ConversationNotificationStatus>> getConversationNotificationStatus(
      String targetId, ConversationType conversationType) async {
    final Map<dynamic, dynamic> result = await _channel
        .invokeMethod('getConversationNotificationStatus', <String, dynamic>{
      'targetId': targetId,
      'conversationType': conversationType,
    });
    ResultCallback<ConversationNotificationStatus> callback =
    new ResultCallback<ConversationNotificationStatus>.fromJson(result);
    return callback;
  }

  static Future<ResultCallback<
      ConversationNotificationStatus>> setConversationNotificationStatus(
      String targetId,
      ConversationType conversationType,
      ConversationNotificationStatus notificationStatus) async {
    final Map<dynamic, dynamic> result = await _channel
        .invokeMethod('setConversationNotificationStatus', <String, dynamic>{
      'targetId': targetId,
      'conversationType': conversationType,
      'notificationStatus': notificationStatus,
    });
    ResultCallback<ConversationNotificationStatus> callback =
    new ResultCallback<ConversationNotificationStatus>.fromJson(result);
    return callback;
  }

  static Future<ResultCallback<bool>> setNotificationQuietHours(
      String startTime,
      int spanMinutes) async {
    final Map<dynamic, dynamic> result = await _channel
        .invokeMethod('setNotificationQuietHours', <String, dynamic>{
      'startTime': startTime,
      'spanMinutes': spanMinutes,
    });
    ResultCallback<bool> callback = new ResultCallback<bool>.fromJson(result);
    return callback;
  }

  static Future<void> removeNotificationQuietHours() async {
    await _channel.invokeMethod('removeNotificationQuietHours');
  }

  static Future<ResultCallback<bool>> saveTextMessageDraft(String targetId,
      ConversationType conversationType, String content) async {
    final Map<dynamic, dynamic> result =
    await _channel.invokeMethod('saveTextMessageDraft', <String, dynamic>{
      'targetId': targetId,
      'conversationType': conversationType,
      'content': content,
    });
    ResultCallback<bool> callback = new ResultCallback<bool>.fromJson(result);
    return callback;
  }

  static Future<ResultCallback<String>> getTextMessageDraft(String targetId,
      ConversationType conversationType) async {
    final Map<dynamic, dynamic> result =
    await _channel.invokeMethod('getTextMessageDraft', <String, dynamic>{
      'targetId': targetId,
      'conversationType': conversationType,
    });
    ResultCallback<String> callback = new ResultCallback<String>.fromJson(
        result);
    return callback;
  }

  static Future<ResultCallback<bool>> setConversationToTop(String id,
      ConversationType conversationType, bool isTop, bool needCreate) async {
    final Map<dynamic, dynamic> result =
    await _channel.invokeMethod('setConversationToTop', <String, dynamic>{
      'id': id,
      'conversationType': conversationType,
      'isTop': isTop,
      'needCreate': needCreate,
    });
    ResultCallback<bool> callback = new ResultCallback<bool>.fromJson(result);
    return callback;
  }

  static Future<ResultCallback<int>> getTotalUnreadCount() async {
    final Map<dynamic, dynamic> result =
    await _channel.invokeMethod('getTotalUnreadCount');
    ResultCallback<int> callback = new ResultCallback<int>.fromJson(result);
    return callback;
  }

  static Future<ResultCallback<int>> getUnreadCount(String targetId,
      ConversationType conversationType) async {
    final Map<dynamic, dynamic> result =
    await _channel.invokeMethod('getUnreadCount', <String, dynamic>{
      'targetId': targetId,
      'conversationType': conversationType,
    });
    ResultCallback<int> callback = new ResultCallback<int>.fromJson(result);
    return callback;
  }

  // dart don't support overload
  static Future<ResultCallback<int>> getUnreadCountByTypes(
      List<ConversationType> conversationTypes) async {
    List<int> conversationTypeList = conversationTypes.map((
        conversationType) => conversationType.index).toList();
    final Map<dynamic, dynamic> result =
    await _channel.invokeMethod('getUnreadCount', <String, dynamic>{
      'conversationTypes': conversationTypeList,
    });
    ResultCallback<int> callback = new ResultCallback<int>.fromJson(result);
    return callback;
  }

  static Future<void> sendTypingStatus(String targetId,
      ConversationType conversationType, String typingContentType) async {
    final Map<dynamic, dynamic> result =
    await _channel.invokeMethod('sendTypingStatus', <String, dynamic>{
      'targetId': targetId,
      'conversationType': conversationType,
      'typingContentType': typingContentType, // TODO ?
    });
  }

  static SendMessageTask sendMessage(Message message) {
    SendMessageTask task = SendMessageTask(instance, "sendMessage");
    task._start(message);
    return task;
  }

  static SendMessageTask sendLocationMessage(Message message) {
    SendMessageTask task = SendMessageTask(instance, "sendLocationMessage");
    task._start(message);
    return task;
  }

  static SendMessageTask sendImageMessage(Message message) {
    SendMessageTask task = SendMessageTask(instance, "sendImageMessage");
    task._start(message);
    return task;
  }

  static SendMessageTask sendMediaMessage(Message message) {
    SendMessageTask task = SendMessageTask(instance, "sendMediaMessage");
    task._start(message);
    return task;
  }

  static Stream<ResultCallback<Message>> setOnReceiveMessageListener() {
    Map<String, dynamic> arguments = new Map();
    arguments.putIfAbsent("method", () => "setOnReceiveMessageListener");
    Stream<ResultCallback<Message>> _onMessageCallback;
    if (_onMessageCallback == null) {
      _onMessageCallback = _eventChannelFor("setOnReceiveMessageListener")
          .receiveBroadcastStream(arguments)
          .map((dynamic event) =>
      new ResultCallback<Message>.fromJson(
          event));
    }
    return _onMessageCallback;
  }

  static Stream<
      ResultCallback<ConnectionStatus>> setConnectionStatusListener() {
    Map<String, dynamic> arguments = new Map();
    arguments.putIfAbsent("method", () => "setConnectionStatusListener");
    Stream<ResultCallback<ConnectionStatus>> _onMessageCallback;
    if (_onMessageCallback == null) {
      _onMessageCallback = _eventChannelFor("setConnectionStatusListener")
          .receiveBroadcastStream(arguments)
          .map((dynamic event) =>
      new ResultCallback<ConnectionStatus>.fromJson(event));
    }
    return _onMessageCallback;
  }

  // TODO
  static Stream<
      ResultCallback<TypingStatusListener>> setTypingStatusListener() {
    Map<String, dynamic> arguments = new Map();
    arguments.putIfAbsent("method", () => "setTypingStatusListener");
    Stream<ResultCallback<TypingStatusListener>> _onMessageCallback;
    if (_onMessageCallback == null) {
      _onMessageCallback = _eventChannelFor("setTypingStatusListener")
          .receiveBroadcastStream(arguments)
          .map((dynamic event) =>
      new ResultCallback<TypingStatusListener>.fromJson(event));
    }
    return _onMessageCallback;
  }

  static Stream<ResultCallback<String>> setRCLogInfoListener() {
    Map<String, dynamic> arguments = new Map();
    arguments.putIfAbsent("method", () => "setRCLogInfoListener");
    Stream<ResultCallback<String>> _onMessageCallback;
    if (_onMessageCallback == null) {
      _onMessageCallback = _eventChannelFor("setRCLogInfoListener")
          .receiveBroadcastStream(arguments)
          .map((dynamic event) => new ResultCallback<String>.fromJson(event));
    }
    return _onMessageCallback;
  }
}
