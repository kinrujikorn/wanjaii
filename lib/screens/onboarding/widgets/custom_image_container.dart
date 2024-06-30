import 'package:flutter/material.dart';

class CustomImageContainer extends StatelessWidget {
  final String? imageUrls;
  final Function() onPickImage;

  const CustomImageContainer({
    Key? key,
    this.imageUrls,
    required this.onPickImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 110,
        width: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(120),
          color: Colors.transparent,
          border: Border.all(width: 2, color: Colors.white),
          image: imageUrls != null
              ? DecorationImage(
                  image: NetworkImage(imageUrls!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: imageUrls == null
            ? Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 39,
                  width: 39,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color(0xFFBB254A),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.photo_camera),
                    color: Colors.white,
                    onPressed: () =>
                        onPickImage(), // Use the provided onPickImage function
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
