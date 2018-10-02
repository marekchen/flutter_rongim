package com.github.marekchen.flutterrongim;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.rong.imlib.RongIMClient;
import io.rong.imlib.model.Conversation;
import io.rong.imlib.model.Message;
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

    static Map<String, Object> messageToMap(Message message) {
        Map<String, Object> map = new HashMap<>();
        map.put("targetId", message.getTargetId());
        map.put("conversationType", message.getConversationType().getValue());
        Map<String, Object> content = null;
        switch (message.getObjectName()) {
            case "RC:TxtMsg":
                content = textMessageToMap((TextMessage) message.getContent());
                break;
            case "RC:LBSMsg":
                content = lbsMessageToMap((LocationMessage) message.getContent());
                break;
            case "RC:ImgMsg":
                content = imageMessageToMap((ImageMessage) message.getContent());
                break;
            case "RC:VcMsg":
                content = voiceMessageToMap((VoiceMessage) message.getContent());
                break;
            case "RC:FileMsg":
                content = fileMessageToMap((FileMessage) message.getContent());
                break;
            case "RC:RcNtf":
                //content = fileMessageToMap((RecallNotificationMessage) message.getContent());
                break;
        }
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

    static Map<String, Object> textMessageToMap(TextMessage message) {
        Map<String, Object> map = new HashMap<>();
        map.put("content", message.getContent());
        return map;
    }

    static Map<String, Object> lbsMessageToMap(LocationMessage message) {
        Map<String, Object> map = new HashMap<>();
        map.put("lat", message.getLat());
        map.put("lng", message.getLng());
        map.put("poi", message.getPoi());
        map.put("imgUri", message.getImgUri());
        return map;
    }

    static Map<String, Object> imageMessageToMap(ImageMessage message) {
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

    static Map<String, Object> voiceMessageToMap(VoiceMessage message) {
        Map<String, Object> map = new HashMap<>();
        map.put("duration", message.getDuration());
        if (message.getUri() != null) {
            map.put("uri", message.getUri().toString());
        }
        return map;
    }

    static Map<String, Object> fileMessageToMap(FileMessage message) {
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
