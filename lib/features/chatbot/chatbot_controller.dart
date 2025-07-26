import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:http/http.dart' as http;


class ChatBotController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;
  RxString res = "".obs;
  Timer? _typingTimer;
  final RxBool _isTyping = false.obs;

  bool get isTyping => _isTyping.value;

  @override
  void onInit() {
    super.onInit();
  }





  void sendMessage() {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    textController.clear();
    sendChat(text);
  }

  Future<void> sendChat(String text) async {
    messages.insert(0, ChatMessage(text: text, isUser: true));

    // Show typing indicator
    _isTyping.value = true;
    _typingTimer?.cancel();
    _typingTimer = Timer(Duration(seconds: 2), () {
      _isTyping.value = false;
    });

    await _getBotResponse(text);
    _isTyping.value = false;
    _typingTimer?.cancel();

    final response = res.value;
    messages.insert(0, ChatMessage(text: response, isUser: false));
  }


  Future<String> _getBotResponse(String userInput) async {
    isLoading.value = true;
    try {
      String apiUrl = "https://kissanapi.onrender.com/ask";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"query": userInput}),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        res.value = data["response"] as String;
        return data["response"] ?? "I couldn't understand. Please ask again.";
      } else {
        throw Exception("Failed to get response: ${response.statusCode}");
      }
    } catch (e) {
      return "Sorry, I'm having trouble connecting. Please try again later.";
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _typingTimer?.cancel();
    textController.dispose();
    super.onClose();
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}