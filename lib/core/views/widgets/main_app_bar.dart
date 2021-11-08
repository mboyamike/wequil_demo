import 'package:flutter/material.dart';
import 'package:wequil_demo/core/views/widgets/nav_link.dart';

import '../../core.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({
    Key? key,
    this.activePath = LandingScreen.path,
  }) : super(key: key);

  final String activePath;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('WEquil'),
      actions: [
        NavLink(
          label: 'home',
          path: LandingScreen.path,
          isActive: activePath == LandingScreen.path,
        ),
        NavLink(
          label: 'Careers',
          path: '/careers',
          isActive: activePath == '/careers',
        ),
        NavLink(
          label: 'About',
          path: '/about',
          isActive: activePath == '/about',
        ),
        NavLink(
          label: 'Admin',
          path: '/admin',
          isActive: activePath == '/admin',
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
