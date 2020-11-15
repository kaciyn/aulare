// Container googleSignInButton() {
//   return Container(
//       margin: const EdgeInsets.only(top: 100),
//       child: FlatButton.icon(
//           onPressed: () => BlocProvider.of<AuthenticationBloc>(context)
//               .add(ClickedGoogleLogin()),
//           color: Colors.transparent,
//           icon: Image.asset(
//             Assets.google_button,
//             height: 25,
//           ),
//           label: const Text(
//             'Sign In with Google',
//             style: TextStyle(
//                 // color: darkTheme.primaryTextColorLight,
//                 fontWeight: FontWeight.w800),
//           )));
// }

///
/// This routine is invoked when the window metrics have changed.
///
// @override
// void didChangeMetrics() {
//   final value = MediaQuery.of(context).viewInsets.bottom;
//   if (value > 0) {
//     if (isKeyboardOpen) {
//       onKeyboardChanged(false);
//     }
//     isKeyboardOpen = false;
//   } else {
//     isKeyboardOpen = true;
//     onKeyboardChanged(true);
//   }
// }

// onKeyboardChanged(bool isVisible) {
//   if (!isVisible) {
//     FocusScope.of(context).requestFocus(FocusNode());
//     usernameFieldAnimationController.reverse();
//   }
// }
