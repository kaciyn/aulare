import 'package:aulare/views/contacts/widgets/add_contact_fab.dart';
import 'package:aulare/views/contacts/widgets/alphabet_scroll_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'file:///D:/BigBadCodeRepos/aulare/lib/views/contacts/widgets/contact_list.dart';

class ContactListPage extends StatefulWidget {
  const ContactListPage();

  @override
  State<StatefulWidget> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage>
    with TickerProviderStateMixin {
  ScrollController scrollController;

  List nameList = [
    'Anya Ostrem',
    'Burt Hutchison',
    'Chana Sobolik',
    'Chastity Nutt',
    'Deana Tenenbaum',
    'Denae Cornelius',
    'Elisabeth Saner',
    'Eloise Rocca',
    'Eloy Kallas',
    'Esther Hobby',
    'Euna Sulser',
    'Florinda Convery',
    'Franklin Nottage',
    'Gale Nordeen',
    'Garth Vanderlinden',
    'Gracie Schulte',
    'Inocencia Eaglin',
    'Jillian Germano',
    'Jimmy Friddle',
    'Juliann Bigley',
    'Kia Gallaway',
    'Larhonda Ariza',
    'Larissa Reichel',
    'Lavone Beltz',
    'Lazaro Bauder',
    'Len Northup',
    'Leonora Castiglione',
    'Lynell Hanna',
    'Madonna Heisey',
    'Marcie Borel',
    'Margit Krupp',
    'Marvin Papineau',
    'Mckinley Yocom',
    'Melita Briones',
    'Moses Strassburg',
    'Nena Recalde',
    'Norbert Modlin',
    'Onita Sobotka',
    'Raven Ecklund',
    'Robert Wadldow',
    'Roxy Lovelace',
    'Rufina Chamness',
    'Saturnina Hux',
    'Shelli Perine',
    'Sherryl Routt',
    'Soila Phegley',
    'Tamera Strelow',
    'Tammy Beringer',
    'Vesta Kidd',
    'Yan Welling'
  ];

  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(scrollListener);
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.linear,
    );
    animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            ContactList(scrollController: scrollController, nameList: nameList),
            Container(
              margin: EdgeInsets.only(top: 190),
              child: AlphabetScrollBar(
                nameList: nameList,
                scrollController: scrollController,
              ),
            ),
          ],
        ),
        floatingActionButton: AddContactFab(animation: animation, vsync: this),
      ),
    );
  }

  //scroll listener for checking scroll direction and hide/show fab
  scrollListener() {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
