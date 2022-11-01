import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SenderMessageBox extends StatelessWidget {
  final Color messageBoxColor;
  final String message;
  final Timestamp time;
  const SenderMessageBox(
      {super.key,
      required this.messageBoxColor,
      required this.message,
      required this.time});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: messageBoxColor,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 30,
                  top: 5,
                  bottom: 20,
                ),
                child: Column(
                  children: [Text(message)],
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Text(
                  DateFormat.Hm().format(time.toDate()),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
