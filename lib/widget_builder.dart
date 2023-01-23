import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:restart_app/restart_app.dart';

Widget createInput(
  BuildContext context,
  double? width,
  String hintText, {
  TextEditingController? controller,
  void Function(String)? onChanged,
  String? Function(String?)? validator,
  bool hide = false,
  Color? color,
}) {
  return Container(
    width: width,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(5), // set the border radius to 10
    ),
    child: TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(hintText: hintText, border: InputBorder.none),
      obscureText: hide,
      controller: controller,
      onChanged: onChanged,
      validator: validator,
    ),
  );
}

Widget userButton(
    BuildContext context, String task, void Function() onPressed) {
  return Row(
    children: [
      Expanded(
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(task),
        ),
      )
    ],
  );
}

Widget actionButton(
  BuildContext context,
  String task, {
  void Function()? onPressed,
  double? width,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
          width: width,
          child: ElevatedButton(
            onPressed: onPressed,
            child: Text(task),
          ))
    ],
  );
}

//TODO:
// Marker createMarker(String id, String title, LatLng position,
//     {void Function()? onTap, BitmapDescriptor? icon}) {
//   return Marker(
//       markerId: MarkerId(id),
//       infoWindow: InfoWindow(title: title),
//       icon: icon ?? BitmapDescriptor.defaultMarker,
//       position: position,
//       onTap: onTap);
// }

Widget createProfileInfo(BuildContext context, String name, String detail,
    {String separator = ":", double spaceBetween = 20, TextStyle? style}) {
  return Row(
    children: [
      Text(
        name + separator,
        style: style,
      ),
      SizedBox(
        width: spaceBetween,
      ),
      Text(
        detail,
        style: style,
      )
    ],
  );
}

//TODO:
// class AddressDropdown extends StatefulWidget {
//   final List<AddressData> values;
//   final String type;
//   final String? parentType;
//   const AddressDropdown({
//     super.key,
//     required this.values,
//     required this.type,
//     this.parentType,
//   });

//   @override
//   State<AddressDropdown> createState() => _AddressDropdownState();
// }

// class _AddressDropdownState extends State<AddressDropdown> {
//   String dropDownValue = "";

//   @override
//   void initState() {
//     print("hello");
//     if (mounted) {
//       setState(() {
//         dropDownValue = widget.values[0].name;
//       });
//     }

//     setToPrefs();
//     super.initState();
//   }

//   Future<void> setToPrefs() async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setString(widget.type, dropDownValue);
//   }

//   bool existInList() {
//     for (int i = 0; i < widget.values.length; i++) {
//       bool same = dropDownValue == widget.values[i].name;
//       if (same) {
//         return true;
//       }
//     }
//     return false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (dropDownValue == "" || !existInList()) {
//       dropDownValue = widget.values[0].name;
//     }

//     return DropdownButton(
//         value: dropDownValue,
//         items: widget.values.map((value) {
//           return DropdownMenuItem(
//             value: value.name,
//             child: Text(value.name),
//           );
//         }).toList(),
//         onChanged: (value) async {
//           if (!mounted) {
//             return;
//           }
//           setState(() {
//             dropDownValue = value!;
//           });
//           final prefs = await SharedPreferences.getInstance();
//           prefs.setString(widget.type, value!);
//         });
//   }
// }

class PasswordField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final InputBorder? inputBorder;

  const PasswordField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.inputBorder});

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _obscureText,
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: widget.inputBorder,
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            if (!mounted) {
              return;
            }
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
      controller: widget.controller,
    );
  }
}

class CountOverview extends StatelessWidget {
  final String detail;
  final int count;
  const CountOverview({super.key, required this.detail, required this.count});
  final double fontSize = 20;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 100,
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                detail,
                style: TextStyle(fontSize: fontSize),
              ),
              Text(
                count.toString(),
                style: TextStyle(fontSize: fontSize),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnlineStatusIcon extends StatelessWidget {
  final bool isOnline;

  const OnlineStatusIcon({Key? key, required this.isOnline}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: isOnline ? Colors.green : Colors.red),
    );
  }
}

void showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

final RegExp emailValidationExpression = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

void showAlert(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('I understand'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void restart() {
  Restart.restartApp();
}

Future<bool?> showSignOutDialog(context) async {
  Future<bool?> didSignOut = showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Sign Out'),
        content: Text('Are you sure you want to sign out?'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: Text('Sign Out'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
  return await didSignOut;
}
