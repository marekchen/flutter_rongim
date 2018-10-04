package com.github.marekchen.flutterrongim;

import android.util.Log;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.rong.imlib.RongIMClient;
import io.rong.imlib.model.Conversation;
import io.rong.imlib.model.Message;
import io.rong.imlib.model.MessageContent;
import io.rong.message.FileMessage;
import io.rong.message.ImageMessage;
import io.rong.message.LocationMessage;
import io.rong.message.TextMessage;
import io.rong.message.VoiceMessage;

class Utils {
    static Object argument(Object arguments, String key) {
        if (arguments == null) {
            return null;
        } else if (arguments instanceof Map) {
            return ((Map) arguments).get(key);
        } else if (arguments instanceof JSONObject) {
            return ((JSONObject) arguments).opt(key);
        } else {
            throw new ClassCastException();
        }
    }

    static Map errorCodeToMap(RongIMClient.ErrorCode errorCode) {
        Map<String, Object> errorCodeMap = new HashMap<>();
        errorCodeMap.put("value", errorCode.getValue());
        errorCodeMap.put("message", errorCode.getMessage());
        return errorCodeMap;
    }

    static Conversation.ConversationType[] convertConversationTypes(List<Integer> conversationTypes) {
        List<Conversation.ConversationType> list = new ArrayList<>();
        if (conversationTypes != null && conversationTypes.size() != 0) {
            for (int conversationType : conversationTypes) {
                list.add(Conversation.ConversationType.setValue(conversationType));
            }
            return list.toArray(new Conversation.ConversationType[0]);
        } else {
            return null;
        }
    }

    static List<Map<String, Object>> conversationsToMap(List<Conversation> conversations) {
        List<Map<String, Object>> list = new ArrayList<>();
        if (conversations != null) {
            for (Conversation conversation : conversations) {
                list.add(conversationToMap(conversation));
            }
        }
        return list;
    }

    static Map<String, Object> conversationToMap(Conversation conversation) {
        Map<String, Object> map = new HashMap<>();
        map.put("targetId", conversation.getTargetId());
        map.put("conversationTitle", conversation.getConversationTitle());
        map.put("conversationType", conversation.getConversationType().getValue());
        map.put("portraitUrl", conversation.getPortraitUrl());
        map.put("unreadMessageCount", conversation.getUnreadMessageCount());
        map.put("isTop", conversation.isTop());
        map.put("receivedStatus", conversation.getReceivedStatus().getFlag());
        map.put("sentStatus", conversation.getSentStatus().getValue());
        map.put("receivedTime", conversation.getReceivedTime());
        map.put("sentTime", conversation.getSentTime());
        map.put("objectName", conversation.getObjectName());
        map.put("senderUserId", conversation.getSenderUserId());
        map.put("senderUserName", conversation.getSenderUserName());
        map.put("latestMessageId", conversation.getLatestMessageId());
        map.put("latestMessage", messageContentToMap(conversation.getObjectName(), conversation.getLatestMessage()));
        map.put("draft", conversation.getDraft());
        map.put("notificationStatus", conversation.getNotificationStatus().getValue());
        map.put("mentionedCount", conversation.getMentionedCount());
        return map;
    }

    static Map<String, Object> messageContentToMap(String objectName, MessageContent messageContent) {
        Map<String, Object> content = null;
        switch (objectName) {
            case "RC:TxtMsg":
                content = textMessageToMap((TextMessage) messageContent);
                break;
            case "RC:LBSMsg":
                content = lbsMessageToMap((LocationMessage) messageContent);
                break;
            case "RC:ImgMsg":
                content = imageMessageToMap((ImageMessage) messageContent);
                break;
            case "RC:VcMsg":
                content = voiceMessageToMap((VoiceMessage) messageContent);
                break;
            case "RC:FileMsg":
                content = fileMessageToMap((FileMessage) messageContent);
                break;
            case "RC:RcNtf":
                //content = fileMessageToMap((RecallNotificationMessage) message.getContent());
                break;
        }
        return content;
    }

    static Map<String, Object> messageToMap(Message message) {
        Map<String, Object> map = new HashMap<>();
        map.put("targetId", message.getTargetId());
        map.put("conversationType", message.getConversationType().getValue());
        Map<String, Object> content = messageContentToMap(message.getObjectName(), message.getContent());
        if (content != null) {
            map.put("content", content);
        }
        map.put("messageId", message.getMessageId());
        if (message.getSenderUserId() != null) {
            map.put("senderUserId", message.getSenderUserId());
        }
        if (message.getMessageDirection() != null) {
            map.put("messageDirection", message.getMessageDirection().getValue());
        }
        if (message.getObjectName() != null) {
            map.put("objectName", message.getObjectName());
        }
        map.put("sentTime", message.getSentTime());
        map.put("receivedTime", message.getReceivedTime());
        return map;
    }

    private static Map<String, Object> textMessageToMap(TextMessage message) {
        Map<String, Object> map = new HashMap<>();
        map.put("content", message.getContent());
        return map;
    }

    private static Map<String, Object> lbsMessageToMap(LocationMessage message) {
        Map<String, Object> map = new HashMap<>();
        map.put("lat", message.getLat());
        map.put("lng", message.getLng());
        map.put("poi", message.getPoi());
        map.put("imgUri", message.getImgUri());
        return map;
    }

    private static Map<String, Object> imageMessageToMap(ImageMessage message) {
        Map<String, Object> map = new HashMap<>();
        if (message.getMediaUrl() != null) {
            map.put("mediaUrl", message.getMediaUrl().toString());
        }
        if (message.getRemoteUri() != null) {
            map.put("remoteUri", message.getRemoteUri().toString());
        }
        if (message.getThumUri() != null) {
            map.put("thumbUri", message.getThumUri().toString());
        }
        if (message.getLocalUri() != null) {
            map.put("localUri", message.getLocalUri().toString());
        }
        map.put("isFull", message.isFull());
        return map;
    }

    private static Map<String, Object> voiceMessageToMap(VoiceMessage message) {
        Map<String, Object> map = new HashMap<>();
        map.put("duration", message.getDuration());
        if (message.getUri() != null) {
            map.put("uri", message.getUri().toString());
        }
        return map;
    }

    private static Map<String, Object> fileMessageToMap(FileMessage message) {
        Map<String, Object> map = new HashMap<>();
        if (message.getMediaUrl() != null) {
            map.put("mediaUrl", message.getMediaUrl().toString());
        }
        if (message.getLocalPath() != null) {
            map.put("localUri", message.getLocalPath().toString());
        }
        return map;
    }
}
