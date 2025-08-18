import 'package:flutter/material.dart';
import 'package:tictactoe/core/constants/app_colors.dart';
import 'package:tictactoe/core/constants/app_images.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppImages.logo,
            height: 40,
          ),
          const SizedBox(width: 8),
          const Text(
            "TIC TAC TOE",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      actions: const [
        // IconButton(
        //   onPressed: () => GoRouter.of(context).pushNamed(AppRoutes.challenge),
        //   icon: const Icon(
        //     Icons.emoji_events,
        //     size: 30,
        //     color: Colors.yellow,
        //   ),
        // ),
      ],
    );
  }
}
