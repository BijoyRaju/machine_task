// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Machine Task';

  @override
  String get splashLoading => 'Loading...';

  @override
  String get loginTitle => 'Welcome Back';

  @override
  String get loginSubtitle => 'Sign in with Google to continue';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get homeTitle => 'Users';

  @override
  String get profileTitle => 'Profile';

  @override
  String get noNetworkTitle => 'No Internet Connection';

  @override
  String get noNetworkMessage =>
      'Please check your internet connection and try again.';

  @override
  String get retry => 'Retry';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get name => 'Name';

  @override
  String get email => 'Email';

  @override
  String get avatar => 'Avatar';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get createUser => 'Create User';

  @override
  String get editUser => 'Edit User';

  @override
  String get userCreated => 'User created successfully';

  @override
  String get userUpdated => 'User updated successfully';

  @override
  String get userDeleted => 'User deleted successfully';

  @override
  String get confirmDelete => 'Are you sure you want to delete this user?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirm => 'Are you sure you want to logout?';

  @override
  String get noUsersFound => 'No users found';

  @override
  String get pullToRefresh => 'Pull to refresh';

  @override
  String get loadMore => 'Load More';

  @override
  String get offlineMode =>
      'You are currently offline. Some features may not be available.';

  @override
  String get networkError => 'Network error. Please check your connection.';

  @override
  String get serverError => 'Server error. Please try again later.';

  @override
  String get unknownError => 'An unknown error occurred.';

  @override
  String get welcome => 'Welcome';

  @override
  String get userProfile => 'User Profile';

  @override
  String get signOut => 'Sign Out';
}
