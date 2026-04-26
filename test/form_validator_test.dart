import 'package:flutter_test/flutter_test.dart';
import 'package:TR/core/utils/form_validator.dart';

void main() {
  group('FormValidator', () {
    group('validateEmail', () {
      test('returns error for null email', () {
        expect(FormValidator.validateEmail(null), 'Email is required');
      });

      test('returns error for empty email', () {
        expect(FormValidator.validateEmail(''), 'Email is required');
      });

      test('returns error for whitespace-only email', () {
        expect(FormValidator.validateEmail('   '), 'Email is required');
      });

      test('returns error for invalid email format', () {
        expect(FormValidator.validateEmail('invalid'), 'Please enter a valid email address');
        expect(FormValidator.validateEmail('invalid@'), 'Please enter a valid email address');
        expect(FormValidator.validateEmail('@invalid.com'), 'Please enter a valid email address');
      });

      test('returns null for valid email', () {
        expect(FormValidator.validateEmail('test@example.com'), null);
        expect(FormValidator.validateEmail('user.name@domain.co'), null);
        expect(FormValidator.validateEmail('user+tag@example.org'), null);
      });
    });

    group('validatePassword', () {
      test('returns error for null password', () {
        expect(FormValidator.validatePassword(null), 'Password is required');
      });

      test('returns error for empty password', () {
        expect(FormValidator.validatePassword(''), 'Password is required');
      });

      test('returns error for password less than 6 characters', () {
        expect(FormValidator.validatePassword('12345'), 'Password must be at least 6 characters');
      });

      test('returns null for valid password', () {
        expect(FormValidator.validatePassword('123456'), null);
        expect(FormValidator.validatePassword('password123'), null);
      });
    });

    group('validateName', () {
      test('returns error for null name', () {
        expect(FormValidator.validateName(null), 'Name is required');
      });

      test('returns error for empty name', () {
        expect(FormValidator.validateName(''), 'Name is required');
      });

      test('returns error for name less than 2 characters', () {
        expect(FormValidator.validateName('A'), 'Name must be at least 2 characters');
      });

      test('returns null for valid name', () {
        expect(FormValidator.validateName('Jo'), null);
        expect(FormValidator.validateName('John Doe'), null);
      });
    });

    group('validatePhone', () {
      test('returns error for null phone', () {
        expect(FormValidator.validatePhone(null), 'Phone number is required');
      });

      test('returns error for empty phone', () {
        expect(FormValidator.validatePhone(''), 'Phone number is required');
      });

      test('returns error for phone less than 10 digits', () {
        expect(FormValidator.validatePhone('123456789'), 'Please enter a valid phone number');
      });

      test('returns null for valid phone', () {
        expect(FormValidator.validatePhone('1234567890'), null);
        expect(FormValidator.validatePhone('0123456789'), null);
      });
    });

    group('validateRequired', () {
      test('returns error for null value', () {
        expect(FormValidator.validateRequired(null, 'Field'), 'Field is required');
      });

      test('returns error for empty value', () {
        expect(FormValidator.validateRequired('', 'Field'), 'Field is required');
      });

      test('returns null for valid value', () {
        expect(FormValidator.validateRequired('value', 'Field'), null);
      });
    });
  });
}