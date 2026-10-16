/// Fixtures for the University module picker (CW16b-M), shaped from
/// `contract/openapi.yaml` (`listModules`, `listSubjects`) - not hand-invented.
///
/// The University subjects and the two modules mirror the shape of Seif's
/// staging account U1 (message of 2026-10-13): two modules in term 1, both
/// holding Physiology, with Anatomy, Biochemistry and Histology in NO module.
/// Test data, like the mock backend's.
library;

import 'package:level_up_app/features/catalog/models/catalog_module.dart';
import 'package:level_up_app/features/catalog/models/subject.dart';

import 'catalog_fixtures.dart';

/// One `GET /catalog/modules` item. `termId` / `termNumber` are left OUT unless
/// given - both are optional on the wire.
Map<String, dynamic> moduleJson({
  required String id,
  required String name,
  int displayOrder = 1,
  String? termId,
  int? termNumber,
  List<String> subjectIds = const <String>[],
}) => <String, dynamic>{
  'id': id,
  'name': name,
  'displayOrder': displayOrder,
  'termId': ?termId,
  'termNumber': ?termNumber,
  'subjectIds': subjectIds,
};

CatalogModule module({
  required String id,
  required String name,
  int displayOrder = 1,
  int? termNumber,
  List<String> subjectIds = const <String>[],
}) => CatalogModule.fromJson(
  moduleJson(
    id: id,
    name: name,
    displayOrder: displayOrder,
    termNumber: termNumber,
    subjectIds: subjectIds,
  ),
);

/// U1's two modules, in the order the server sends them.
List<CatalogModule> u1Modules() => [
  module(
    id: 'mod-foundation',
    name: 'Foundation Module',
    displayOrder: 1,
    termNumber: 1,
    subjectIds: const ['uni-physio'],
  ),
  module(
    id: 'mod-cardio',
    name: 'Cardiovascular Module',
    displayOrder: 2,
    termNumber: 1,
    subjectIds: const ['uni-physio'],
  ),
];

/// A University student's subjects, in the order `GET /catalog/subjects`
/// serves them. Four ids so "in a module" and "in none" are both visible.
List<Subject> universitySubjects() => [
  _subject('uni-anatomy', 'Anatomy', 132, 400),
  _subject('uni-physio', 'Physiology', 400, 400),
  _subject('uni-biochem', 'Biochemistry', 0, 0),
  _subject('uni-histology', 'Histology', 58, 210),
];

Subject _subject(String id, String name, int answered, int total) =>
    Subject.fromJson(<String, dynamic>{
      'id': id,
      'name': name,
      'questionCounter': counterJson(answered, total),
    });
