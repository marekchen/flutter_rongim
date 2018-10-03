library flutter_rongim;

import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

part 'dao.dart';

part 'utils.dart';

class FlutterRongim {
  static MethodChannel _channel =
  MethodChannel('plugins.marekchen.github.com/flutter_rongim');

  static EventChannel _channel_event =
  EventChannel('plugins.marekchen.github.com/flutter_rongim_event');

  static Future<void> init() async {
    await _channel.invokeMethod('init');
  }

  static Future<ConnectCallback> connect(String token) async {
    print("chenpei" + token);
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

  static Future<ResultCallback> clearMessages(String targetId,
      ConversationType conversationType) async {
    final Map<dynamic, dynamic> result =
    await _channel.invokeMethod('clearMessages', <String, dynamic>{
      'targetId': targetId,
      'conversationType': conversationType.index,
    });
    ResultCallback callback = ResultCallback.fromJson(result);
    return callback;
  }

  static Future<ResultCallback> deleteMessages(String targetId,
      ConversationType conversationType) async {
    final Map<dynamic, dynamic> result =
    await _channel.invokeMethod('deleteMessages', <String, dynamic>{
      'targetId': targetId,
      'conversationType': conversationType.index,
    });
    ResultCallback callback = ResultCallback.fromJson(result);
    return callback;
  }

  // dart don't support overload
  static Future<ResultCallback> deleteMessagesByIds(
      List<int> messageIds) async {
    final Map<dynamic, dynamic> result =
    await _channel.invokeMethod('deleteMessages', <String, dynamic>{
      'messageIds': messageIds,
    });
    ResultCallback callback = ResultCallback.fromJson(result);
    return callback;
  }

  static Future<ResultCallback> getHistoryMessages(String targetId,
      ConversationType conversationType, int oldestMessageId, int count) async {
    final Map<dynamic, dynamic> result =
    await _channel.invokeMethod('getHistoryMessages', <String, dynamic>{
      'targetId': targetId,
      'conversationType': conversationType.index,
      'oldestMessageId': oldestMessageId,
      'count': count,
    });
    // TODO
    ResultCallback callback = ResultCallback.fromJson(result);
    return callback;
  }

  static Future<ResultCallback> clearMessagesUnreadStatus(String targetId,
      ConversationType conversationType,
      [int timestamp]) async {
    Map<String, dynamic> arguments = {
      "targetId": targetId,
      "conversationType": conversationType.index
    };
    arguments.putIfAbsent("timestamp", () => timestamp);
    final Map<dynamic, dynamic> result =
    await _channel.invokeMethod('clearMessagesUnreadStatus', arguments);
    ResultCallback callback = ResultCallback.fromJson(result);
    return callback;
  }

  static Future<ResultCallback> setMessageReceivedStatus(int messageId,
      ReceivedStatus receivedStatus,) async {
    final Map<dynamic, dynamic> result = await _channel
        .invokeMethod('setMessageReceivedStatus', <String, dynamic>{
      'messageId': messageId,
      'receivedStatus': pow(2, receivedStatus.index),
    });
    ResultCallback callback = ResultCallback.fromJson(result);
    return callback;
  }

  static Future<ResultCallback> getConversation(String targetId,
      ConversationType conversationType) async {
    final Map<dynamic, dynamic> result =
    await _channel.invokeMethod('getConversation', <String, dynamic>{
      'targetId': targetId,
      'conversationType': conversationType.index,
    });
    ResultCallback callback = ResultCallback.fromJson(result, Conversation);
    return callback;
  }

  static Future<ResultCallback<List<Conversation>>> getConversationList(
      List<ConversationType> conversationTypes) async {
    List<int> conversationTypeList = List();
    for (ConversationType conversationType in conversationTypes) {
      conversationTypeList.add(conversationType.index);
    }
    final Map<dynamic, dynamic> result = await _channel.invokeMethod(
        'getConversationList',
        <String, dynamic>{"conversationTypes": conversationTypeList});
    // TODO
    ResultCallback callback = ResultCallback.fromJson(result, List);
    return callback;
  }

  static Future<ResultCallback<List<Conversation>>> getConversationListByPage(
      String targetId,
      List<ConversationType> conversationTypes,
      int timeStamp,
      int count) async {
    List<int> conversationTypeList = List();
    for (ConversationType conversationType in conversationTypes) {
      conversationTypeList.add(conversationType.index);
    }
    // TODO
    final Map<dynamic, dynamic> result = await _channel
        .invokeMethod('getConversationListByPage', <String, dynamic>{
      'targetId': targetId,
      'conversationTypes': conversationTypeList,
      'timeStamp': timeStamp,
      'count': count,
    });
    // TODO
    ResultCallback callback = ResultCallback.fromJson(result, List);
    return callback;
  }

  static Future<ResultCallback<bool>> removeConversation(String targetId,
      ConversationType conversationType) async {
    final Map<dynamic, dynamic> result =
    await _channel.invokeMethod('removeConversation', <String, dynamic>{
      'targetId': targetId,
      'conversationType': conversationType,
    });
    ResultCallback callback = ResultCallback.fromJson(result);
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
    ResultCallback.fromJson(result, ConversationNotificationStatus);
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
    ResultCallback.fromJson(result, ConversationNotificationStatus);
    return callback;
  }

  static Future<ResultCallback> setNotificationQuietHours(String startTime,
      int spanMinutes) async {
    final Map<dynamic, dynamic> result = await _channel
        .invokeMethod('setNotificationQuietHours', <String, dynamic>{
      'startTime': startTime,
      'spanMinutes': spanMinutes,
    });
    ResultCallback callback = ResultCallback.fromJson(result);
    return callback;
  }

  static Future<void> removeNotificationQuietHours() async {
    await _channel.invokeMethod('removeNotificationQuietHours');
  }

  static Future<ResultCallback> saveTextMessageDraft(String targetId,
      ConversationType conversationType, String content) async {
    final Map<dynamic, dynamic> result =
    await _channel.invokeMethod('saveTextMessageDraft', <String, dynamic>{
      'targetId': targetId,
      'conversationType': conversationType,
      'content': content,
    });
    ResultCallback callback = ResultCallback.fromJson(result);
    return callback;
  }

  static Future<ResultCallback> getTextMessageDraft(String targetId,
      ConversationType conversationType) async {
    final Map<dynamic, dynamic> result =
    await _channel.invokeMethod('getTextMessageDraft', <String, dynamic>{
      'targetId': targetId,
      'conversationType': conversationType,
    });
    ResultCallback callback = ResultCallback.fromJson(result);
    return callback;
  }

  static Future<ResultCallback> setConversationToTop(String id,
      ConversationType conversationType, bool isTop, bool needCreate) async {
    final Map<dynamic, dynamic> result =
    await _channel.invokeMethod('setConversationToTop', <String, dynamic>{
      'id': id,
      'conversationType': conversationType,
      'isTop': isTop,
      'needCreate': needCreate,
    });
    ResultCallback callback = ResultCallback.fromJson(result);
    return callback;
  }

  static Future<ResultCallback> getTotalUnreadCount() async {
    final Map<dynamic, dynamic> result =
    await _channel.invokeMethod('getTotalUnreadCount');
    ResultCallback callback = ResultCallback.fromJson(result);
    return callback;
  }

  static Future<ResultCallback> getUnreadCount(String targetId,
      ConversationType conversationType) async {
    final Map<dynamic, dynamic> result =
    await _channel.invokeMethod('getUnreadCount', <String, dynamic>{
      'targetId': targetId,
      'conversationType': conversationType,
    });
    ResultCallback callback = ResultCallback.fromJson(result);
    return callback;
  }

  // dart don't support overload
  static Future<ResultCallback> getUnreadCountByTypes(
      List<ConversationType> conversationTypes) async {
    List<int> conversationTypeList = List();
    for (ConversationType conversationType in conversationTypes) {
      conversationTypeList.add(conversationType.index);
    }
    final Map<dynamic, dynamic> result =
    await _channel.invokeMethod('getUnreadCount', <String, dynamic>{
      'conversationTypes': conversationTypeList,
    });
    ResultCallback callback = ResultCallback.fromJson(result);
    return callback;
  }

  static Future<ResultCallback> sendTypingStatus(String targetId,
      ConversationType conversationType, String typingContentType) async {
    final Map<dynamic, dynamic> result =
    await _channel.invokeMethod('sendTypingStatus', <String, dynamic>{
      'targetId': targetId,
      'conversationType': conversationType,
      'typingContentType': typingContentType,
    });
    ResultCallback callback = ResultCallback.fromJson(result);
    return callback;
  }

  static ResultCallback _parseResponseMessage(Map<dynamic, dynamic> result) {
    ResultCallback callback = ResultCallback.fromJson(result, Message);
    return callback;
  }

  static Stream<ResultCallback> sendMessage(Message message) {
    Map<String, dynamic> arguments = message.toMap();
    arguments.putIfAbsent("method", () => "sendMessage");
    Stream<ResultCallback> _onMessageCallback;
    if (_onMessageCallback == null) {
      _onMessageCallback = _channel_event
          .receiveBroadcastStream(arguments)
          .map((event) => _parseResponseMessage(event));
    }
    return _onMessageCallback;
  }

  static Stream<ResultCallback> sendLocationMessage(Message message) {
    Map<String, dynamic> arguments = message.toMap();
    arguments.putIfAbsent("method", () => "sendLocationMessage");
    Stream<ResultCallback> _onMessageCallback;
    if (_onMessageCallback == null) {
      _onMessageCallback = _channel_event
          .receiveBroadcastStream(arguments)
          .map((dynamic event) => _parseResponseMessage(event));
    }
    return _onMessageCallback;
  }

  static Stream<ResultCallback> sendImageMessage(Message message) {
    Map<String, dynamic> arguments = message.toMap();
    arguments.putIfAbsent("method", () => "sendImageMessage");
    Stream<ResultCallback> _onMessageCallback;
    if (_onMessageCallback == null) {
      _onMessageCallback = _channel_event
          .receiveBroadcastStream(arguments)
          .map((dynamic event) => _parseResponseMessage(event));
    }
    return _onMessageCallback;
  }

  static Stream<ResultCallback> sendMediaMessage(Message message) {
    Map<String, dynamic> arguments = message.toMap();
    arguments.putIfAbsent("method", () => "sendMediaMessage");
    Stream<ResultCallback> _onMessageCallback;
    if (_onMessageCallback == null) {
      _onMessageCallback = _channel_event
          .receiveBroadcastStream(arguments)
          .map((dynamic event) => _parseResponseMessage(event));
    }
    return _onMessageCallback;
  }

  static Stream<ResultCallback> setOnReceiveMessageListener() {
    Stream<ResultCallback> _onMessageCallback;
    if (_onMessageCallback == null) {
      _onMessageCallback = _channel_event
          .receiveBroadcastStream()
          .map((dynamic event) => _parseResponseMessage(event));
    }
    return _onMessageCallback;
  }

  static Stream<ResultCallback> setConnectionStatusListener() {
    Stream<ResultCallback> _onMessageCallback;
    if (_onMessageCallback == null) {
      _onMessageCallback = _channel_event.receiveBroadcastStream().map(
              (dynamic event) =>
              ResultCallback.fromJson(event, ConversationNotificationStatus));
    }
    return _onMessageCallback;
  }

  // TODO
  static Stream<ResultCallback> setTypingStatusListener() {
    Stream<ResultCallback> _onMessageCallback;
    if (_onMessageCallback == null) {
      _onMessageCallback = _channel_event
          .receiveBroadcastStream()
          .map((dynamic event) => ResultCallback.fromJson(event));
    }
    return _onMessageCallback;
  }

  static Stream<ResultCallback> setRCLogInfoListener() {
    Stream<ResultCallback> _onMessageCallback;
    if (_onMessageCallback == null) {
      _onMessageCallback = _channel_event
          .receiveBroadcastStream()
          .map((dynamic event) => ResultCallback.fromJson(event));
    }
    return _onMessageCallback;
  }
}
