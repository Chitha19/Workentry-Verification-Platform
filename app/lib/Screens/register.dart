import 'package:app/Widgets/selected_site.dart';
import 'package:flutter/cupertino.dart';
import 'package:app/api/corps.dart';
import 'package:app/Widgets/selected_corp.dart';
import 'package:app/States/register_form.dart';
import 'package:provider/provider.dart';
// import 'package:app/Screens/error_page.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _Register();
}

class _Register extends State<Register> {
  final Future<List<TCorp>> corps = fetchTCorps();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      RegisterForm form = Provider.of<RegisterForm>(context, listen: false);
      corps.then((datas) {
        form.corp = datas[0];
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Register'),
        ),
        child: Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Center(
                child: FutureBuilder<List<TCorp>>(
                    future: corps,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        print("========== error : ${snapshot.error}");
                        return const Center(
                            child: Text("Server error. Please try again later.",
                                style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold)));
                      }

                      if (snapshot.hasData) {
                        if (snapshot.data == null || snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text(
                                  "Server error. Please try again later.",
                                  style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold)));
                        }

                        var datas = snapshot.data!;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SelectedCorp(corps: datas),
                            const SizedBox(height: 30),
                            const SelectedSite(),
                          ],
                        );
                      }

                      return const CupertinoActivityIndicator();
                    }))));
  }
}

// Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
//                       CupertinoTypeAheadField<Corp>(
//                         suggestionsCallback: (search) {
//                           return corps.then((values) {
//                             return values
//                                 .where(
//                                   (item) => item.name.toLowerCase().contains(
//                                         search.toLowerCase(),
//                                       ),
//                                 )
//                                 .toList();
//                           });
//                         },
//                         controller: corpsController,
//                         builder: (context, controller, focusNode) {
//                           return CupertinoTextField(
//                             controller: controller,
//                             focusNode: focusNode,
//                             placeholder: "Select your coperate.",
//                           );
//                         },
//                         itemBuilder: (context, option) {
//                           return Padding(
//                             padding: const EdgeInsets.all(8),
//                             child: Text(option.name,
//                                 textAlign: TextAlign.start,
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                 )),
//                           );
//                         },
//                         onSelected: (option) {
//                           setState(() {
//                             corp = option;
//                             corpsController.text = option.name;
//                           });
//                         },
//                         emptyBuilder: (context) => const Padding(
//                           padding: EdgeInsets.all(8),
//                           child: Text(
//                             'No Coperates Found!',
//                             textAlign: TextAlign.start,
//                             style: TextStyle(
//                               color: CupertinoColors.inactiveGray,
//                               fontSize: 18,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 30),
//                       corp != null ?
//                         CupertinoTypeAheadField<Site>(
//                         suggestionsCallback: (search) {
//                           return fetchSites(corp!.id).then((values) {
//                             return values
//                                 .where(
//                                   (item) => item.name.toLowerCase().contains(
//                                         search.toLowerCase(),
//                                       ),
//                                 )
//                                 .toList();
//                           });
//                         },
//                         controller: sitesController,
//                         builder: (context, controller, focusNode) {
//                           return CupertinoTextField(
//                             controller: controller,
//                             focusNode: focusNode,
//                             placeholder: "Select your site.",
//                           );
//                         },
//                         itemBuilder: (context, option) {
//                           return Padding(
//                             padding: const EdgeInsets.all(8),
//                             child: Text(option.name,
//                                 textAlign: TextAlign.start,
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                 )),
//                           );
//                         },
//                         onSelected: (option) {
//                           setState(() {
//                             site = option;
//                             sitesController.text = option.name;
//                           });
//                         },
//                         emptyBuilder: (context) => const Padding(
//                           padding: EdgeInsets.all(8),
//                           child: Text(
//                             'No Sites Found!',
//                             textAlign: TextAlign.start,
//                             style: TextStyle(
//                               color: CupertinoColors.inactiveGray,
//                               fontSize: 18,
//                             ),
//                           ),
//                         ),
//                       )
//                       :
//                         const Text("block",
