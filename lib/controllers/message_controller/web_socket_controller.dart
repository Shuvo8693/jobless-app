
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_rx/src/rx_workers/rx_workers.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:jobless/helpers/prefs_helpers.dart';
import 'package:jobless/service/api_constants.dart';
import 'package:jobless/views/screen/Message/model/get_message_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'dart:convert';

class WebSocketController extends GetxController {
  Rx<GetMessageModel> getMessageModel= GetMessageModel().obs;
  RxList<MessageData> messageData= <MessageData>[].obs;
  late IO.Socket _socket;
  RxString chatId = ''.obs;
  final ChatService _chatService = ChatService();

  @override
  void onInit() {
    super.onInit();
    initSocket();
    debounce(chatId, (_) => fetchAndListenToChatHistory(), time: Duration(milliseconds: 300));
  }

  void initSocket() {
    _socket = IO.io(
      ApiConstants.socketUrl,
      IO.OptionBuilder().setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );
    _socket.connect();

    _socket.onConnect((_) {
      print('====Connected to server=====');
      if (chatId.value.isNotEmpty) {
        listenToNewMessages(chatId.value);
      }
    });

    _socket.onDisconnect((_) {
      print('====Disconnected from server====');
    } );
  }
  /// Listen_Existing_message
  Future<void> fetchAndListenToChatHistory() async {

    if (chatId.value.isEmpty) return;

    try {
      messageData.clear();
      List<MessageData> fetchedMessages = await _chatService.fetchChatHistory(chatId.value);

      messageData.assignAll(fetchedMessages);
      listenToNewMessages(chatId.value);
    } catch (e) {
      print("Error fetching chat history: $e");
    }
  }

  /// Listen_New_message
  void listenToNewMessages(String chatId) {
    _socket.off('new-message::$chatId'); // Unsubscribe from any previous listeners
    _socket.on('new-message::$chatId', _handleNewMessage); // Listen to the new chatId
  }

  void _handleNewMessage(dynamic data) {
    MessageData messageDataResponse = MessageData();
    if (data != null && data['content'] != null) {
      messageDataResponse = MessageData.fromJson(data);
      messageData.add(messageDataResponse);
    } else {
      print("Received invalid message data: $data");
    }
  }

  @override
  void onClose() {
    _socket.dispose();
    messageData.clear();
    super.onClose();
  }

}





/// fetch_chat_history
class ChatService {
  GetMessageModel getMessageModel= GetMessageModel();

  Future<List<MessageData>> fetchChatHistory(String chatId) async {
    String token = await PrefsHelper.getString('token');
    Map<String, String> headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(Uri.parse(ApiConstants.getMessageUrl(chatId)),headers: headers);

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      getMessageModel= GetMessageModel.fromJson(decodedData);
      /*for (var item in data['data']['attributes']['data']) {
        messages.add({
          'chatId': item['chatId'],
          'messageType': item['content']['messageType'],
          'content': item['content']['message'],
          'senderId': item['senderId']['id'],
          'id': item['id'],
        });
      }*/
      return getMessageModel.getMessageData?.getMessageAttributes?.messageData??[];
    } else {
      throw Exception("Failed to load chat history");
    }
  }
}

