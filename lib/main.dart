import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(ChatboyApp());
}

//themes
final ThemeData darkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: Colors.black,

  primaryColor: Colors.grey[900],
    primaryColorBrightness: Brightness.dark,
    textTheme: GoogleFonts.latoTextTheme().apply(displayColor: Colors.grey[400],bodyColor: Colors.white),

);

final ThemeData lightTheme = ThemeData.light().copyWith(
  primaryColor: Colors.blueGrey[900],
  primaryColorBrightness: Brightness.light,
);

String _name =
    'dumb bitch'; //retrieve sender's name here later through authentication

class ChatboyApp extends StatelessWidget {
  const ChatboyApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatboy',
      theme: darkTheme, //TODO stick a toggle later for dark/light theme
      home: ChatScreen(),
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});

//TODO add timestamp
  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor:
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          //gives highest position along y axis since it's in a row (the other axis)
          children: [
            Container(
              //user icon
              margin: const EdgeInsets.all(10),
              child: CircleAvatar(backgroundColor:Colors.cyan,radius: 10, child: Text(_name[0])),
            ),
            Expanded(
              //makes message text wrap
              child: Column(
                //user name
                crossAxisAlignment: CrossAxisAlignment.start,
                //gives leftmost position on x axis since it's a column
                children: [
                  Text(_name, style: Theme
                      .of(context)
                      .textTheme
                      .caption),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Text(text,
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyText1),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  //mixin lets class body be reused in multiple class hierarchies
  final _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Words!!!!! aah'),
        // actions: [],//nav will go in here, want it to be different in the different screens
      ),
      body: Column(
        children: [
          Flexible(
            //message list
            child: ListView.builder(
              itemBuilder: (_, int index) => _messages[index],
              reverse: true,
              itemCount: _messages.length,
            ),
          ),
          Divider(height: 1),
          Container(
            //text input
              decoration: BoxDecoration(color: Theme
                  .of(context)
                  .cardColor),
              child: _buildTextComposer()),
        ],
      ),
    );
  }

  @override
  void dispose() {
    //dispose animation controllers when you don't need them anymore!
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
      super.dispose();
    }
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme
          .of(context)
          .accentColor),
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(children: [
            Flexible(
              child: TextField(
                textInputAction: TextInputAction.go,
                //can customise what key sends here i think, anyway you could set a toggle for enter to send/enter to newline
                maxLines: null,
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text
                        .trim()
                        .length > 0;
                  });
                },
                onSubmitted: _isComposing ? _handleSubmitted : null,
                //disables submit if blank
                decoration:
                InputDecoration.collapsed(hintText: 'TYPE A MESSAGE'),
                //TODO see if you can get this to stay while the textbox is blank
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: _isComposing
                    ? () =>
                    _handleSubmitted(_textController
                        .text) //disables button when  blank/whitespace AND makes button colour unavailable
                    : null,
              ),
              // child: CupertinoButton( //idk if i want to localise for ios or not or if i want the app to look more or less the same across os's but here's an option
              //   child: Text('Send'),
              //   // icon: const Icon(Icons.send),
              //   onPressed: _isComposing
              //       ? () => _handleSubmitted(_textController
              //       .text) //disables button when  blank/whitespace AND makes button colour unavailable
              //       : null,
              // ),
            )
          ])),
    );
  }


  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    ChatMessage message = ChatMessage(
        text: text,
        animationController: AnimationController(
          duration: const Duration(milliseconds: 200),
          vsync: this,
        ));

    setState(() {
      _messages.insert(0, message);
    });

    _focusNode.requestFocus();

    message.animationController.forward();
  }
}

// MyApp(
// home: MyAppHome()
// ,
// routes:<String,WidgetBuilder>{
//   '/welcome':(BuildContext context) => MyPage(title: 'Welcome Page'),
//   '/login': (BuildContext context) => MyPage(title: 'Login'),
//   '/message': (BuildContext context) => MyPage(title: 'Message'),

// class MyAppHome() extends MaterialApp{
//
// }

class CounterCubit extends Cubit<int> {
  CounterCubit(int initialState) : super(initialState);

  void increment() => emit(state + 1);
}
