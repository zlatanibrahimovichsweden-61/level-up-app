import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../guards/rules.dart';
import 'contract_inline.dart';

/// The reader the CW04b / CW05 / CW06 contract pins are built on. A pin that
/// reads nothing would pass for every model, so the reader itself is held to
/// account here: it must find what is there, and it must RAISE - never return
/// an empty answer - when something is not.
void main() {
  const fixture = '''
openapi: 3.1.0
paths:
  /things:
    get:
      operationId: listThings
      x-stability: stable
      security: []
      responses:
        '200':
          description: ok
          content:
            application/json:
              schema:
                type: object
                properties:
                  alpha: { type: string }
                  beta:  { type: [string, "null"] }
                required: [alpha, beta]
        '404':
          description: nope
    post:
      operationId: makeThing
      x-stability: draft
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                name: { type: string }
                size: { type: integer }
              required: [name]
      responses:
        '204': { description: made }
  /other:
    get:
      operationId: other
      responses:
        '200':
          description: ok
components:
  schemas:
    Thing:
      type: object
''';

  final get = ContractOperation.find(fixture, path: '/things', method: 'get');
  final post = ContractOperation.find(fixture, path: '/things', method: 'post');

  test('finds an operation by path and method, and only that one', () {
    expect(get.operationId, 'listThings');
    expect(post.operationId, 'makeThing');
    expect(get.text, isNot(contains('makeThing')));
    expect(get.text, isNot(contains('/other')));
  });

  test('reads stability and anonymity from the operation itself', () {
    expect(get.isStable, isTrue);
    expect(get.isAnonymous, isTrue);
    expect(post.isStable, isFalse);
    expect(post.isAnonymous, isFalse);
  });

  test('reads a response schema\'s required list and property names', () {
    expect(get.responseRequired('200'), ['alpha', 'beta']);
    expect(get.responseProperties('200'), ['alpha', 'beta']);
    expect(get.hasResponse('200'), isTrue);
    expect(get.hasResponse('404'), isTrue);
    expect(get.hasResponse('500'), isFalse);
  });

  test('reads a request schema, skipping the body\'s own `required: true`', () {
    expect(post.requestRequired(), ['name']);
    expect(post.requestProperties(), ['name', 'size']);
  });

  test('raises, rather than returning empty, when something is not there', () {
    expect(
      () => ContractOperation.find(fixture, path: '/nope', method: 'get'),
      throwsA(isA<ContractShapeException>()),
    );
    expect(
      () => ContractOperation.find(fixture, path: '/other', method: 'post'),
      throwsA(isA<ContractShapeException>()),
    );
    expect(
      () => get.responseRequired('500'),
      throwsA(isA<ContractShapeException>()),
    );
    // `/other` has a 200 with no schema: nothing to read is an error, not [].
    final other = ContractOperation.find(
      fixture,
      path: '/other',
      method: 'get',
    );
    expect(
      () => other.responseRequired('200'),
      throwsA(isA<ContractShapeException>()),
    );
    expect(() => get.requestRequired(), throwsA(isA<ContractShapeException>()));
  });

  group('missingModelFields', () {
    const dart = '''
class A {
  const A({required this.one, required this.two});
  final String one;
  final String two;
}

class B {
  const B({required this.three});
  final String three;
}
''';

    test('names exactly the fields the class does not take', () {
      expect(missingModelFields(dart, 'A', ['one', 'two']), isEmpty);
      expect(missingModelFields(dart, 'A', ['one', 'two', 'three']), ['three']);
    });

    test('is scoped to the one class: another class cannot answer for it', () {
      expect(missingModelFields(dart, 'B', ['one']), ['one']);
    });

    test('a comment that mentions a field does not model it', () {
      const commented = '''
class C {
  const C({required this.a});
  // b is not modelled
  final String a;
}
''';
      expect(missingModelFields(commented, 'C', ['a', 'b']), ['b']);
    });

    test('raises for a class that is not declared', () {
      expect(
        () => missingModelFields(dart, 'Nope', ['one']),
        throwsA(isA<ContractShapeException>()),
      );
    });
  });

  test('against the real pinned contract: the eight operations of this change '
      'are all there, stable, with the stated anonymity', () {
    final yaml = File('contract/openapi.yaml').readAsStringSync();
    final expected = <(String, String, String, bool)>[
      ('/me/terms-acceptance', 'get', 'getTermsAcceptance', false),
      ('/me/terms-acceptance', 'post', 'acceptTerms', false),
      ('/me/deletion-request', 'post', 'requestAccountDeletion', false),
      ('/me/deletion-request', 'delete', 'cancelAccountDeletion', false),
      ('/auth/recovery/start', 'post', 'startRecovery', true),
      ('/auth/recovery/verify-parent', 'post', 'verifyParentOtp', true),
      ('/auth/recovery/new-phone', 'post', 'submitNewPhone', true),
      ('/auth/recovery/confirm', 'post', 'confirmRecovery', true),
    ];
    for (final (path, method, id, anonymous) in expected) {
      final op = ContractOperation.find(yaml, path: path, method: method);
      expect(op.operationId, id, reason: '$method $path');
      expect(op.isStable, isTrue, reason: id);
      expect(op.isAnonymous, anonymous, reason: id);
    }
  });
}
