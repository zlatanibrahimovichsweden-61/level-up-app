import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:mocktail/mocktail.dart';

class _MockFss extends Mock implements FlutterSecureStorage {}

void main() {
  late _MockFss fss;
  late SecureStorage storage;
  late Map<String, String> backing;

  setUp(() {
    fss = _MockFss();
    backing = {};
    when(
      () => fss.read(key: any(named: 'key')),
    ).thenAnswer((inv) async => backing[inv.namedArguments[#key] as String]);
    when(
      () => fss.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((inv) async {
      backing[inv.namedArguments[#key] as String] =
          inv.namedArguments[#value] as String;
    });
    when(() => fss.delete(key: any(named: 'key'))).thenAnswer((inv) async {
      backing.remove(inv.namedArguments[#key] as String);
    });
    when(() => fss.deleteAll()).thenAnswer((_) async => backing.clear());
    storage = SecureStorage(fss);
  });

  test('clearTokens() deletes tokens but PRESERVES the device id', () async {
    final id = await storage.readOrCreateDeviceId();
    await storage.writeTokens(access: 'a', refresh: 'r');

    await storage.clearTokens();

    expect(await storage.readAccessToken(), isNull);
    expect(await storage.readRefreshToken(), isNull);
    // Same device id after logout → the next login is NOT mistaken for a new
    // device (which would mis-trigger session_superseded).
    expect(await storage.readOrCreateDeviceId(), id);
  });

  test('clear() wipes everything, including the device id', () async {
    final id = await storage.readOrCreateDeviceId();
    await storage.clear();
    // A brand-new id is generated → differs from the wiped one.
    expect(await storage.readOrCreateDeviceId(), isNot(id));
  });
}
