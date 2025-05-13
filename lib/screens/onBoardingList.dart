

class OnBoarding {
  String title;
  String img;
  String description;
  String description1;
  String description2;
  String description3;
  String des1;
  String des22;
  String des2;
  OnBoarding(
      {required this.title, required this.img,required this.description,
        required this.description1, required this.description2,
        required this.description3, required this.des1, required this.des2, required this.des22});
}

List<OnBoarding> page1 = [
  OnBoarding(
    title: "Hey Foodie 👋 \nWelcome to HomeMady, the app \nwhere you can order:",
    img: "assets/images/onBordingNew.JPG",
    des22: "assets/images/check.png",
    description: 'À la carte ',
    des1: '(individual dishes),',
    description1: 'Catering',
    des2: ' (big trays/pots of food for events)',
    description2: 'Meal Prep',
    description3: ' (large number of individual dishes)',
  ),
  OnBoarding(
    title: "Some items will be on sale for instant delivery, others may require a scheduled delivery (especially catering and meal prep), others can be collected by you. Most cooks will offer multiple delivery options 👍",
    img: "assets/images/Group 1000004213.png",
    description: '',
    des1: '',
    des22: '',
    des2: '',
    description1: '',
    description2: '',
    description3: '',
  ),
  OnBoarding(
    title: "You are ready to start your journey with HomeMady",
    img: "assets/images/Onboeading3.png",
    description: '',
    des1: '',
    des2: '',
    des22: '',
    description1: '',
    description2: '',
    description3: '',
  ),

];


class OnBoardModelResponse {
  final String? image, title, desc;

  OnBoardModelResponse({
    this.image,
    this.title,
    this.desc,
  });
}

List<OnBoardModelResponse> OnBoardingData = [
  OnBoardModelResponse(
      image: 'assets/images/onBorading_first.png',
      title: "You first",
      desc: 'We don’t charge you order fees. We don’t spy on you. We just help you enjoy your meals'
  ),
  OnBoardModelResponse(
      image: 'assets/images/onBorading2.png',
      title: "Beautifully-designed menus",
      desc: 'Every menu item is manually reviewed by our team'
  ),
  OnBoardModelResponse(
      image: 'assets/images/onborading3.png',
      title: "Unbeatable rates",
      desc: 'We don’t charge any order fees. Delivery fees go where they belong.'
  )
];