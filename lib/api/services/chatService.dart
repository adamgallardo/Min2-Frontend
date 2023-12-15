import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as io;

class ChatService {
  static const String _baseUrl = 'http://localhost:9191';

  late io.Socket _socket;

  void initSocket() {
    _socket = io.io(_baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket.connect();
    _socket.onConnect((_) => print('frontend conected'));
  }

  void joinChat(String userId, String groupName) {
    _socket.emit('join', {'userId': userId, 'groupName': groupName});
  }

  void sendMessage(String subject, String message, String userId) {
    _socket.emit('chatMessage', {
      'subject': subject,
      'message': message,
      'userId': userId,
    });
  }

  void receiveMessage(void Function(String) onMessageReceived) {
    _socket.on('chatMessage', (data) {
      onMessageReceived(data['message']);
    });
  }
}
