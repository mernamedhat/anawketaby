import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String? url;
  final double height;
  final double width;
  final BoxFit fit;
  final loaderColor;

  const CachedImage({
    Key? key,
    required this.url,
    this.height = double.infinity,
    this.width = double.infinity,
    this.fit = BoxFit.cover,
    this.loaderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      '${this.url}',
      width: this.width,
      height: this.height,
      fit: this.fit,
      cache: true,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return Center(
              child: CircularProgressIndicator(
                value: (state.loadingProgress != null)
                    ? state.loadingProgress!.cumulativeBytesLoaded /
                        state.loadingProgress!.expectedTotalBytes!
                    : null,
                color: this.loaderColor,
              ),
            );

          default:
            return null;
        }
      },
    );
  }
}
