import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_recipe_app/common/app_colors.dart';
import 'package:food_recipe_app/common/constants.dart';
import 'package:food_recipe_app/common/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboard extends StatefulWidget {
  const Onboard({super.key});

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> with TickerProviderStateMixin{
  PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _floatController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _floatAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fadeController = AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    _slideController = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _floatController = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    _scaleController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut));
    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.2), end: Offset.zero).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeInOutBack));
    _floatAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _floatController, curve: Curves.easeInOut));
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut));
    _startAnimations();
    _floatController.repeat(reverse: true);
  }

  void _resetAnimations() {
    _fadeController.reset();
    _slideController.reset();
    _floatController.reset();
    _scaleController.reset();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _floatController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void onPageChanged(int index){
    setState(() {
      _currentPage = index;
    });
    _resetAnimations();
    _startAnimations();
    HapticFeedback.lightImpact();
  }

  void _startAnimations() {
    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
  }

  void prevPage() {
    if (_currentPage == 0) return;
    _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void nextPage(){
    if (_currentPage < 2) {
      _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }else {
      navigateToNewPage();
    }
  }

  void navigateToNewPage() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);
    Navigator.pushAndRemoveUntil(context, checkDeviceRoute(loginPage), (route) => false);
  }

  Gradient get getGradientColors {
    if (_currentPage == 0) {
      return AppColors.gradient1;
    } else if (_currentPage == 1) {
      return AppColors.gradient2;
    }
    return AppColors.gradient3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: getGradientColors
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: navigateToNewPage, 
                    child: Text("Bỏ qua", 
                      style: TextStyle(
                        color: Colors.white, 
                        fontSize: 16
                      )
                    )
                  ),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: onPageChanged,
                  children: [
                    _buildPage(
                      image: foodDesignImage, 
                      title: "PMH Food Recipe", 
                      desc: "Hãy bắt đầu trải nghiệm chế biến các món ăn cho riêng bạn", 
                      isFirst: true
                    ),
                    _buildPage(
                      image: foodImage, 
                      title: "Những ý tưởng mới", 
                      desc: "Khám phá những ý tưởng mới về món ăn và truyền cảm hứng cho tất cả mọi người", 
                      isFirst: false
                    ),
                    _buildPage(
                      image: cookingImage, 
                      title: "Gia đình là số 1", 
                      desc: "Những món ăn ngon miệng sẽ đem lại hạnh phúc cho cả gia đình bạn", 
                      isFirst: false
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    visible: _currentPage > 0,
                    child: _navigatorButton(
                      pageChanged: prevPage, 
                      buttonColor: AppColors.white, 
                      text: "Trước", 
                      textColor: AppColors.black
                    ),
                  ),
                  ...List.generate(3, (idx) => _buildDot(idx)),
                  _navigatorButton(
                    pageChanged: nextPage, 
                    buttonColor: AppColors.green, 
                    text: _currentPage == 2 ? "Bắt đầu" : "Tiếp theo", 
                    textColor: AppColors.white
                  )
                ],
              )
            ],
          ),
        ),
      )
    );
  }

  Widget _buildDot(int currentPage){
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        width: currentPage == _currentPage ? 16 : 8,
        height: 8,
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: currentPage == _currentPage ? Colors.white : Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _navigatorButton({
    required VoidCallback pageChanged,
    required Color buttonColor,
    required String text,
    required Color textColor
  }) {
    return GestureDetector(
      onTap: pageChanged,
      child: Container(
        width: 100,
        height: 50,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(12)
        ),
      ),
    );
  }

  Widget _buildPage({
    required String image,
    required String title,
    required String desc,
    required bool isFirst
  }){
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 33),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _floatAnimation, 
                builder: (context, _) {
                  return Transform.translate(
                    offset: Offset(0, -_floatAnimation.value),
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(image, fit: BoxFit.cover),
                      ),
                    ),
                  );
                }
              ),
              SizedBox(height: 20),
              Text(title,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w800
                ),
              ),
              SizedBox(height: 11),
              Text(desc,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}