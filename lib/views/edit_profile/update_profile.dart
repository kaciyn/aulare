/*
final _picker = ImagePicker();

Animation profilePictureHeightAnimation, usernameAnimation;
File profilePictureFile;
ImageProvider profilePicture;

@override
void initState() {
  authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

  // WidgetsBinding.instance.addObserver(this);
  usernameFieldAnimationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 300));

  profilePictureHeightAnimation =
  Tween(begin: 100.0, end: 0.0).animate(usernameFieldAnimationController)
    ..addListener(() {
      setState(() {});
    });

  usernameAnimation =
  Tween(begin: 50.0, end: 10.0).animate(usernameFieldAnimationController)
    ..addListener(() {
      setState(() {});
    });

  usernameFocusNode.addListener(() {
    if (usernameFocusNode.hasFocus) {
      usernameFieldAnimationController.forward();
    } else {
      usernameFieldAnimationController.reverse();
    }
  });

  super.initState();
}return Container
(
child: BlocBuilder<AuthenticationBloc, AuthenticationState>
(
builder: (
context, state) {
profilePicture = Image.asset(Assets.user).image;
if (state is DataPrefilled) {
profilePicture = Image.network(state.user.profilePictureUrl).image;
} else if (state is ProfilePictureReceived) {
profilePictureFile = state.file;
profilePicture = Image.file(profilePictureFile).image;
}


Container updateProfileButton() {
return
// AnimatedOpacity(
//   opacity: currentPage == 1 ? 1.0 : 0.0,
//   //shows only on page 1
//   duration: const Duration(milliseconds: 500),
//   child:
Container(
margin: const EdgeInsets.only(right: 20, bottom: 20),
child: Row(
mainAxisAlignment: MainAxisAlignment.end,
mainAxisSize: MainAxisSize.max,
children: <Widget>[
FloatingActionButton(
onPressed: () => authenticationBloc.add(
SaveProfile(profilePictureFile, usernameController.text)),
elevation: 0,
backgroundColor: darkTheme.primaryColor,
child: Icon(
Icons.done,
color: darkTheme.accentColor,
),
)
],
));
}
SizedBox(height: profilePictureHeightAnimation.value),
profilePicturePicker(),
SizedBox(
height: usernameAnimation.value,
),
GestureDetector profilePicturePicker() {
return GestureDetector(
onTap: pickProfilePicture,
child: CircleAvatar(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: const <Widget>[
Icon(
Icons.camera,
color: Colors.white,
size: 15,
),
Text(
'Set Profile Picture',
textAlign: TextAlign.center,
style: TextStyle(
color: Colors.white,
fontSize: 10,
),
)
],
),
backgroundImage: profilePicture,
radius: 60,
),
);
}

Future pickProfilePicture() async {
final pickedProfilePictureFile =
await _picker.getImage(source: ImageSource.gallery);
profilePictureFile = File(pickedProfilePictureFile.path);
authenticationBloc.add(PickedProfilePicture(profilePictureFile));
}

*/
