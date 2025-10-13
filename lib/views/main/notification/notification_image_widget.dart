import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/constants.dart';

class NotificationImageWidget extends StatelessWidget {
  final IconData icon;
  final String fromUserAvatar;
  final Color color;
  const NotificationImageWidget({
    super.key, 
    required this.icon, 
    required this.fromUserAvatar,
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 35,
          height: 35,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: Builder(
            builder: (context) {
              if (fromUserAvatar.isEmpty) {
                return Image.asset(
                  userDefaultImage,
                  fit: BoxFit.cover,
                );
              }
              return Image.network(
                fromUserAvatar,
                fit: BoxFit.cover,
              );
            },
          )
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
      ],
    );
  }
}