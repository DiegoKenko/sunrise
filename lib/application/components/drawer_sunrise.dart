import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunrise/domain/auth/bloc_auth.dart';

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
    return Drawer(
      backgroundColor: Colors.black.withOpacity(0.7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DrawerHeader(
            child: Column(
              children: [
                ListTile(
                  leading: Image.network(
                    context.read<AuthBloc>().state.lover.photoURL,
                    width: 50,
                    height: 50,
                  ),
                  title: Text(
                    context.read<AuthBloc>().state.lover.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    context.read<AuthBloc>().state.lover.email,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed(
                      '/login',
                    );
                  },
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text(
              'Sair',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                '/login',
              );
            },
          ),
        ],
      ),
    );
  }
}
