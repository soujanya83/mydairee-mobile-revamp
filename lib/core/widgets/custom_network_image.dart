import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_urls.dart';

class CustomNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final String? fullUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool isImageShow;

  const CustomNetworkImage({
    super.key,
    this.imageUrl,
    this.width = double.infinity,
    this.isImageShow = false,
    this.height = 200.0,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.fullUrl,
  });

  @override
  Widget build(BuildContext context) {
    // print('custom image url');
    // print(imageUrl);
    // print('Full URL: ${fullUrl ?? ('${AppUrls.baseUrl}/${imageUrl ?? ''}')}');
    return GestureDetector(
      onTap: !isImageShow
          ? null
          : () {
              // Navigate to new screen with Hero animation
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScreenImage(
                    imageUrl: AppUrls.baseUrl + (imageUrl ?? ''),
                  ),
                ),
              );
            },
  
      child: CachedNetworkImage(
        imageUrl: fullUrl ?? ('${AppUrls.baseUrl}/${imageUrl ?? ''}'),
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) {
          return placeholder ??
              const Center(
                  child: Icon(
                Icons.image,
                size: 40,
                color: AppColors.grey,
              )
                  //     Image.asset(
                  //   AppAssets.paropkarLogo,
                  //   fit: BoxFit.contain,
                  //   // color: AppColors.grey,
                  //   width: width,
                  //   height: height,
                  // )
                  );
        },
        errorWidget: (context, url, error) {
          return errorWidget ??
              const Center(child: Icon(Icons.image, size: 40, color: AppColors.grey)
                  //      Image.asset(
                  //   AppAssets.paropkarLogo,
                  //   fit: BoxFit.contain,
                  //   width: width,
                  //   height: height,
                  // )
                  );
        },
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Hero(
          tag: imageUrl,
          child: Image.network(imageUrl, fit: BoxFit.contain, loadingBuilder:
              (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child; // Image loaded successfully
            }
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        (loadingProgress.expectedTotalBytes!)
                    : null,
                color: AppColors.primaryColor,
              ),
            );
          }, errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return Center(child: Icon(Icons.image)
                //     Image.asset(
                //   AppAssets.default_image,
                //   fit: BoxFit.contain,
                //   color: AppColors.grey,
                // )
                );
          }),
        ),
      ),
    );
  }
}

// class CustomNetworkImage2 extends StatelessWidget {
//   final String? imageUrl;
//   final String? fullUrl;
//   final double width;
//   final double height;
//   final BoxFit fit;
//   final Widget? placeholder;
//   final Widget? errorWidget;
//   final bool isImageShow;

//   const CustomNetworkImage2({
//     super.key,
//     this.imageUrl,
//     this.width = double.infinity,
//     this.isImageShow = false,
//     this.height = 200.0,
//     this.fit = BoxFit.cover,
//     this.placeholder,
//     this.errorWidget,
//     this.fullUrl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     print('custom image url');
//     print(imageUrl);
//     return GestureDetector(
//       onTap: !isImageShow
//           ? null
//           : () {
//               // Navigate to new screen with Hero animation
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => FullScreenImage(
//                     imageUrl: (imageUrl ?? ''),
//                   ),
//                 ),
//               );
//             },
//       child: Image.network(
//         fullUrl ?? ((imageUrl ?? '')),
//         width: width,
//         height: height,
//         fit: fit,
//         loadingBuilder: (BuildContext context, Widget child,
//             ImageChunkEvent? loadingProgress) {
//           if (loadingProgress == null) {
//             return child; // Image loaded successfully
//           }
//           return placeholder ??
//               Center(
//                   child: Image.asset(
//                 AppAssets.paropkarLogo,
//                 fit: BoxFit.contain,
//                 // color: AppColors.grey,
//                 width: width,
//                 height: height,
//               ));
//         },
//         errorBuilder:
//             (BuildContext context, Object exception, StackTrace? stackTrace) {
//           return errorWidget ??
//               Center(
//                   child: Image.asset(
//                 AppAssets.paropkarLogo,
//                 fit: BoxFit.contain,
//                 width: width,
//                 height: height,
//               ));
//         },
//       ),
//     );
//   }
// }
