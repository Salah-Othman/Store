import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('en'), Locale('ar')];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    final localizations = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
    assert(localizations != null, 'AppLocalizations not found in context');
    return localizations!;
  }

  static AppLocalizations fromLanguageCode(String languageCode) {
    return AppLocalizations(Locale(languageCode));
  }

  bool get isArabic => locale.languageCode == 'ar';

  String get appName => 'TR';
  String get adminDashboard =>
      isArabic ? 'لوحة تحكم المشرف' : 'Admin Dashboard';
  String get adminDashboardLoadError => isArabic
      ? 'تعذر تحميل بيانات لوحة التحكم'
      : 'Could not load dashboard data';
  String get totalProducts => isArabic ? 'إجمالي المنتجات' : 'Total Products';
  String get totalOrders => isArabic ? 'إجمالي الطلبات' : 'Total Orders';
  String get totalUsers => isArabic ? 'إجمالي المستخدمين' : 'Total Users';
  String get pendingOrdersLabel => isArabic ? 'طلبات معلقة' : 'Pending Orders';
  String get totalRevenue => isArabic ? 'إجمالي الإيرادات' : 'Total Revenue';
  String get recentOrders => isArabic ? 'أحدث الطلبات' : 'Recent Orders';
  String get productCatalog => isArabic ? 'المنتجات' : 'Product Catalog';
  String get customerAccounts =>
      isArabic ? 'حسابات العملاء' : 'Customer Accounts';
  String get orderDetails => isArabic ? 'تفاصيل الطلب' : 'Order Details';
  String get customerName => isArabic ? 'اسم العميل' : 'Customer Name';
  String get customerPhone => isArabic ? 'هاتف العميل' : 'Customer Phone';
  String get customerAddress => isArabic ? 'عنوان العميل' : 'Customer Address';
  String get itemName => isArabic ? 'اسم المنتج' : 'Item Name';
  String get itemPrice => isArabic ? 'سعر المنتج' : 'Item Price';
  String get quantity => isArabic ? 'الكمية' : 'Quantity';
  String get orderItems => isArabic ? 'عناصر الطلب' : 'Order Items';
  String get createdAtLabel => isArabic ? 'تاريخ الإنشاء' : 'Created At';
  String get statusLabel => isArabic ? 'الحالة' : 'Status';
  String get totalPriceLabel => isArabic ? 'السعر الإجمالي' : 'Total Price';
  String get adminNoProducts =>
      isArabic ? 'لا توجد منتجات لعرضها' : 'No products to display';
  String get adminNoUsers =>
      isArabic ? 'لا يوجد مستخدمون لعرضهم' : 'No users to display';
  String get available => isArabic ? 'متاح' : 'Available';
  String get outOfStock => isArabic ? 'غير متاح' : 'Out of Stock';
  String get adminRole => isArabic ? 'مشرف' : 'Admin';
  String get userRole => isArabic ? 'مستخدم' : 'User';
  String get roleUpdated =>
      isArabic ? 'تم تحديث الدور بنجاح' : 'Role updated successfully';
  String get cannotUpdateOwnRole => isArabic
      ? 'لا يمكن تعديل دور حسابك الحالي من هنا'
      : 'You cannot change your own role from here';
  String get makeAdmin => isArabic ? 'تعيين كمشرف' : 'Make Admin';
  String get makeUser => isArabic ? 'تعيين كمستخدم' : 'Make User';
  String get totalCategories =>
      isArabic ? 'إجمالي التصنيفات' : 'Total Categories';
  String get categoryCatalog => isArabic ? 'التصنيفات' : 'Category Catalog';
  String get adminNoCategories =>
      isArabic ? 'لا توجد تصنيفات لعرضها' : 'No categories to display';
  String get quickActions => isArabic ? 'إجراءات سريعة' : 'Quick Actions';
  String get addProduct => isArabic ? 'إضافة منتج' : 'Add Product';
  String get addCategory => isArabic ? 'إضافة تصنيف' : 'Add Category';
  String get productAdded =>
      isArabic ? 'تمت إضافة المنتج بنجاح' : 'Product added successfully';
  String get categoryAdded =>
      isArabic ? 'تمت إضافة التصنيف بنجاح' : 'Category added successfully';
  String get productName => isArabic ? 'اسم المنتج' : 'Product Name';
  String get categoryName => isArabic ? 'اسم التصنيف' : 'Category Name';
  String get imageUrl => isArabic ? 'رابط الصورة' : 'Image URL';
  String get price => isArabic ? 'السعر' : 'Price';
  String get availability => isArabic ? 'التوفر' : 'Availability';
  String get save => isArabic ? 'حفظ' : 'Save';
  String get cancel => isArabic ? 'إلغاء' : 'Cancel';
  String get home => isArabic ? 'الرئيسية' : 'Home';
  String get signInTitle => isArabic ? 'تسجيل الدخول' : 'Sign In';
  String get signInSubtitle => isArabic
      ? 'سجل دخولك للوصول إلى طلباتك وعناوينك المحفوظة.'
      : 'Sign in to access your orders and saved addresses.';
  String get signIn => isArabic ? 'تسجيل الدخول' : 'Sign In';
  String get signUp => isArabic ? 'إنشاء حساب' : 'Sign Up';
  String get createAccount => isArabic ? 'إنشاء حساب' : 'Create Account';
  String get signUpSubtitle => isArabic
      ? 'أدخل بياناتك الأساسية لإنشاء حساب جديد.'
      : 'Enter your details below to create a new account.';
  String get forgotPassword =>
      isArabic ? 'نسيت كلمة المرور؟' : 'Forgot Password?';
  String get resetPasswordTitle =>
      isArabic ? 'إعادة تعيين كلمة المرور' : 'Reset Password';
  String get resetPasswordSubtitle => isArabic
      ? 'أدخل بريدك الإلكتروني وسنرسل لك رابط إعادة تعيين كلمة المرور.'
      : 'Enter your email and we will send you a password reset link.';
  String get sendResetLink =>
      isArabic ? 'إرسال رابط إعادة التعيين' : 'Send Reset Link';
  String passwordResetSent(String email) => isArabic
      ? 'تم إرسال رابط إعادة التعيين إلى $email'
      : 'A password reset link was sent to $email';
  String get dontHaveAccount =>
      isArabic ? 'ليس لديك حساب؟' : 'Don\'t have an account?';
  String get emailAddress => isArabic ? 'البريد الإلكتروني' : 'Email Address';
  String get emailRequired => isArabic
      ? 'يرجى إدخال البريد الإلكتروني'
      : 'Please enter your email address';
  String get invalidEmail =>
      isArabic ? 'البريد الإلكتروني غير صالح' : 'The email address is invalid';
  String get password => isArabic ? 'كلمة المرور' : 'Password';
  String get passwordRequired =>
      isArabic ? 'يرجى إدخال كلمة المرور' : 'Please enter your password';
  String get passwordMinLength => isArabic
      ? 'يجب أن تكون كلمة المرور 6 أحرف على الأقل'
      : 'Password must be at least 6 characters';
  String get weakPassword =>
      isArabic ? 'كلمة المرور ضعيفة جدًا' : 'The password is too weak';
  String get invalidLoginCredentials => isArabic
      ? 'بيانات تسجيل الدخول غير صحيحة'
      : 'The email or password is incorrect';
  String get emailAlreadyInUse => isArabic
      ? 'هذا البريد الإلكتروني مستخدم بالفعل'
      : 'This email is already in use';
  String get nameRequired =>
      isArabic ? 'يرجى إدخال الاسم' : 'Please enter your name';
  String get fillAllRequiredFields => isArabic
      ? 'يرجى استكمال كل الحقول المطلوبة'
      : 'Please fill in all required fields';
  String get cart => isArabic ? 'سلة التسوق' : 'Shopping Bag';
  String get totalAmount => isArabic ? 'الإجمالي' : 'Total Amount';
  String get goToCheckout => isArabic ? 'الانتقال للدفع' : 'Go to Checkout';
  String get yourBagIsEmpty => isArabic ? 'سلتك فارغة' : 'Your bag is empty';
  String get myProfile => isArabic ? 'حسابي' : 'My Profile';
  String get guestUser => isArabic ? 'مستخدم زائر' : 'Guest User';
  String get signedInUser => isArabic ? 'مستخدم مسجل' : 'Signed In User';
  String guestSessionId(String id) =>
      isArabic ? 'معرف الجلسة: #$id' : 'Guest-Session-ID: #$id';
  String get myOrders => isArabic ? 'طلباتي' : 'My Orders';
  String get shippingAddresses =>
      isArabic ? 'عناوين الشحن' : 'Shipping Addresses';
  String get settings => isArabic ? 'الإعدادات' : 'Settings';
  String get helpCenter => isArabic ? 'مركز المساعدة' : 'Help Center';
  String get logout => isArabic ? 'تسجيل الخروج' : 'Log Out';
  String get version => isArabic ? 'الإصدار 1.0.0' : 'Version 1.0.0';
  String get appearance => isArabic ? 'المظهر' : 'Appearance';
  String get darkMode => isArabic ? 'الوضع الداكن' : 'Dark Mode';
  String get language => isArabic ? 'اللغة' : 'Language';
  String get english => isArabic ? 'الإنجليزية' : 'English';
  String get arabic => isArabic ? 'العربية' : 'Arabic';
  String get notifications => isArabic ? 'الإشعارات' : 'Notifications';
  String get pushNotifications =>
      isArabic ? 'إشعارات الدفع' : 'Push Notifications';
  String get pushNotificationsSubtitle => isArabic
      ? 'احفظ تفضيلك لاستخدامه لاحقًا مع تحديثات الطلبات'
      : 'Save your preference for future order updates';
  String get supportAndAbout =>
      isArabic ? 'الدعم والمعلومات' : 'Support & About';
  String get privacyPolicy => isArabic ? 'سياسة الخصوصية' : 'Privacy Policy';
  String get aboutAtelier => isArabic ? 'عن أتولييه' : 'About Atelier';
  String get chooseLanguage => isArabic ? 'اختر اللغة' : 'Choose Language';
  String get shippingAddress => isArabic ? 'عنوان الشحن' : 'Shipping Address';
  String get city => isArabic ? 'المدينة' : 'City';
  String get cityHint => isArabic ? 'مثال: القاهرة' : 'e.g. Cairo';
  String get areaDistrict => isArabic ? 'المنطقة / الحي' : 'Area / District';
  String get areaHint => isArabic ? 'مثال: القاهرة الجديدة' : 'e.g. New Cairo';
  String get streetName => isArabic ? 'اسم الشارع' : 'Street Name';
  String get streetHint => isArabic ? 'مثال: شارع التسعين' : 'e.g. 90th Street';
  String get buildingVilla =>
      isArabic ? 'رقم المبنى / الفيلا' : 'Building / Villa No.';
  String get buildingHint =>
      isArabic ? 'مثال: مبنى 12، الدور 3' : 'e.g. Building 12, Floor 3';
  String get saveAddress => isArabic ? 'حفظ العنوان' : 'Save Address';
  String get requiredField => isArabic ? 'هذا الحقل مطلوب' : 'Required field';
  String get addressSaved =>
      isArabic ? 'تم حفظ العنوان بنجاح' : 'Address saved successfully';
  String get checkout => isArabic ? 'إتمام الطلب' : 'Checkout';
  String get fullName => isArabic ? 'الاسم الكامل' : 'Full Name';
  String get phoneNumber => isArabic ? 'رقم الهاتف' : 'Phone Number';
  String get phoneNumberHint =>
      isArabic ? '+20 10 1234 5678' : '+1 555 123 4567';
  String get phoneRequired =>
      isArabic ? 'يرجى إدخال رقم الهاتف' : 'Please enter your phone number';
  String get authWelcomeTitle =>
      isArabic ? 'تسجيل الدخول برقم الهاتف' : 'Sign in with your phone';
  String get authWelcomeSubtitle => isArabic
      ? 'أدخل رقم هاتفك وسنرسل لك رمز تحقق لتسجيل الدخول الآمن.'
      : 'Enter your phone number and we will send a verification code for secure sign in.';
  String get sendVerificationCode =>
      isArabic ? 'إرسال رمز التحقق' : 'Send verification code';
  String get phoneAuthDisclaimer => isArabic
      ? 'قد يتم تطبيق رسوم الرسائل النصية المعتادة حسب شركة الاتصالات.'
      : 'Standard SMS rates may apply depending on your mobile carrier.';
  String get verifyCode => isArabic ? 'التحقق من الرمز' : 'Verify Code';
  String get enterVerificationCode =>
      isArabic ? 'أدخل رمز التحقق' : 'Enter the verification code';
  String codeSentTo(String phone) => isArabic
      ? 'أرسلنا رمزًا إلى $phone'
      : 'We sent a verification code to $phone';
  String get verificationCode => isArabic ? 'رمز التحقق' : 'Verification code';
  String get codeRequired => isArabic
      ? 'أدخل رمز التحقق المكوّن من 6 أرقام'
      : 'Enter the 6-digit verification code';
  String get verifyAndContinue =>
      isArabic ? 'تحقق واستمر' : 'Verify and continue';
  String get resendCode => isArabic ? 'إعادة إرسال الرمز' : 'Resend code';
  String get invalidPhoneNumber =>
      isArabic ? 'رقم الهاتف غير صالح' : 'The phone number is invalid';
  String get invalidVerificationCode =>
      isArabic ? 'رمز التحقق غير صحيح' : 'The verification code is invalid';
  String get codeExpired => isArabic
      ? 'انتهت صلاحية الرمز، أعد المحاولة'
      : 'The code has expired, please try again';
  String get tooManyRequests => isArabic
      ? 'عدد المحاولات كبير جدًا، حاول لاحقًا'
      : 'Too many requests. Please try again later.';
  String get networkRequestFailed => isArabic
      ? 'تحقق من اتصال الإنترنت ثم أعد المحاولة'
      : 'Check your internet connection and try again.';
  String get authUnknownError => isArabic
      ? 'تعذر إكمال تسجيل الدخول الآن'
      : 'We could not complete sign in right now.';
  String get detailedAddress =>
      isArabic ? 'العنوان بالتفصيل' : 'Detailed Address';
  String get confirmOrder => isArabic ? 'تأكيد الطلب' : 'Confirm Order';
  String get orderPlaced => isArabic ? 'تم إرسال الطلب' : 'Order Placed!';
  String orderPlacedMessage(String id) => isArabic
      ? 'رقم طلبك هو: $id\nسنتواصل معك قريبًا.'
      : 'Your order ID is: $id\nWe will contact you soon.';
  String get backToHome => isArabic ? 'العودة للرئيسية' : 'Back to Home';
  String get checkoutError => isArabic
      ? 'حدث خطأ أثناء إرسال الطلب، حاول مرة أخرى.'
      : 'Something went wrong while placing your order. Please try again.';
  String get orderHistory => isArabic ? 'سجل الطلبات' : 'Order History';
  String get noOrdersFound =>
      isArabic ? 'لا توجد طلبات حتى الآن.' : 'No orders found.';
  String get somethingWentWrong =>
      isArabic ? 'حدث خطأ ما' : 'Something went wrong';
  String orderNumber(String id) => isArabic ? 'طلب #$id' : 'Order #$id';
  String itemsCount(int count) => isArabic ? '$count عناصر' : '$count Items';
  String get addToCart => isArabic ? 'أضف إلى السلة' : 'Add to Cart';
  String get description => isArabic ? 'الوصف' : 'Description';
  String get addedToCart =>
      isArabic ? 'تمت الإضافة إلى السلة بنجاح' : 'Added to cart successfully!';
  String get pending => isArabic ? 'قيد الانتظار' : 'Pending';
  String get shipped => isArabic ? 'تم الشحن' : 'Shipped';
  String get delivered => isArabic ? 'تم التوصيل' : 'Delivered';

  String languageName(String code) {
    switch (code) {
      case 'ar':
        return arabic;
      case 'en':
      default:
        return english;
    }
  }

  String localizedOrderStatus(String status) {
    switch (status) {
      case 'Delivered':
        return delivered;
      case 'Shipped':
        return shipped;
      case 'Pending':
      default:
        return pending;
    }
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales.any(
    (supported) => supported.languageCode == locale.languageCode,
  );

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
