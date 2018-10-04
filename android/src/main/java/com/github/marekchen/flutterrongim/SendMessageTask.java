package com.github.marekchen.flutterrongim;

import android.util.Log;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;
import io.rong.imlib.IRongCallback;
import io.rong.imlib.RongIMClient;
import io.rong.imlib.model.Message;

import static com.github.marekchen.flutterrongim.Utils.errorCodeToMap;
import static com.github.marekchen.flutterrongim.Utils.messageToMap;

class SendMessageTaskCallback extends RongIMClient.SendImageMessageCallback implements IRongCallback.ISendMediaMessageCallback, IRongCallback.ISendMessageCallback {

    private final static String TAG = "FlutterRongimPlugin";

    int handle;
    MethodChannel channel;

    SendMessageTaskCallback(int handle, MethodChannel channel) {
        this.handle = handle;
        this.channel = channel;
    }

    @Override
    public void onAttached(Message message) {
        Log.i(TAG, "onAttached");
        Map<String, Object> re = new HashMap<>();
        re.put("isSuccess", false);
        re.put("callbackType", "onAttached");
        re.put("result", messageToMap(message));
        invokeSendMessageEvent(handle, re);
    }

    @Override
    public void onSuccess(Message message) {
        Log.i(TAG, "onSuccess");
        Map<String, Object> re = new HashMap<>();
        re.put("isSuccess", true);
        re.put("callbackType", "onSuccess");
        re.put("result", messageToMap(message));
        invokeSendMessageEvent(handle, re);
    }

    @Override
    public void onError(Message message, RongIMClient.ErrorCode errorCode) {
        Log.i(TAG, "onError");
        Map<String, Object> re = new HashMap<>();
        re.put("isSuccess", false);
        re.put("callbackType", "onError");
        //re.put("result", messageToMap(message));
        re.put("errorCode", errorCodeToMap(errorCode));
        invokeSendMessageEvent(handle, re);
    }

    @Override
    public void onProgress(Message message, int progress) {
        Log.i(TAG, "onProgress");
        Map<String, Object> re = new HashMap<>();
        re.put("isSuccess", false);
        re.put("callbackType", "onError");
        re.put("result", messageToMap(message));
        re.put("progress", progress);
        invokeSendMessageEvent(handle, re);
    }

    @Override
    public void onCanceled(Message message) {
        Log.i(TAG, "onCanceled");
        Map<String, Object> re = new HashMap<>();
        re.put("isSuccess", false);
        re.put("callbackType", "onCanceled");
        re.put("result", messageToMap(message));
        invokeSendMessageEvent(handle, re);
    }

    private void invokeSendMessageEvent(int handle, Map<String, Object> result) {
        Map<String, Object> re = new HashMap<>();
        re.put("result", result);
        re.put("handle", handle);
        if (channel != null) {
            channel.invokeMethod("SendMessage", re);
        } else {
            Log.e(TAG, "channel == null");
        }
    }
}
