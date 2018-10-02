package com.github.marekchen.flutterrongim;

import android.net.Uri;
import android.util.Log;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.StreamHandler;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import io.rong.imlib.IRongCallback;
import io.rong.imlib.RongIMClient;
import io.rong.imlib.RongIMClient.ErrorCode;
import io.rong.imlib.RongIMClient.ResultCallback;
import io.rong.imlib.RongIMClient.OperationCallback;
import io.rong.imlib.RongIMClient.SendImageMessageCallback;
import io.rong.imlib.TypingMessage.TypingStatus;
import io.rong.imlib.model.Conversation;
import io.rong.imlib.model.Conversation.ConversationType;
import io.rong.imlib.model.Message;
import io.rong.message.FileMessage;
import io.rong.message.ImageMessage;
import io.rong.message.LocationMessage;
import io.rong.message.TextMessage;

import static com.github.marekchen.flutterrongim.Utils.*;


/**
 * FlutterRongimPlugin
 */
public class FlutterRongimPlugin implements MethodCallHandler, StreamHandler {
    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "plugins.marekchen.github.com/flutter_rongim");
        final EventChannel eventChannel = new EventChannel(registrar.messenger(), "plugins.marekchen.github.com/flutter_rongim_event");
        FlutterRongimPlugin instance = new FlutterRongimPlugin();
        channel.setMethodCallHandler(instance);
        eventChannel.setStreamHandler(instance);
    }

    private final static String TAG = "FlutterRongcloudPlugin";

    @Override
    public void onMethodCall(MethodCall methodCall, final Result result) {
        switch (methodCall.method) {
            case "connect":
                connect(methodCall, result);
                break;
            case "disconnect":
                disconnect(methodCall, result);
                break;
            case "logout":
                logout(methodCall, result);
                break;
            case "insertMessage":
                // NO
                break;
            case "clearMessages":
                clearMessages(methodCall, result);
                break;
            case "deleteMessages":
                deleteMessages(methodCall, result);
                break;
            case "getHistoryMessages":
                getHistoryMessages(methodCall, result);
                break;
            case "getRemoteHistoryMessages":
                // NO
                break;
            case "searchConversations":
                // NO
                break;
            case "searchMessages":
                // NO
                break;
            case "clearMessagesUnreadStatus":
                clearMessagesUnreadStatus(methodCall, result);
                break;
            case "setMessageReceivedStatus":
                setMessageReceivedStatus(methodCall, result);
                break;
            case "getConversation":
                getConversation(methodCall, result);
                break;
            case "getConversationList":
                getConversationList(methodCall, result);
                break;
            case "getConversationListByPage":
                getConversationListByPage(methodCall, result);
                break;
            case "removeConversation":
                removeConversation(methodCall, result);
                break;
            case "getConversationNotificationStatus":
                getConversationNotificationStatus(methodCall, result);
                break;
            case "setConversationNotificationStatus":
                setConversationNotificationStatus(methodCall, result);
                break;
            case "setNotificationQuietHours":
                setNotificationQuietHours(methodCall, result);
                break;
            case "removeNotificationQuietHours":
                removeNotificationQuietHours(methodCall, result);
                break;
            case "saveTextMessageDraft":
                saveTextMessageDraft(methodCall, result);
                break;
            case "getTextMessageDraft":
                getTextMessageDraft(methodCall, result);
                break;
            case "setConversationToTop":
                setConversationToTop(methodCall, result);
                break;
            case "getTotalUnreadCount":
                getTotalUnreadCount(methodCall, result);
                break;
            case "getUnreadCount":
                getUnreadCount(methodCall, result);
                break;
            case "addToBlacklist":
                // TODO
                break;
            case "removeFromBlacklist":
                // TODO
                break;
            case "getBlacklistStatus":
                // TODO
                break;
            case "getBlacklist":
                // TODO
                break;
            case "joinChatRoom":
                // TODO
                break;
            case "joinExistChatRoom":
                // TODO
                break;
            case "quitChatRoom":
                // TODO
                break;
            case "getChatRoomInfo":
                // TODO
                break;
            case "getChatroomHistoryMessages":
                // NO
                break;
            case "getMentionedCount":
                // NO
                break;
            case "getUnreadMentionedMessages":
                // NO
                break;
            case "recallMessage":
                // NO
                break;
            case "setRecallMessageListener":
                // NO
                break;
            case "sendReadReceiptMessage":
                // NO
                break;
            case "setReadReceiptListener":
                // NO
                break;
            case "sendReadReceiptRequest":
                // NO
                break;
            case "sendReadReceiptResponse":
                // NO
                break;
            case "syncConversationReadStatus":
                // NO
                break;
            case "setSyncConversationReadStatusListener":
                // NO
                break;
            case "sendTypingStatus":
                sendTypingStatus(methodCall, result);
                break;
            case "getRealTimeLocation":
                // NO
                break;
            case "startRealTimeLocation":
                // NO
                break;
            case "joinRealTimeLocation":
                // NO
                break;
            case "quitRealTimeLocation":
                // NO
                break;
            case "getRealTimeLocationParticipants":
                // NO
                break;
            case "getRealTimeLocationCurrentState":
                // NO
                break;
            case "addRealTimeLocationListener":
                // NO
                break;
            case "removeRealTimeLocationObserver":
                // NO
                break;
        }
    }

    private void connect(MethodCall methodCall, final Result result) {
        String token = methodCall.argument("token");
        RongIMClient.connect(token, new RongIMClient.ConnectCallback() {
            @Override
            public void onTokenIncorrect() {
                Map<String, Object> re = new HashMap<>();
                re.put("isSuccess", false);
                re.put("callbackType", "onTokenIncorrect");
                result.success(re);
            }

            @Override
            public void onSuccess(String s) {
                Map<String, Object> re = new HashMap<>();
                re.put("isSuccess", true);
                re.put("callbackType", "onSuccess");
                result.success(re);
            }

            @Override
            public void onError(ErrorCode errorCode) {
                Map<String, Object> re = new HashMap<>();
                re.put("isSuccess", false);
                re.put("callbackType", "onError");
                re.put("errorCode", errorCodeToMap(errorCode));
                result.success(re);
            }
        });
    }

    private void disconnect(MethodCall methodCall, final Result result) {
        RongIMClient.getInstance().disconnect();
    }

    private void logout(MethodCall methodCall, final Result result) {
        RongIMClient.getInstance().logout();
    }

    private void clearMessages(MethodCall methodCall, final Result result) {
        String targetId = methodCall.argument("targetId");
        int conversationType = methodCall.argument("conversationType");
        RongIMClient.getInstance().clearMessages(ConversationType.setValue(conversationType), targetId, new ResultCallback<Boolean>() {
            @Override
            public void onSuccess(Boolean aBoolean) {
                Map<String, Object> re = new HashMap<>();
                re.put("isSuccess", true);
                re.put("callbackType", "onSuccess");
                re.put("result", aBoolean);
                result.success(re);
            }

            @Override
            public void onError(ErrorCode errorCode) {
                Map<String, Object> re = new HashMap<>();
                re.put("isSuccess", false);
                re.put("callbackType", "onError");
                re.put("result", false);
                re.put("errorCode", errorCodeToMap(errorCode));
                result.success(re);
            }
        });
    }

    private void deleteMessages(MethodCall methodCall, final Result result) {
        if (methodCall.hasArgument("targetId")) {
            String targetId = methodCall.argument("targetId");
            int conversationType = methodCall.argument("conversationType");
            RongIMClient.getInstance().deleteMessages(ConversationType.setValue(conversationType), targetId, new ResultCallback<Boolean>() {
                @Override
                public void onSuccess(Boolean aBoolean) {
                    Map<String, Object> re = new HashMap<>();
                    re.put("isSuccess", true);
                    re.put("callbackType", "onSuccess");
                    re.put("result", aBoolean);
                    result.success(re);
                }

                @Override
                public void onError(ErrorCode errorCode) {
                    Map<String, Object> re = new HashMap<>();
                    re.put("isSuccess", false);
                    re.put("callbackType", "onError");
                    re.put("result", false);
                    re.put("errorCode", errorCodeToMap(errorCode));
                    result.success(re);
                }
            });
        } else {
            int[] messageIds = methodCall.argument("messageIds");
            RongIMClient.getInstance().deleteMessages(messageIds, new ResultCallback<Boolean>() {
                @Override
                public void onSuccess(Boolean aBoolean) {
                    Map<String, Object> re = new HashMap<>();
                    re.put("isSuccess", true);
                    re.put("callbackType", "onSuccess");
                    re.put("result", aBoolean);
                    result.success(re);
                }

                @Override
                public void onError(ErrorCode errorCode) {
                    Map<String, Object> re = new HashMap<>();
                    re.put("isSuccess", false);
                    re.put("callbackType", "onError");
                    re.put("result", false);
                    re.put("errorCode", errorCodeToMap(errorCode));
                    result.success(re);
                }
            });
        }
    }

    private void getHistoryMessages(MethodCall methodCall, final Result result) {
        String targetId = methodCall.argument("targetId");
        int conversationType = methodCall.argument("conversationType");
        int oldestMessageId = methodCall.argument("oldestMessageId");
        int count = methodCall.argument("count");
        RongIMClient.getInstance().getHistoryMessages(ConversationType.setValue(conversationType), targetId, oldestMessageId, count, new ResultCallback<List<Message>>() {
            @Override
            public void onSuccess(List<Message> messages) {
                List<Map<String, Object>> list = new ArrayList<>();
                if (messages != null && messages.size() != 0) {
                    for (Message message : messages) {
                        Map<String, Object> map = messageToMap(message);
                        list.add(map);
                    }
                }
                Map<String, Object> re = new HashMap<>();
                re.put("isSuccess", true);
                re.put("callbackType", "onSuccess");
                re.put("result", list);
                result.success(re);
            }

            @Override
            public void onError(ErrorCode errorCode) {
                Map<String, Object> re = new HashMap<>();
                re.put("isSuccess", false);
                re.put("callbackType", "onError");
                re.put("result", false);
                re.put("errorCode", errorCodeToMap(errorCode));
                result.success(re);
            }
        });
    }

    private void clearMessagesUnreadStatus(MethodCall methodCall, final Result result) {
        int conversationType = methodCall.argument("conversationType");
        String targetId = methodCall.argument("targetId");
        if (methodCall.hasArgument("timestamp")) {
            Long timestamp = methodCall.argument("timestamp");
            RongIMClient.getInstance().clearMessagesUnreadStatus(ConversationType.setValue(conversationType), targetId, timestamp, new OperationCallback() {
                @Override
                public void onSuccess() {
                    Map<String, Object> re = new HashMap<>();
                    re.put("isSuccess", true);
                    re.put("callbackType", "onSuccess");
                    re.put("result", true);
                    result.success(re);
                }

                @Override
                public void onError(ErrorCode errorCode) {
                    Map<String, Object> re = new HashMap<>();
                    re.put("isSuccess", false);
                    re.put("callbackType", "onError");
                    re.put("result", false);
                    re.put("errorCode", errorCodeToMap(errorCode));
                    result.success(re);
                }
            });
        } else {
            RongIMClient.getInstance().clearMessagesUnreadStatus(ConversationType.setValue(conversationType), targetId, new ResultCallback<Boolean>() {
                @Override
                public void onSuccess(Boolean aBoolean) {
                    Map<String, Object> re = new HashMap<>();
                    re.put("isSuccess", true);
                    re.put("callbackType", "onSuccess");
                    re.put("result", aBoolean);
                    result.success(re);
                }

                @Override
                public void onError(ErrorCode errorCode) {
                    Map<String, Object> re = new HashMap<>();
                    re.put("isSuccess", false);
                    re.put("callbackType", "onError");
                    re.put("result", false);
                    re.put("errorCode", errorCodeToMap(errorCode));
                    result.success(re);
                }
            });
        }
    }

    private void setMessageReceivedStatus(MethodCall methodCall, final Result result) {
        int messageId = methodCall.argument("messageId");
        int receivedStatus = methodCall.argument("receivedStatus");
        RongIMClient.getInstance().setMessageReceivedStatus(messageId, new Message.ReceivedStatus(receivedStatus), new ResultCallback<Boolean>() {
            @Override
            public void onSuccess(Boolean aBoolean) {
                Map<String, Object> re = new HashMap<>();
                re.put("isSuccess", true);
                re.put("callbackType", "onSuccess");
                re.put("result", aBoolean);
                result.success(re);
            }

            @Override
            public void onError(ErrorCode errorCode) {
                Map<String, Object> re = new HashMap<>();
                re.put("isSuccess", false);
                re.put("callbackType", "onError");
                re.put("result", false);
                re.put("errorCode", errorCodeToMap(errorCode));
                result.success(re);
            }
        });
    }

    private void getConversation(MethodCall methodCall, final Result result) {
        int conversationType = methodCall.argument("conversationType");
        String targetId = methodCall.argument("targetId");
        RongIMClient.getInstance().getConversation(ConversationType.setValue(conversationType), targetId, new ResultCallback<Conversation>() {
            @Override
            public void onSuccess(Conversation conversation) {
                Map<String, Object> re = new HashMap<>();
                re.put("isSuccess", true);
                re.put("callbackType", "onSuccess");
                // TODO
                re.put("result", conversation);
                result.success(re);
            }

            @Override
            public void onError(ErrorCode errorCode) {
                Map<String, Object> re = new HashMap<>();
                re.put("isSuccess", false);
                re.put("callbackType", "onError");
                re.put("result", false);
                re.put("errorCode", errorCodeToMap(errorCode));
                result.success(re);
            }
        });
    }

    private void getConversationList(MethodCall methodCall, final Result result) {
        List<Integer> conversationTypes1 = methodCall.argument("conversationTypes");
        ConversationType[] conversationTypes2 = convertConversationTypes(conversationTypes1);
        RongIMClient.getInstance().getConversationList(new ResultCallback<List<Conversation>>() {
            @Override
            public void onSuccess(List<Conversation> conversations) {
                Map<String, Object> re = new HashMap<>();
                re.put("isSuccess", true);
                re.put("callbackType", "onSuccess");
                // TODO
                re.put("result", conversations);
                result.success(re);
            }

            @Override
            public void onError(ErrorCode errorCode) {
                Map<String, Object> re = new HashMap<>();
                re.put("isSuccess", false);
                re.put("callbackType", "onError");
                re.put("result", false);
                re.put("errorCode", errorCodeToMap(errorCode));
                result.success(re);
            }
        }, conversationTypes2);
    }

    private void getConversationListByPage(MethodCall methodCall, final Result result) {
        List<Integer> conversationTypes1 = methodCall.argument("conversationTypes");
        ConversationType[] conversationTypes2 = convertConversationTypes(conversationTypes1);
        long timeStamp = methodCall.argument("timeStamp");
        int count = methodCall.argument("count");
        RongIMClient.getInstance().getConversationListByPage(new ResultCallback<List<Conversation>>() {
            @Override
            public void onSuccess(List<Conversation> conversations) {
                Map<String, Object> re = new HashMap<>();
                re.put("isSuccess", true);
                re.put("callbackType", "onSuccess");
                // TODO
                re.put("result", conversations);
                result.success(re);
            }

            @Override
            public void onError(ErrorCode errorCode) {
                Map<String, Object> re = new HashMap<>();
                re.put("isSuccess", false);
                re.put("callbackType", "onError");
                re.put("result", false);
                re.put("errorCode", errorCodeToMap(errorCode));
                result.success(re);
            }
        }, timeStamp, count, conversationTypes2);
    }

    private void removeConversation(MethodCall methodCall, final Result result) {
        int conversationType = methodCall.argument("conversationType");
        String targetId = methodCall.argument("targetId");
        RongIMClient.getInstance().removeConversation(ConversationType.setValue(conversationType), targetId, new ResultCallback<Boolean>() {
            @Override
            public void onSuccess(Boolean aBoolean) {
                Map<String, Object> re = new HashMap<>();
                re.put("isSuccess", true);
                re.put("callbackType", "onSuccess");
                re.put("result", aBoolean);
                result.success(re);
            }

            @Override
            public void onError(ErrorCode errorCode) {
                Map<String, Object> re = new HashMap<>();
                re.put("isSuccess", false);
                re.put("callbackType", "onError");
                re.put("result", false);
                re.put("errorCode", errorCodeToMap(errorCode));
                result.success(re);
            }
        });
    }

    private void getConversationNotificationStatus(MethodCall methodCall, final Result result) {
        String targetId = methodCall.argument("targetId");
        int conversationType = methodCall.argument("conversationType");
        RongIMClient.getInstance().getConversationNotificationStatus(ConversationType.setValue(conversationType), targetId, new ResultCallback<Conversation.ConversationNotificationStatus>() {
            @Override
            public void onSuccess(Conversation.ConversationNotificationStatus conversationNotificationStatus) {
                Map<String, Object> re = new HashMap<>();
                re.put("isSuccess", true);
                re.put("callbackType", "onSuccess");
                re.put("result", conversationNotificationStatus.getValue());
                result.success(re);
            }

            @Override
            public void onError(ErrorCode errorCode) {
                Map<String, Object> re = new HashMap<>();
                re.put("isSuccess", false);
                re.put("callbackType", "onError");
                re.put("result", false);
                re.put("errorCode", errorCodeToMap(errorCode));
                result.success(re);
            }
        });
    }

    private void setConversationNotificationStatus(MethodCall methodCall, final Result result) {
        String targetId = methodCall.argument("targetId");
        int conversationType = methodCall.argument("conversationType");
        int notificationStatus = methodCall.argument("notificationStatus");
        RongIMClient.getInstance().setConversationNotificationStatus(ConversationType.setValue(conversationType), targetId, Conversation.ConversationNotificationStatus.setValue(notificationStatus), new ResultCallback<Conversation.ConversationNotificationStatus>() {
            @Override
            public void onSuccess(Conversation.ConversationNotificationStatus conversationNotificationStatus) {
                Map<String, Object> re = new HashMap<>();
                re.put("isSuccess", true);
                re.put("callbackType", "onSuccess");
                re.put("result", conversationNotificationStatus.getValue());
                result.success(re);
            }

            @Override
            public void onError(ErrorCode errorCode) {
                Map<String, Object> re = new HashMap<>();
                re.put("isSuccess", false);
                re.put("callbackType", "onError");
                re.put("result", false);
                re.put("errorCode", errorCodeToMap(errorCode));
                result.success(re);
            }
        });
    }

    private void setNotificationQuietHours(MethodCall methodCall, final Result result) {
        String startTime = methodCall.argument("startTime");
        int spanMinutes = methodCall.argument("spanMinutes");
        RongIMClient.getInstance().setNotificationQuietHours(startTime, spanMinutes, new OperationCallback() {
            @Override
            public void onSuccess() {
                Map<String, Object> re = new HashMap<>();
                re.put("isSuccess", true);
                re.put("callbackType", "onSuccess");
                re.put("result", true);
                result.success(re);
            }

            @Override
            public void onError(ErrorCode errorCode) {
                Map<String, Object> re = new HashMap<>();
                re.put("isSuccess", false);
                re.put("callbackType", "onError");
                re.put("result", false);
                re.put("errorCode", errorCodeToMap(errorCode));
                result.success(re);
            }
        });
    }

    private void removeNotificationQuietHours(MethodCall methodCall, final Result result) {
        RongIMClient.getInstance().removeNotificationQuietHours(new OperationCallback() {
            @Override
            public void onSuccess() {
                Map<String, Object> re = new HashMap<>();
                re.put("isSuccess", true);
                re.put("callbackType", "onSuccess");
                re.put("result", true);
                result.success(re);
            }

            @Override
            public void onError(ErrorCode errorCode) {
                Map<String, Object> re = new HashMap<>();
                re.put("isSuccess", false);
                re.put("callbackType", "onError");
                re.put("result", false);
                re.put("errorCode", errorCodeToMap(errorCode));
                result.success(re);
            }
        });
    }

    private void saveTextMessageDraft(MethodCall methodCall, final Result result) {
        String targetId = methodCall.argument("targetId");
        int conversationType = methodCall.argument("conversationType");
        String content = methodCall.argument("content");
        RongIMClient.getInstance().saveTextMessageDraft(ConversationType.setValue(conversationType), targetId, content, new ResultCallback<Boolean>() {
            @Override
            public void onSuccess(Boolean aBoolean) {
                Map<String, Object> re = new HashMap<>();
                re.put("isSuccess", true);
                re.put("callbackType", "onSuccess");
                re.put("result", aBoolean);
                result.success(re);
            }

            @Override
            public void onError(ErrorCode errorCode) {
                Map<String, Object> re = new HashMap<>();
                re.put("isSuccess", false);
                re.put("callbackType", "onError");
                re.put("result", false);
                re.put("errorCode", errorCodeToMap(errorCode));
                result.success(re);
            }
        });
    }

    private void getTextMessageDraft(MethodCall methodCall, final Result result) {
        String targetId = methodCall.argument("targetId");
        int conversationType = methodCall.argument("conversationType");
        RongIMClient.getInstance().getTextMessageDraft(ConversationType.setValue(conversationType), targetId, new ResultCallback<String>() {
            @Override
            public void onSuccess(String s) {
                Map<String, Object> re = new HashMap<>();
                re.put("isSuccess", true);
                re.put("callbackType", "onSuccess");
                re.put("result", s);
                result.success(re);
            }

            @Override
            public void onError(ErrorCode errorCode) {
                Map<String, Object> re = new HashMap<>();
                re.put("isSuccess", false);
                re.put("callbackType", "onError");
                re.put("result", false);
                re.put("errorCode", errorCodeToMap(errorCode));
                result.success(re);
            }
        });
    }

    private void setConversationToTop(MethodCall methodCall, final Result result) {
        int conversationType = methodCall.argument("conversationType");
        String id = methodCall.argument("id");
        boolean isTop = methodCall.argument("isTop");
        boolean needCreate = methodCall.argument("needCreate");
        RongIMClient.getInstance().setConversationToTop(ConversationType.setValue(conversationType), id, isTop, needCreate, new ResultCallback<Boolean>() {
            @Override
            public void onSuccess(Boolean aBoolean) {
                Map<String, Object> re = new HashMap<>();
                re.put("isSuccess", true);
                re.put("callbackType", "onSuccess");
                re.put("result", aBoolean);
                result.success(re);
            }

            @Override
            public void onError(ErrorCode errorCode) {
                Map<String, Object> re = new HashMap<>();
                re.put("isSuccess", false);
                re.put("callbackType", "onError");
                re.put("result", false);
                re.put("errorCode", errorCodeToMap(errorCode));
                result.success(re);
            }
        });
    }

    private void getTotalUnreadCount(MethodCall methodCall, final Result result) {
        RongIMClient.getInstance().getTotalUnreadCount(new ResultCallback<Integer>() {
            @Override
            public void onSuccess(Integer integer) {
                Map<String, Object> re = new HashMap<>();
                re.put("isSuccess", true);
                re.put("callbackType", "onSuccess");
                re.put("result", integer);
                result.success(re);
            }

            @Override
            public void onError(ErrorCode errorCode) {
                Map<String, Object> re = new HashMap<>();
                re.put("isSuccess", false);
                re.put("callbackType", "onError");
                re.put("result", false);
                re.put("errorCode", errorCodeToMap(errorCode));
                result.success(re);
            }
        });
    }

    private void getUnreadCount(MethodCall methodCall, final Result result) {
        if (methodCall.hasArgument("targetId")) {
            int conversationType = methodCall.argument("conversationType");
            String targetId = methodCall.argument("targetId");
            RongIMClient.getInstance().getUnreadCount(ConversationType.setValue(conversationType), targetId, new ResultCallback<Integer>() {
                @Override
                public void onSuccess(Integer integer) {
                    Map<String, Object> re = new HashMap<>();
                    re.put("isSuccess", true);
                    re.put("callbackType", "onSuccess");
                    re.put("result", integer);
                    result.success(re);
                }

                @Override
                public void onError(ErrorCode errorCode) {
                    Map<String, Object> re = new HashMap<>();
                    re.put("isSuccess", false);
                    re.put("callbackType", "onError");
                    re.put("result", false);
                    re.put("errorCode", errorCodeToMap(errorCode));
                    result.success(re);
                }
            });
        } else {
            List<Integer> conversationTypes = methodCall.argument("conversationTypes");
            RongIMClient.getInstance().getUnreadCount(new ResultCallback<Integer>() {
                @Override
                public void onSuccess(Integer integer) {
                    Map<String, Object> re = new HashMap<>();
                    re.put("isSuccess", true);
                    re.put("callbackType", "onSuccess");
                    re.put("result", integer);
                    result.success(re);
                }

                @Override
                public void onError(ErrorCode errorCode) {
                    Map<String, Object> re = new HashMap<>();
                    re.put("isSuccess", false);
                    re.put("callbackType", "onError");
                    re.put("result", false);
                    re.put("errorCode", errorCodeToMap(errorCode));
                    result.success(re);
                }
            }, convertConversationTypes(conversationTypes));
        }
    }

    private void sendTypingStatus(MethodCall methodCall, final Result result) {
        int conversationType = methodCall.argument("conversationType");
        String targetId = methodCall.argument("targetId");
        String typingContentType = methodCall.argument("typingContentType");
        RongIMClient.getInstance().sendTypingStatus(ConversationType.setValue(conversationType), targetId, typingContentType);
    }

    @Override
    public void onListen(Object arguments, final EventChannel.EventSink eventSink) {
        Log.i(TAG, "onListen");
        switch ((String) argument(arguments, "method")) {
            case "sendMessage":
                sendMessage(arguments, eventSink);
                break;
            case "sendLocationMessage":
                sendLocationMessage(arguments, eventSink);
                break;
            case "sendImageMessage":
                sendImageMessage(arguments, eventSink);
                break;
            case "sendMediaMessage":
                sendMediaMessage(arguments, eventSink);
                break;
            case "setOnReceiveMessageListener":
                setOnReceiveMessageListener(arguments, eventSink);
                break;
            case "setConnectionStatusListener":
                setConnectionStatusListener(arguments, eventSink);
                break;
            case "setTypingStatusListener":
                setTypingStatusListener(arguments, eventSink);
                break;
            case "setRCLogInfoListener":
                setRCLogInfoListener(arguments, eventSink);
                break;
        }
    }

    @Override
    public void onCancel(Object arguments) {

    }

    private void sendMessage(Object arguments, final EventChannel.EventSink eventSink) {
        String targetId = (String) argument(arguments, "targetId");
        String pushContent = (String) argument(arguments, "pushContent");
        String pushData = (String) argument(arguments, "pushData");
        int conversationType = (int) argument(arguments, "conversationType");

        Map<String, Object> content = (Map<String, Object>) argument(arguments, "content");
        String text = (String) content.get("content");
        TextMessage myTextMessage = TextMessage.obtain(text);
        Message myMessage = Message.obtain(targetId, ConversationType.setValue(conversationType), myTextMessage);
        RongIMClient.getInstance().sendMessage(myMessage, pushContent, pushData, new IRongCallback.ISendMessageCallback() {
            @Override
            public void onAttached(Message message) {
                Log.i(TAG, "onAttached");
                Map<String, Object> re = new HashMap<>();
                re.put("callbackType", "onAttached");
                re.put("result", messageToMap(message));
                eventSink.success(re);
            }

            @Override
            public void onSuccess(Message message) {
                Log.i(TAG, "onSuccess");
                Map<String, Object> re = new HashMap<>();
                re.put("isSuccess", true);
                re.put("callbackType", "onSuccess");
                re.put("result", messageToMap(message));
                eventSink.success(re);
            }

            @Override
            public void onError(Message message, ErrorCode errorCode) {
                Log.i(TAG, "onError");
                Map<String, Object> re = new HashMap<>();
                re.put("callbackType", "onError");
                re.put("result", messageToMap(message));
                re.put("errorCode", errorCodeToMap(errorCode));
                eventSink.success(re);
            }
        });
    }


    private void sendLocationMessage(Object arguments, final EventChannel.EventSink eventSink) {
        String targetId = (String) argument(arguments, "targetId");
        String pushContent = (String) argument(arguments, "pushContent");
        String pushData = (String) argument(arguments, "pushData");
        int conversationType = (int) argument(arguments, "conversationType");

        Map<String, Object> content = (Map<String, Object>) argument(arguments, "content");
        double lat = (double) content.get("lat");
        double lng = (double) content.get("lng");
        String poi = (String) content.get("poi");
        Uri imgUri = Uri.parse((String) content.get("imgUri"));
        LocationMessage locationMessage = LocationMessage.obtain(lat, lng, poi, imgUri);
        Message myMessage2 = Message.obtain(targetId, ConversationType.setValue(conversationType), locationMessage);
        RongIMClient.getInstance().sendLocationMessage(myMessage2, pushContent, pushData, new IRongCallback.ISendMessageCallback() {
            @Override
            public void onAttached(Message message) {
                Log.i(TAG, "onAttached");
                Map<String, Object> re = new HashMap<>();
                re.put("callbackType", "onAttached");
                re.put("result", messageToMap(message));
                eventSink.success(re);
            }

            @Override
            public void onSuccess(Message message) {
                Log.i(TAG, "onSuccess");
                Map<String, Object> re = new HashMap<>();
                re.put("callbackType", "onSuccess");
                re.put("result", messageToMap(message));
                eventSink.success(re);
            }

            @Override
            public void onError(Message message, ErrorCode errorCode) {
                Log.i(TAG, "onError");
                Map<String, Object> re = new HashMap<>();
                re.put("callbackType", "onError");
                re.put("result", messageToMap(message));
                re.put("errorCode", errorCodeToMap(errorCode));
                eventSink.success(re);
            }
        });
    }

    private void sendImageMessage(Object arguments, final EventChannel.EventSink eventSink) {
        String targetId = (String) argument(arguments, "targetId");
        String pushContent = (String) argument(arguments, "pushContent");
        String pushData = (String) argument(arguments, "pushData");
        int conversationType = (int) argument(arguments, "conversationType");

        Map<String, Object> content = (Map<String, Object>) argument(arguments, "content");
        Log.i(TAG, "content:" + content.toString());
        boolean isFull = (boolean) content.get("isFull");
        Uri thumbUri = Uri.parse((String) content.get("thumbUri"));
        Uri localUri = Uri.parse((String) content.get("localUri"));
        ImageMessage imageMessage = ImageMessage.obtain(thumbUri, localUri, isFull);
        Message myMessage3 = Message.obtain(targetId, ConversationType.setValue(conversationType), imageMessage);
        RongIMClient.getInstance().sendImageMessage(myMessage3, pushContent, pushData, new SendImageMessageCallback() {
            @Override
            public void onAttached(Message message) {
                Log.i(TAG, "onAttached");
                Map<String, Object> re = new HashMap<>();
                re.put("callbackType", "onAttached");
                re.put("result", messageToMap(message));
                eventSink.success(re);
            }

            @Override
            public void onSuccess(Message message) {
                Log.i(TAG, "onSuccess");
                Map<String, Object> re = new HashMap<>();
                re.put("callbackType", "onSuccess");
                re.put("result", messageToMap(message));
                eventSink.success(re);
            }

            @Override
            public void onError(Message message, ErrorCode errorCode) {
                Log.i(TAG, "onError");
                Map<String, Object> re = new HashMap<>();
                re.put("callbackType", "onError");
                re.put("result", messageToMap(message));
                re.put("errorCode", errorCodeToMap(errorCode));
                eventSink.success(re);
            }

            @Override
            public void onProgress(Message message, int i) {
                Log.i(TAG, "onProgress");
                Map<String, Object> re = new HashMap<>();
                re.put("callbackType", "onError");
                re.put("result", messageToMap(message));
                re.put("progress", i);
                eventSink.success(re);
            }
        });
    }

    private void sendMediaMessage(Object arguments, final EventChannel.EventSink eventSink) {
        String targetId = (String) argument(arguments, "targetId");
        String pushContent = (String) argument(arguments, "pushContent");
        String pushData = (String) argument(arguments, "pushData");
        int conversationType = (int) argument(arguments, "conversationType");

        Map<String, Object> content = (Map<String, Object>) argument(arguments, "content");
        Log.i(TAG, "content:" + content.toString());
        Uri localUri = Uri.parse((String) content.get("localUri"));

        FileMessage fileMessage = FileMessage.obtain(localUri);
        Message message4 = Message.obtain(targetId, ConversationType.setValue(conversationType), fileMessage);
        RongIMClient.getInstance().sendMediaMessage(message4, pushContent, pushData, new IRongCallback.ISendMediaMessageCallback() {
            @Override
            public void onAttached(Message message) {
                Log.i(TAG, "onAttached");
                Map<String, Object> re = new HashMap<>();
                re.put("callbackType", "onAttached");
                re.put("result", messageToMap(message));
                eventSink.success(re);
            }

            @Override
            public void onSuccess(Message message) {
                Log.i(TAG, "onSuccess");
                Map<String, Object> re = new HashMap<>();
                re.put("callbackType", "onSuccess");
                re.put("result", messageToMap(message));
                eventSink.success(re);
            }

            @Override
            public void onError(Message message, ErrorCode errorCode) {
                Log.i(TAG, "onError");
                Map<String, Object> re = new HashMap<>();
                re.put("callbackType", "onError");
                re.put("result", messageToMap(message));
                re.put("errorCode", errorCodeToMap(errorCode));
                eventSink.success(re);
            }

            @Override
            public void onProgress(Message message, int i) {
                Log.i(TAG, "onProgress");
                Map<String, Object> re = new HashMap<>();
                re.put("callbackType", "onError");
                re.put("result", messageToMap(message));
                re.put("progress", i);
                eventSink.success(re);
            }

            @Override
            public void onCanceled(Message message) {
                Log.i(TAG, "onCanceled");
                Map<String, Object> re = new HashMap<>();
                re.put("callbackType", "onCanceled");
                re.put("result", messageToMap(message));
                eventSink.success(re);
            }
        });
    }

    private void setOnReceiveMessageListener(Object arguments, final EventChannel.EventSink eventSink) {
        RongIMClient.setOnReceiveMessageListener(new RongIMClient.OnReceiveMessageListener() {
            @Override
            public boolean onReceived(Message message, int i) {
                Log.i(TAG, "onReceived");
                Map<String, Object> re = new HashMap<>();
                re.put("Code", 0);
                re.put("ErrorInfo", "onReceived");
                re.put("Result", messageToMap(message));
                eventSink.success(re);
                return false;
            }
        });
    }

    private void setConnectionStatusListener(Object arguments, final EventChannel.EventSink eventSink) {
        RongIMClient.setConnectionStatusListener(new RongIMClient.ConnectionStatusListener() {
            @Override
            public void onChanged(ConnectionStatus connectionStatus) {
                Log.i(TAG, "onChanged");
                Map<String, Object> re = new HashMap<>();
                re.put("Code", 0);
                re.put("ErrorInfo", "onReceived");
                re.put("Result", connectionStatus.getValue());
                eventSink.success(re);
            }
        });
    }

    private void setTypingStatusListener(Object arguments, final EventChannel.EventSink eventSink) {
        RongIMClient.setTypingStatusListener(new RongIMClient.TypingStatusListener() {
            @Override
            public void onTypingStatusChanged(ConversationType conversationType, String targetId, Collection<TypingStatus> collection) {
                Log.i(TAG, "onTypingStatusChanged");
                Map<String, Object> re = new HashMap<>();
                re.put("Code", 0);
                re.put("ErrorInfo", "onTypingStatusChanged");
                Map<String, Object> result = new HashMap<>();
                result.put("conversationType", conversationType.getValue());
                result.put("targetId", targetId);
                Set<Map<String, Object>> typingStatusSet = new HashSet<>();
                for (TypingStatus typingStatus : collection) {
                    Map<String, Object> statusMap = new HashMap<>();
                    statusMap.put("sentTime", typingStatus.getSentTime());
                    statusMap.put("typingContentType", typingStatus.getTypingContentType());
                    statusMap.put("userId", typingStatus.getUserId());
                    typingStatusSet.add(statusMap);
                }
                result.put("typingStatusSet", typingStatusSet);
                re.put("Result", result);
                eventSink.success(re);
            }
        });
    }

    private void setRCLogInfoListener(Object arguments, final EventChannel.EventSink eventSink) {
        RongIMClient.setRCLogInfoListener(new RongIMClient.RCLogInfoListener() {
            @Override
            public void onRCLogInfoOccurred(String s) {
                Map<String, Object> re = new HashMap<>();
                re.put("Code", 0);
                re.put("ErrorInfo", "onRCLogInfoOccurred");
                re.put("Result", s);
                eventSink.success(re);
            }
        });
    }
}
