import 'package:flutter/material.dart';
import 'package:sunrise/domain/auth/bloc_auth.dart';
import 'package:sunrise/services/getIt/get_it_dependencies.dart';

class SunriseDrawer extends StatefulWidget {
  const SunriseDrawer({
    super.key,
  });

  @override
  State<SunriseDrawer> createState() => _SunriseDrawerState();
}

class _SunriseDrawerState extends State<SunriseDrawer> {
  @override
  Widget build(BuildContext context) {
    final AuthService authService = getIt<AuthService>();
    return Drawer(
      backgroundColor: Colors.black.withOpacity(0.7),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ListTile(
            tileColor: Colors.black,
            leading: Image.network(
              authService.lover!.photoURL,
              width: 50,
              height: 50,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: const BorderSide(
                color: Colors.white,
                width: 0.5,
              ),
            ),
            title: Text(
              authService.lover!.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              authService.lover!.email,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
          ListTile(
            title: Row(
              children: [
                const Icon(
                  Icons.wb_sunny,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    '${authService.lover!.suns} ',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            trailing: FilledButton(
              onPressed: () {},
              child: const Text('Adicionar'),
            ),
          ),
          Expanded(child: Container()),
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: const BorderSide(
                color: Colors.white,
                width: 0.5,
              ),
            ),
            tileColor: Colors.black,
            title: const Text(
              'Sair',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
