class AppConstants {
  // 網站基礎 URL
  static const String baseUrl = 'https://demo.wehood.org';

  // Member 各頁面 URL
  static const String memberLoginUrl = '$baseUrl/member/loginmember.php';
  static const String memberHomeUrl = '$baseUrl/member/member.php';
  static const String shopProductUrl = '$baseUrl/member/shopproduct.php';
  static const String attendUrl = '$baseUrl/member/member.php';  // 出席通過首頁掃碼
  static const String volunteerUrl = '$baseUrl/member/volunteer.php';
  static const String accountUrl = '$baseUrl/member/account.php';
  static const String messageUrl = '$baseUrl/member/message.php';
  static const String signingUrl = '$baseUrl/member/member_signing.php';
  static const String signedUrl = '$baseUrl/member/member_signed.php';
  static const String lastedUrl = '$baseUrl/member/member_lasted.php';
  static const String productUrl = '$baseUrl/member/product.php';
  static const String couponUrl = '$baseUrl/member/coupon.php';
  static const String exchangeUrl = '$baseUrl/member/exchange.php';
  static const String scoreUrl = '$baseUrl/member/score.php';
  static const String qrcodeUrl = '$baseUrl/member/qrcode.php';
  static const String quizUrl = '$baseUrl/member/quiz.php';
  static const String privacyUrl = '$baseUrl/member/privacy.php';

  // App 標識 User-Agent（讓服務器知道是 App 訪問）
  static const String userAgent =
      'Mozilla/5.0 (Linux; Android 10; WehoodApp) '
      'AppleWebKit/537.36 (KHTML, like Gecko) '
      'Chrome/120.0.0.0 Mobile Safari/537.36 '
      'WehoodMemberApp/1.0';

  // App 信息
  static const String appName = 'DEEPSEE 睇下仙';
  static const String appVersion = '1.0.0';
}
