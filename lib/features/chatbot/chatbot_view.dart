import 'package:apple_grower/features/chatbot/chatbot_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/animation.dart';


class ChatPageView extends GetView<ChatBotController> {
  Widget _suggestionCard(String query) {
    return InkWell(
      onTap: () {
        controller.sendChat(query);
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade100, Colors.lightGreen.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Text(
            query,
            style: TextStyle(
              color: Colors.green.shade800,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        elevation: 4,
        title: Row(
          children: [
            Image.asset("assets/images/apple.png", height: 30),
            SizedBox(width: 10),
            Text(
              "Book My Load Assistant",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.green.shade50,
      body: Column(
        children: [
          Obx(
                  () => AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: (controller.messages.isEmpty)
                    ? Container(
                  key: ValueKey('welcome'),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      ScaleTransition(
                        scale: AlwaysStoppedAnimation(1.2),
                        child: Image.asset(
                          "assets/images/apple.png",
                          height: 120,
                        ),
                      ),
                      SizedBox(height: 20),
                      FadeTransition(
                        opacity: AlwaysStoppedAnimation(1),
                        child: Text(
                          "Welcome to Book My Load",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      FadeTransition(
                        opacity: AlwaysStoppedAnimation(1),
                        child: Text(
                          "Your AI assistant",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green.shade600,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      SlideTransition(
                        position: AlwaysStoppedAnimation(Offset(0, 0)),
                        child: Text(
                          "Ask Anything? Select from popular topics:",
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _suggestionCard("Ask About Aadhati"),
                          _suggestionCard("Ask About Orchards"),
                          _suggestionCard("Ask About Us"),
                          _suggestionCard("Ask About Apple Farming"),
                          _suggestionCard("Ask About Freight Forwardes"),
                          _suggestionCard("How to Find Drivers"),
                          _suggestionCard("Bidding Process"),
                          _suggestionCard("About Us"),
                        ],
                      ),
                    ],
                  ),
                )
                    : SizedBox.shrink(key: ValueKey('messages')),
              )),
          Expanded(
            child: Obx(
                  () => ListView.builder(
                reverse: true,
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  return Column(
                    crossAxisAlignment: message.isUser
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ChatBubble(
                          message: message.text,
                          isUser: message.isUser,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Obx(
                () => controller.isTyping
                ? Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "AI is typing...",
                style: TextStyle(
                  color: Colors.green.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
                : SizedBox(),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              elevation: 4,
              child: Container(
                constraints: BoxConstraints(maxWidth: 700),
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: TextField(
                          controller: controller.textController,
                          decoration: InputDecoration(
                            hintText: "Ask about Orchards, StakeHolders...",
                            hintStyle: TextStyle(color: Colors.green.shade600),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 14, horizontal: 20),
                            // prefixIcon: Icon(
                            //   Icons.mic,
                            //   color: Colors.green.shade600,
                            // ),
                          ),
                          onSubmitted: (_) => controller.sendMessage(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ScaleTransition(
                        scale: AlwaysStoppedAnimation(1.0),
                        child: FloatingActionButton(
                          mini: true,
                          backgroundColor: Colors.green,
                          child: Icon(Icons.send, color: Colors.white),
                          onPressed: controller.sendMessage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if(MediaQuery.of(context).size.width>700)SizedBox(height: 50,)
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  const ChatBubble({required this.message, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isUser
              ? [Colors.blue.shade300, Colors.lightBlue.shade200]
              : [Colors.green.shade300, Colors.lightGreen.shade200],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isUser ? 16 : 4),
          topRight: Radius.circular(isUser ? 4 : 16),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Text(
        message,
        style: TextStyle(
          color: isUser ? Colors.blue.shade900 : Colors.green.shade900,
        ),
      ),
    );
  }
}