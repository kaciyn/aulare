import 'package:aulare/config/defaultTheme.dart';
import 'package:flutter/material.dart';

class AlphabetScrollBar extends StatefulWidget {

  const AlphabetScrollBar({@required this.nameList, @required this.scrollController});
  final List nameList;
  final ScrollController scrollController;

  @override
  _AlphabetScrollBarState createState() =>
      _AlphabetScrollBarState(nameList, scrollController);
}

class _AlphabetScrollBarState extends State<AlphabetScrollBar> {

  _AlphabetScrollBarState(this.nameList, this.scrollController);
  double offsetContainer = 0.0;
  var scrollBarText;
  var scrollBarTextPrev;
  var scrollBarHeight;
  var contactRowSize = 45.0; //NOTE: size items
  var scrollBarMarginRight = 50.0;
  var scrollBarContainerHeight;
  var scrollBarPosSelected = 0;
  var scrollBarHeightDiff = 0.0;
  var screenHeight = 0.0;
  ScrollController scrollController;
  String scrollBarBubbleText = '';
  bool scrollBarBubbleVisibility = false;
  List nameList;

  List alphabetList = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      scrollBarBubbleVisibility = true;
      print(offsetContainer);
      print(details);
      if ((offsetContainer + details.delta.dy) >= 0 &&
          (offsetContainer + details.delta.dy) <=
              (scrollBarContainerHeight - scrollBarHeight)) {
        offsetContainer += details.delta.dy;
        print(offsetContainer);
        scrollBarPosSelected =
            ((offsetContainer / scrollBarHeight) % alphabetList.length).round();
        print(scrollBarPosSelected);
        scrollBarText = alphabetList[scrollBarPosSelected];
        if (scrollBarText != scrollBarTextPrev) {
          for (var i = 0; i < nameList.length; i++) {
            print(scrollBarText.toString());
            if (scrollBarText
                    .toString()
                    .compareTo(nameList[i].toString().toUpperCase()[0]) ==
                0) {
              print(nameList[i]);
              scrollController.jumpTo(i * contactRowSize);
              break;
            }
          }
          scrollBarTextPrev = scrollBarText;
        }
      }
    });
  }

  void _onVerticalDragStart(DragStartDetails details) {
    offsetContainer = details.globalPosition.dy - scrollBarHeightDiff;
    setState(() {
      scrollBarBubbleVisibility = true;
    });
  }

  Container getBubble() {
    if (!scrollBarBubbleVisibility) {
      return Container();
    }
    return Container(
      decoration: BoxDecoration(
          color: darkTheme.colorScheme.secondary,
          borderRadius: const BorderRadius.all(Radius.circular(30.0))),
      width: 30,
      height: 30,
      child: Center(
        child: Text(
          "${scrollBarText ?? "${alphabetList.first}"}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }

  Expanded _getAlphabetItem(int index) {
    return Expanded(
      child: Container(
        width: 40,
        height: 20,
        alignment: Alignment.center,
        child: Text(
          alphabetList[index],
          style: (index == scrollBarPosSelected)
              ? const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)
              : const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  void _onVerticalEnd(DragEndDetails details) {
    setState(() {
      scrollBarBubbleVisibility = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return LayoutBuilder(builder: (context, constraints) {
      scrollBarHeightDiff = screenHeight - constraints.biggest.height;
      scrollBarHeight = (constraints.biggest.height) / alphabetList.length;
      scrollBarContainerHeight = constraints.biggest.height; //NO
      return Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onVerticalDragEnd: _onVerticalEnd,
              onVerticalDragUpdate: _onVerticalDragUpdate,
              onVerticalDragStart: _onVerticalDragStart,
              child: Container(
                //height: 20.0 * 26,
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [...List.generate(alphabetList.length,
                          (index) => _getAlphabetItem(index))],
                ),
              ),
            ),
          ),
          Positioned(
            right: scrollBarMarginRight,
            top: offsetContainer,
            child: getBubble(),
          ),
        ],
      );
    });
  }
}
