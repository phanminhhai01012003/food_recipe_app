import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/constants.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AnimationSlider extends StatefulWidget {
  const AnimationSlider({super.key});

  @override
  State<AnimationSlider> createState() => _AnimationSliderState();
}

class _AnimationSliderState extends State<AnimationSlider> {
  int activeIndex = 0;
  final _controller = CarouselSliderController();
  void animateToSlide(int i) => _controller.animateToPage(i);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: sliderImage.length, 
          itemBuilder: (context, index, realIndex) => Container(
            width: double.infinity,
            margin: EdgeInsets.all(8),
            child: Image.network(sliderImage[index]),
          ), 
          options: CarouselOptions(
            onPageChanged: (index, reason) {
              setState(() {
                activeIndex = index;
              });
            },
            initialPage: 0,
            height: 200,
            autoPlay: true,
            reverse: true,
            autoPlayAnimationDuration: Duration(seconds: 1),
            enlargeCenterPage: true,
          ),
        ),
        SizedBox(height: 5),
        AnimatedSmoothIndicator(
          activeIndex: activeIndex, 
          count: sliderImage.length,
          effect: SlideEffect(
            activeDotColor: AppColors.green,
            dotColor: AppColors.grey,
            dotHeight: 10,
            dotWidth: 10
          ),
          onDotClicked: animateToSlide,
        )
      ],
    );
  }
}