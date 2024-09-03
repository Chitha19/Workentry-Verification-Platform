import 'package:app/Screens/error_page.dart';
import 'package:app/Screens/register_user.dart';
import 'package:app/States/profile.dart';
import 'package:app/States/register_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:app/api/profile.dart';
import 'package:provider/provider.dart';
// import 'package:app/Screens/check_in.dart';
// import 'package:app/Widgets/selected_corp.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Profile()),
        ChangeNotifierProvider(create: (context) => RegisterForm()),
      ],
      child: const Home(),
    ),
  );
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  late Future<User> _user;

  @override
  void initState() {
    super.initState();
    _user = fetchUser('1');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Profile profile = Provider.of<Profile>(context, listen: false);
      _user.then((datas) {
        profile.setProfile(datas.id.toString(), datas.name);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
        theme: const CupertinoThemeData(brightness: Brightness.light),
        home: FutureBuilder<User>(
          future: _user,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const ErrorPage(
                  tabName: "Check In",
                  message: "Server error. Please try again later.");
            }

            if (snapshot.hasData) {
              // return const Checkin();
              return const RegisterUser();
            }

            return const CupertinoActivityIndicator();
          },
        ));
  }
}

// class Home extends StatelessWidget {
//   const Home({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const CupertinoApp(
//       theme: CupertinoThemeData(brightness: Brightness.light),
//       home: Checkin(),
//     );
//   }
// }
