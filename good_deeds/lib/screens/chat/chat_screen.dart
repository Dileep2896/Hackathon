import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:good_deeds/apis/database.dart';
import 'package:good_deeds/constants/colors.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.requestUserId,
    required this.serviceId,
    required this.chatId,
  });

  final String requestUserId;
  final String serviceId;
  final String chatId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String userId =
        widget.requestUserId == user!.uid ? user!.uid : widget.requestUserId;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: StreamBuilder(
            stream: DatabaseService().getUserDetailsById(userId),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return const Text(
                  'Loading...',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                );
              }
              final data = snapshot.data!;
              return Text(
                data.get('name'),
                style: const TextStyle(
                  color: Colors.white,
                ),
              );
            }),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: StreamBuilder(
          stream:
              DatabaseService().getMessages(widget.serviceId, widget.chatId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('An error occurred'),
              );
            }
            return SafeArea(
              child: Column(
                children: [
                  !snapshot.hasData || snapshot.data!.isEmpty
                      ? const Expanded(
                          child: Center(
                            child: Text("No Messages"),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            reverse: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              var message = snapshot.data![index];
                              bool isCurrentUser =
                                  message['senderId'] == user!.uid;
                              return Align(
                                alignment: isCurrentUser
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: isCurrentUser
                                        ? AppColors.primaryColor
                                        : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: isCurrentUser
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        message['message'],
                                        style: TextStyle(
                                          color: isCurrentUser
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        DateFormat('hh:mm a').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                          message['timestamp'].seconds * 1000,
                                        )),
                                        style: TextStyle(
                                          color: isCurrentUser
                                              ? Colors.white70
                                              : Colors.black54,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: message,
                            decoration: const InputDecoration(
                              hintText: 'Enter your message...',
                              filled: true,
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.primaryColor,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30.0),
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          decoration: const BoxDecoration(
                            color: AppColors
                                .primaryColor, // Add your desired background color here
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              if (message.text.isNotEmpty) {
                                DatabaseService().sendMessage(
                                  widget.serviceId,
                                  widget.chatId,
                                  user!.uid,
                                  message.text,
                                );
                                message.clear();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
