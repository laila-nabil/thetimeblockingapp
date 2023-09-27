import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget  {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      actions: [
        IconButton(onPressed: (){}, icon: const Icon(Icons.search)),
        IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert)),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(46.0);
}
