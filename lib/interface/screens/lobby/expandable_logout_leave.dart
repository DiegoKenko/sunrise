import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import 'package:sunrise/interface/components/animated_page_transition.dart';
import 'package:sunrise/constants/styles.dart';
import 'package:sunrise/interface/controllers/auth/auth_controller.dart';
import 'package:sunrise/interface/screens/login/login_page_view.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';

class ExpandableLogoutAndLeave extends StatefulWidget {
  const ExpandableLogoutAndLeave({Key? key}) : super(key: key);

  @override
  State<ExpandableLogoutAndLeave> createState() =>
      _ExpandableLogoutAndLeaveState();
}

class _ExpandableLogoutAndLeaveState extends State<ExpandableLogoutAndLeave> {
  final _leaveLobbyController = ExpandableController(initialExpanded: false);
  final AuthController _authService = getIt<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Expandable(
      controller: _leaveLobbyController,
      collapsed: Container(
        padding: const EdgeInsets.all(8.0),
        width: 50,
        height: 50,
        child: IconButton(
          onPressed: () {
            setState(() {
              _leaveLobbyController.toggle();
            });
          },
          icon: const Icon(
            Icons.exit_to_app,
            color: Colors.white,
          ),
        ),
      ),
      expanded: SizedBox(
        width: 400,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _leaveLobbyController.toggle();
                  });
                },
                icon: const Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FilledButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      kPrimaryColor,
                    ),
                  ),
                  onPressed: () {},
                  child: const Row(
                    children: [
                      Icon(
                        Icons.refresh_sharp,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Recriar sala',
                        style: kTextLeaveLobbyStyle,
                      ),
                    ],
                  ),
                ),
                FilledButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      kPrimaryColor,
                    ),
                    side: MaterialStateProperty.all(
                      const BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                  ),
                  onPressed: () {
                    _authService.logout();
                    Navigator.pushReplacement(
                      context,
                      AnimatedPageTransition(
                        page: const LoginPageView(),
                      ),
                    );
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Logout',
                        style: kTextLeaveLobbyStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
