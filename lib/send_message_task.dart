part of flutter_rongim;

class SendMessageTask {

  final FlutterRongim _rongim;
  final String _method;

  bool isAttached = false;
  bool isInProgress = false;
  bool isSuccessful = false;
  bool isCanceled = false;
  bool isError = false;
  bool isComplete = false;

  String status;

  SendMessageTask(this._rongim, this._method);

  int _handle;

  Completer<ResultCallback<Message>> _completer = Completer<
      ResultCallback<Message>>();

  Future<ResultCallback<Message>> get onComplete => _completer.future;

  StreamController<ResultCallback<Message>> _controller =
  new StreamController<ResultCallback<Message>>.broadcast();

  Stream<ResultCallback<Message>> get events => _controller.stream;

  Future<SendMessageTask> _start(Message message) async {
    _handle = await _platformStart(message);
    await _rongim._methodStream.where((MethodCall m) {
      return m.method == 'SendMessage' && m.arguments['handle'] == _handle;
    }).map<ResultCallback<Message>>((MethodCall m) {
      final Map<dynamic, dynamic> json = m.arguments['result'];
      ResultCallback<Message> callback = new ResultCallback<Message>.fromJson(
          json);
      _changeState(callback);
      _controller.add(callback);
      return callback;
    }).firstWhere((ResultCallback<Message> callback) =>
    callback.callbackType == "onError" ||
        callback.callbackType == "onCanceled" ||
        callback.callbackType == "onSuccess");
    return this;
  }

  Future<int> _platformStart(Message message) async {
    Map<String, dynamic> arguments = message.toMap();

    Completer<ResultCallback<Message>> _completer = Completer<
        ResultCallback<Message>>();

    int handle = await FlutterRongim._channel_send_message.invokeMethod(
        _method, arguments);

    return handle;
  }

  void _changeState(ResultCallback<Message> callback) {
    _resetState();
    status = callback.callbackType;
    switch (callback.callbackType) {
      case "onAttached":
        isAttached = true;
        break;
      case "onProgress":
        isInProgress = true;
        break;
      case "onError":
        isError = true;
        isComplete = true;
        break;
      case "onCanceled":
        isComplete = true;
        isCanceled = true;
        break;
      case "onSuccess":
        isComplete = true;
        isSuccessful = true;
        break;
    }
  }

  void _resetState() {
    isAttached = false;
    isInProgress = false;
    isComplete = false;
    isCanceled = false;
    isError = false;
    isSuccessful = false;
  }
}