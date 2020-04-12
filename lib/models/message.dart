import 'dart:core';

import 'package:sellit/models/user.dart';

//Still need to adjust for using Firebase
class Message {
  final User sender;
  final String time; //Change to type DateTime or Firebase Timestamp
  final String text;
  final bool unread;

  Message({
    this.sender,
    this.time,
    this.text,
    this.unread,
  });
}

//Test users and messages

//Current CustomElementRegistry
final User currentUser = User(
  id: 0,
  email: "currentUser@sjsu.edu",
  displayName: "Current User",
);

final User greg = User(
  id: 1,
  email: "greg@sjsu.edu",
  displayName: "Greg",
);

final User james = User(
  id: 2,
  email: "james@sjsu.edu",
  displayName: "James",
);

final User olivia = User(
  id: 3,
  email: "olivia@sjsu.edu",
  displayName: "Olivia",
);

List<Message> chats = [
  Message(
    sender: james,
    time: '5:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    unread: true,
  ),
  Message(
    sender: olivia,
    time: '5:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    unread: false,
  ),
];

List<Message> messages = [
  Message(
    sender: james,
    time: '5:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '4:30 PM',
    text: 'Just walked my doge. She was super duper cute. The best pupper!!',
    unread: true,
  ),
  Message(
    sender: james,
    time: '3:45 PM',
    text: 'How\'s the doggo?',
    unread: true,
  ),
  Message(
    sender: james,
    time: '3:15 PM',
    text: 'All the food',
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '2:30 PM',
    text: 'Nice! What kind of food did you eat?',
    unread: true,
  ),
  Message(
    sender: james,
    time: '2:00 PM',
    text: 'I ate so much food today.',
    unread: true,
  ),
];