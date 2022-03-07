import 'package:aulare/config/defaultTheme.dart';
import 'package:aulare/views/messaging/components/navigation_pill_widget.dart';
import 'package:flutter/material.dart';

class MessagingBottomSheet extends StatefulWidget {
  const MessagingBottomSheet();

  @override
  _MessagingBottomSheetState createState() => _MessagingBottomSheetState();
}

class _MessagingBottomSheetState extends State<MessagingBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: ListView(children: <Widget>[
              NavigationPill(),
              const Center(
                  child: Text(
                'Messages',
              )),
              const SizedBox(
                height: 20,
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: 5,
                separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(left: 75, right: 20),
                    child: Divider(
                      color: darkTheme.colorScheme.secondary,
                    )),
                itemBuilder: (BuildContext context, int index) {},
                // itemBuilder: (context, index) {
                //   return MessageRow();
                // },
              )
            ])));
  }
}
