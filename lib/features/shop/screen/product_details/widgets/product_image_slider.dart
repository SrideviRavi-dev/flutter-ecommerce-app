import 'package:flutter/material.dart';
import 'package:myapp/common/widgets/container/rounded_container.dart';
import 'package:myapp/features/shop/screen/product_details/widgets/zoom.dart';

class JProductImageSlider extends StatelessWidget {
  const JProductImageSlider({
    super.key,
    required PageController pageController,
    required this.imageUrls,
  }) : _pageController = pageController;

  final PageController _pageController;
  final List<String> imageUrls;

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) {
      return const Center(child: Text('No images available'));
    }

    return Center(
      child: JRoundedContainer(
        child: SizedBox(
          height: 400,
          child: PageView.builder(
            controller: _pageController,
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ZoomableImageScreen(
                        imageUrl: imageUrls[index],
                      ),
                    ),
                  );
                },
                child: Image.network(
                  imageUrls[index],
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(Icons.error, color: Colors.red, size: 50),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
