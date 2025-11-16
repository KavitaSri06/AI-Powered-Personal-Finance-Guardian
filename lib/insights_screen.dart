import 'package:flutter/material.dart';

class InsightsScreen extends StatefulWidget {
  @override
  _InsightsScreenState createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Placeholder messages
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'How much did I spend this week?',
      'isUser': true,
    },
    {
      'text': 'You spent ₹4,320 this week.',
      'isUser': false,
    },
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'text': _messageController.text.trim(),
        'isUser': true,
      });
    });

    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "AI Insights",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Chat messages area
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildChatBubble(
                  message: message['text'],
                  isUser: message['isUser'],
                );
              },
            ),
          ),

          // Input area
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: "Ask something...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: _sendMessage,
                        icon: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble({
    required String message,
    required bool isUser,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment:
        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.smart_toy,
                color: Colors.blue,
                size: 20,
              ),
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? Colors.blue : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 20),
                ),
              ),
              child: Text(
                message,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.grey[900],
                  fontSize: 15,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                color: Colors.grey[700],
                size: 20,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
