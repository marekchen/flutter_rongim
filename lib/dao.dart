part of flutter_rongim;

class ResultCallback<T> {
  bool isSuccess;
  String callbackType; // onSuccess,onError
  T result;
  ErrorCode errorCode;

  ResultCallback(bool isSuccess,
      String callbackType,
      T result,
      ErrorCode errorCode,) {
    this.isSuccess = isSuccess;
    this.callbackType = callbackType;
    this.result = result;
    this.errorCode = errorCode;
  }

  factory ResultCallback.fromJson(Map<dynamic, dynamic> json) {
    print(FlutterRongim.TAG + json.toString());
    var result = json['result'];
    switch (T) {
      case Conversation:
        result = Conversation.fromJson(result);
        break;
      case ConversationNotificationStatus:
        result = conversationTypeFromInt(result);
        break;
      case ConnectionStatus:
        result = connectionStatusFromInt(result);
        break;
      case Message:
        result = Message.fromJson(result);
        break;
    //case TypingStatus:
    //result =
      default:
      // 判断是否是list类型，取出list 子类型
        if (getListType(T) != null) {
          switch (getListType(T)) {
            case "Conversation":
              result = (result as List<dynamic>).map((item) =>
                  Conversation.fromJson(item)).toList();
              break;
            case "Message":
              result = (result as List<dynamic>).map((item) =>
                  Message.fromJson(item)).toList();
              break;
          }
        }
    }
    ResultCallback<T> callback = ResultCallback(
      json['isSuccess'],
      json['callbackType'],
      result,
      ErrorCode.fromJson(json['errorCode']),
    );
    return callback;
  }

  toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      "isSuccess": isSuccess,
      "callbackType": callbackType,
      "result": result,
      "errorCode": errorCode,
    };
    return map;
  }
}

class ConnectCallback extends ResultCallback<String> {

  // callbackType: onTokenIncorrect,onSuccess,onError
  ConnectCallback(bool isSuccess,
      String callbackType,
      String result,
      ErrorCode errorCode,)
      : super(isSuccess, callbackType, result, errorCode);

  factory ConnectCallback.fromJson(Map<dynamic, dynamic> json) {
    print(FlutterRongim.TAG + json.toString());
    ConnectCallback callback = ConnectCallback(
      json['isSuccess'],
      json['callbackType'],
      json['result'],
      ErrorCode.fromJson(json['errorCode']),
    );
    return callback;
  }
}

class SendMessageCallback extends ResultCallback<Message> {
  // callbackType: onAttached,onSuccess,onError,onProgress
  int progress;

  SendMessageCallback(bool value,
      String callbackType,
      Message result,
      ErrorCode errorCode,
      int progress,) : super(value, callbackType, result, errorCode) {
    this.progress = progress;
  }

  factory SendMessageCallback.fromJson(Map<dynamic, dynamic> json) {
    print(FlutterRongim.TAG + json.toString());
    SendMessageCallback callback = SendMessageCallback(
      json['isSuccess'],
      json['callbackType'],
      json['result'],
      ErrorCode.fromJson(json['errorCode']),
      json['progress'],
    );
    return callback;
  }
}

class ErrorCode {
  int value;
  String message;

  ErrorCode(int value, String message) {
    this.value = value;
    this.message = message;
  }

  factory ErrorCode.fromJson(Map<dynamic, dynamic> json) {
    if (json == null || json.isEmpty) {
      return null;
    }
    ErrorCode errorCode = ErrorCode(
      json['value'],
      json['message'],
    );
    return errorCode;
  }
}

enum ConnectionStatus {
  CONNECTED, // 0
  CONNECTING, // 1
  DISCONNECTED, // 2
  KICKED_OFFLINE_BY_OTHER_CLIENT, // 3
  TOKEN_INCORRECT, // 4
  SERVER_INVALID, // 5
  CONN_USER_BLOCKED, // 6
  NETWORK_UNAVAILABLE, // 7 dart enum index start from 0, orginal value is -1
}

ConnectionStatus connectionStatusFromInt(int value) {
  if (value == -1) {
    value = 7;
  }
  return ConnectionStatus.values.firstWhere((md) => md.index == value);
}

class Conversation {
  ConversationType conversationType;
  String targetId;
  String conversationTitle;
  String portraitUrl;
  int unreadMessageCount;
  bool isTop;
  ReceivedStatus receivedStatus;
  SentStatus sentStatus;
  int receivedTime;
  int sentTime;
  String senderUserId;
  String senderUserName;
  int latestMessageId;
  MessageContent latestMessage;
  String draft;
  ConversationNotificationStatus notificationStatus;
  int mentionedCount;

  Conversation({
    this.conversationType,
    this.targetId,
    this.conversationTitle,
    this.portraitUrl,
    this.unreadMessageCount,
    this.isTop,
    this.receivedStatus,
    this.sentStatus,
    this.receivedTime,
    this.sentTime,
    this.senderUserId,
    this.senderUserName,
    this.latestMessageId,
    this.latestMessage,
    this.draft,
    this.notificationStatus,
    this.mentionedCount,
  });

  factory Conversation.fromJson(Map<dynamic, dynamic> json) {
    Conversation conversation = Conversation(
      conversationType: conversationTypeFromInt(json['conversationType']),
      targetId: json['targetId'],
      conversationTitle: json['conversationTitle'],
      portraitUrl: json['portraitUrl'],
      unreadMessageCount: json['unreadMessageCount'],
      isTop: json['isTop'],
      receivedStatus: receivedStatusFromInt(json['receivedStatus']),
      sentStatus: sentStatusFromInt(json['sentStatus']),
      receivedTime: json['receivedTime'],
      sentTime: json['sentTime'],
      senderUserId: json['senderUserId'],
      senderUserName: json['senderUserName'],
      latestMessageId: json['latestMessageId'],
      latestMessage: Message.parseMessageContent(
          json['objectName'], json['latestMessage']),
      draft: json['draft'],
      notificationStatus:
      conversationNotificationStatusFromInt(json['notificationStatus']),
      mentionedCount: json['mentionedCount'],
    );
    return conversation;
  }

  toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      "targetId": targetId,
      "conversationType": conversationType,
    };
    map.putIfAbsent("conversationTitle", () => conversationTitle);
    map.putIfAbsent("portraitUrl", () => portraitUrl);
    map.putIfAbsent("unreadMessageCount", () => unreadMessageCount);
    map.putIfAbsent("receivedStatus", () => receivedStatus);
    map.putIfAbsent("sentStatus", () => sentStatus);
    map.putIfAbsent("receivedTime", () => receivedTime);
    map.putIfAbsent("sentTime", () => sentTime);
    map.putIfAbsent("isTop", () => isTop);
    map.putIfAbsent("senderUserId", () => senderUserId);
    map.putIfAbsent("senderUserName", () => senderUserName);

    map.putIfAbsent("latestMessageId", () => latestMessageId);
    map.putIfAbsent("draft", () => draft);
    if (latestMessage != null) {
      map.putIfAbsent("latestMessage", () => latestMessage.toMap());
    }
    map.putIfAbsent("notificationStatus", () => notificationStatus);
    map.putIfAbsent("mentionedCount", () => mentionedCount);
    return map;
  }
}

enum ConversationNotificationStatus {
  DO_NOT_DISTURB,
  NOTIFY,
}

ConversationNotificationStatus conversationNotificationStatusFromInt(
    int value) {
  return ConversationNotificationStatus.values
      .firstWhere((md) => md.index == value);
}

enum ConversationType {
  NONE,
  PRIVATE,
  DISCUSSION,
  GROUP,
  CHATROOM,
  CUSTOMER_SERVICE,
  SYSTEM,
  APP_PUBLIC_SERVICE,
  PUBLIC_SERVICE,
  PUSH_SERVICE,
}

ConversationType conversationTypeFromInt(int value) {
  return ConversationType.values.firstWhere((md) => md.index == value);
}

enum ReceivedStatus {
  READ,
  LISTENED,
  DOWNLOADED,
  RETRIEVED,
  MULTIPLERECEIVE,
}

ReceivedStatus receivedStatusFromInt(int value) {
  return ReceivedStatus.values.firstWhere((md) => md.index == value);
}

enum SentStatus {
  PLACEHOLDER, // dart enum index start with 0
  SENDING,
  FAILED,
  SENT,
  RECEIVED,
  READ,
  DESTROYED,
  CANCELED,
}

SentStatus sentStatusFromInt(int value) {
  return SentStatus.values.firstWhere((md) => md.index == value ~/ 10);
}

class Response {
  int code;
  int errorCode;
  String errorInfo;
  dynamic result;
}

class UserInfo {
  String id;
  String name;
  Uri portraitUri;

  UserInfo(this.id, this.name, this.portraitUri);

  toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      "id": id,
      "name": name,
      "portraitUri": portraitUri.path,
    };
    return map;
  }

  factory UserInfo.fromJson(Map<dynamic, dynamic> json) {
    UserInfo userInfo = UserInfo(
      json['id'],
      json['name'],
      Uri.parse(json['portraitUri']),
    );
    return userInfo;
  }
}

enum MentionedType {
  NONE,
  ALL,
  PART,
}

MentionedType mentionedTypeFromInt(int value) {
  return MentionedType.values.firstWhere((md) => md.index == value);
}

enum MessageDirection {
  NONE,
  SEND,
  RECEIVE,
}

MessageDirection messageDirectionFromInt(int value) {
  return MessageDirection.values.firstWhere((md) => md.index == value);
}

class MentionedInfo {
  MentionedType type;
  List<String> userIdList;
  String mentionedContent;

  MentionedInfo(this.type, this.userIdList, this.mentionedContent);

  toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      "type": type,
      "userIdList": userIdList,
      "mentionedContent": mentionedContent,
    };
    return map;
  }

  factory MentionedInfo.fromJson(Map<dynamic, dynamic> json) {
    MentionedInfo mentionedInfo = MentionedInfo(
      mentionedTypeFromInt(json['type']),
      json['userIdList'],
      json['mentionedContent'],
    );
    return mentionedInfo;
  }
}

class MessageContent {
  UserInfo userInfo;
  MentionedInfo mentionedInfo;

  setUserInfo(UserInfo userInfo) {
    this.userInfo = userInfo;
  }

  setMentionedInfo(MentionedInfo mentionedInfo) {
    this.mentionedInfo = mentionedInfo;
  }

  toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map.putIfAbsent("userInfo", () => userInfo);
    map.putIfAbsent("mentionedInfo", () => mentionedInfo);
    return map;
  }
}

class Message {
  String targetId;
  ConversationType conversationType;
  MessageContent content;
  String pushContent;
  String pushData;

  int messageId;
  String senderUserId;
  MessageDirection messageDirection;
  String objectName; // RC:TxtMsg RC:ImgMsg RC:VcMsg RC:RcNtf RC:FileMsg

  num sentTime;
  num receivedTime;
  String extra;

  Message(this.targetId, this.conversationType, this.content);

  toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      "targetId": targetId,
      "conversationType": conversationType.index,
      "content": content.toMap(),
    };
    map.putIfAbsent("pushContent", () => pushContent);
    map.putIfAbsent("pushData", () => pushData);

    map.putIfAbsent("messageId", () => messageId);
    map.putIfAbsent("senderUserId", () => senderUserId);
    if (messageDirection != null) {
      map.putIfAbsent("messageDirection", () => messageDirection);
    }
    map.putIfAbsent("objectName", () => objectName);

    map.putIfAbsent("sentTime", () => sentTime);
    map.putIfAbsent("receivedTime", () => receivedTime);
    map.putIfAbsent("extra", () => extra);
    return map;
  }

  factory Message.fromJson(Map<dynamic, dynamic> json) {
    Message message = Message(
      json['targetId'],
      conversationTypeFromInt(json['conversationType']),
      parseMessageContent(json["objectName"], json["content"]),
    );

    message.messageId = json["messageId"];
    message.senderUserId = json["senderUserId"];
    message.messageDirection =
        messageDirectionFromInt(json["messageDirection"]);

    message.objectName = json["objectName"];
    message.sentTime = json["sentTime"];
    message.receivedTime = json["receivedTime"];
    message.extra = json["extra"];
    return message;
  }

  static MessageContent parseMessageContent(String objectName,
      Map<dynamic, dynamic> json) {
    MessageContent content;
    switch (objectName) {
      case "RC:TxtMsg":
        content = TextMessage.fromJson(json);
        break;
      case "RC:LBSMsg":
        content = LocationMessage.fromJson(json);
        break;
      case "RC:ImgMsg":
        content = ImageMessage.fromJson(json);
        break;
      case "RC:VcMsg":
        break;
      case "RC:FileMsg":
        content = FileMessage.fromJson(json);
        break;
      case "RC:RcNtf":
        break;
    }
    return content;
  }
}

class TextMessage extends MessageContent {
  String content;

  String extra;

  TextMessage(this.content);

  toMap() {
    Map<String, dynamic> superMap = super.toMap();
    Map<String, dynamic> map = {
      "content": content,
    };
    map.addAll(superMap);
    return map;
  }

  factory TextMessage.fromJson(Map<dynamic, dynamic> json) {
    if (json == null) {
      return null;
    }
    TextMessage message = TextMessage(
      json['content'],
    );
    if (json.containsKey("userInfo")) {
      message.setUserInfo(UserInfo.fromJson(json['userInfo']));
    }
    if (json.containsKey("mentionedInfo")) {
      message.setMentionedInfo(MentionedInfo.fromJson(json['mentionedInfo']));
    }
    if (json.containsKey("extra")) {
      message.extra = json['extra'];
    }
    return message;
  }
}

class LocationMessage extends MessageContent {
  double lat;
  double lng;
  String poi;
  Uri imgUri;

  LocationMessage(this.lat, this.lng, this.poi, this.imgUri);

  toMap() {
    Map<String, dynamic> superMap = super.toMap();
    Map<String, dynamic> map = {
      "lat": lat,
      "lng": lng,
      "poi": poi,
      "imgUri": imgUri.toString(),
    };
    map.addAll(superMap);
    return map;
  }

  factory LocationMessage.fromJson(Map<dynamic, dynamic> json) {
    LocationMessage message = LocationMessage(
      json['lat'],
      json['lng'],
      json['poi'],
      json['imgUri'],
    );
    if (json.containsKey("userInfo")) {
      message.setUserInfo(UserInfo.fromJson(json['userInfo']));
    }
    if (json.containsKey("mentionedInfo")) {
      message.setMentionedInfo(MentionedInfo.fromJson(json['mentionedInfo']));
    }
    return message;
  }
}

class ImageMessage extends MediaMessageContent {
  Uri thumbUri;
  bool isFull;

  ImageMessage({
    @required Uri thumbUri,
    Uri localUri,
    bool isFull = true,
  }) : super(localUri) {
    this.thumbUri = thumbUri;
    this.isFull = isFull;
  }

  toMap() {
    Map<String, dynamic> superMap = super.toMap();
    Map<String, dynamic> map = {
      "thumbUri": thumbUri.toString(),
      "localUri": localPath.toString(),
      "isFull": isFull,
    };
    if (mediaUrl != null) {
      map.putIfAbsent("remoteUri", () => mediaUrl.toString());
    }
    map.addAll(superMap);
    return map;
  }

  factory ImageMessage.fromJson(Map<dynamic, dynamic> json) {
    ImageMessage message = ImageMessage(
        thumbUri: Uri.parse(json['thumbUri']),
        localUri: json['localUri'] != null ? Uri.parse(json['localUri']) : null,
        isFull: json['isFull']);
    if (json.containsKey("userInfo")) {
      message.setUserInfo(UserInfo.fromJson(json['userInfo']));
    }
    if (json.containsKey("mentionedInfo")) {
      message.setMentionedInfo(MentionedInfo.fromJson(json['mentionedInfo']));
    }
    if (json.containsKey("extra")) {
      message.extra = json['extra'];
    }
    if (json.containsKey("mediaUrl")) {
      message.mediaUrl = Uri.parse(json['mediaUrl']);
    }
    return message;
  }
}

class MediaMessageContent extends MessageContent {
  Uri localPath;
  Uri mediaUrl;
  String extra;

  MediaMessageContent(this.localPath);

  toMap() {
    Map<String, dynamic> superMap = super.toMap();
    return superMap;
  }
}

class FileMessage extends MediaMessageContent {
  FileMessage(Uri localUri) : super(localUri);

  toMap() {
    Map<String, dynamic> superMap = super.toMap();
    Map<String, dynamic> map = <String, dynamic>{
      "localUri": localPath.toString(),
      "extra": extra,
    };
    if (mediaUrl != null) {
      map.putIfAbsent("fileUrl", () => mediaUrl.toString());
    }
    map.addAll(superMap);
    return map;
  }

  factory FileMessage.fromJson(Map<dynamic, dynamic> json) {
    FileMessage message = FileMessage(Uri.parse(json['localUri']));
    if (json.containsKey("userInfo")) {
      message.setUserInfo(UserInfo.fromJson(json['userInfo']));
    }
    if (json.containsKey("mentionedInfo")) {
      message.setMentionedInfo(MentionedInfo.fromJson(json['mentionedInfo']));
    }
    if (json.containsKey("extra")) {
      message.extra = json['extra'];
    }
    if (json.containsKey("mediaUrl")) {
      message.mediaUrl = Uri.parse(json['mediaUrl']);
    }
    return message;
  }
}

class TypingStatusListener {
  ConversationType conversationType;
  String targetId;
  List<TypingStatus> typingStatusSet;

  TypingStatusListener(ConversationType conversationType,
      String targetId,
      List<TypingStatus> typingStatusSet,) {
    this.conversationType = conversationType;
    this.targetId = targetId;
    this.typingStatusSet = typingStatusSet;
  }

  factory TypingStatusListener.fromJson(Map<dynamic, dynamic> json) {
    TypingStatusListener status = TypingStatusListener(
      conversationTypeFromInt(json['conversationType']),
      json['targetId'],
      // TODO List
      json['typingStatusSet'],
    );
    return status;
  }
}

class TypingStatus {
  int sentTime;
  String typingContentType;
  String userId;

  TypingStatus(int sentTime,
      String typingContentType,
      String userId,) {
    this.sentTime = sentTime;
    this.typingContentType = typingContentType;
    this.userId = userId;
  }

  factory TypingStatus.fromJson(Map<dynamic, dynamic> json) {
    TypingStatus status = TypingStatus(
      json['sentTime'],
      json['typingContentType'],
      json['userId'],
    );
    return status;
  }
}

T listConvert<T>(Map<String, dynamic> json) {}
