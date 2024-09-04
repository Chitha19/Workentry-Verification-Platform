import 'package:flutter/cupertino.dart';
import 'package:app/api/corps.dart';
import 'package:provider/provider.dart';
import 'package:app/States/register_form.dart';

class SelectedCorp extends StatefulWidget {
  final List<TCorp> corps;

  const SelectedCorp({super.key, required this.corps});

  @override
  State<SelectedCorp> createState() => _SelectedCorpState();
}

class _SelectedCorpState extends State<SelectedCorp> {
  late int index = 0;

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final form = Provider.of<RegisterForm>(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text('Coperate',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
        Flexible(
            child: CupertinoButton(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.centerLeft,
          onPressed: () {
            _showDialog(
              CupertinoPicker(
                magnification: 1.22,
                squeeze: 1.2,
                useMagnifier: true,
                itemExtent: 32.0,
                scrollController: FixedExtentScrollController(
                  initialItem: index,
                ),
                onSelectedItemChanged: (int selectedItem) {
                  setState(() {
                    index = selectedItem;
                  });
                  form.corp = widget.corps[selectedItem];
                },
                children: List<Widget>.generate(widget.corps.length, (int i) {
                  return Center(
                      child: Text(
                    widget.corps[i].name,
                  ));
                }),
              ),
            );
          },
          child: Text(
            widget.corps[index].name,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: false,
          ),
        )),
      ],
    );
  }
}
