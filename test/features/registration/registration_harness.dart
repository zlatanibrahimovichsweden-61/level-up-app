import 'dart:async';

import 'package:flutter/material.dart';
import 'package:level_up_app/features/registration/models/reference_models.dart';
import 'package:level_up_app/features/registration/models/registration_args.dart';
import 'package:level_up_app/features/registration/repository/reference_repository.dart';
import 'package:mocktail/mocktail.dart';

/// Shared fixtures + stubs for the two track-detail screen tests. Payload shapes
/// mirror the contract's `/reference/*` responses.

class MockReferenceRepository extends Mock implements ReferenceRepository {}

const regArgs = RegistrationArgs(
  registrationToken: 'reg.token',
  expiresInSeconds: 600,
  phone: '+201555000111',
);

Widget marker(String text) => Scaffold(body: Center(child: Text(text)));

const countries = [
  Country(code: 'EG', nameAr: 'مصر', nameEn: 'Egypt', requiresGovernorate: true),
  Country(
    code: 'AE',
    nameAr: 'الإمارات',
    nameEn: 'UAE',
    requiresGovernorate: false,
  ),
];

const governorates = [
  NamedRef(id: 'gov-cairo', nameAr: 'القاهرة', nameEn: 'Cairo'),
  NamedRef(id: 'gov-giza', nameAr: 'الجيزة', nameEn: 'Giza'),
];

const cities = [
  NamedRef(id: 'city-nasr', nameAr: 'مدينة نصر', nameEn: 'Nasr City'),
  NamedRef(id: 'city-maadi', nameAr: 'المعادي', nameEn: 'Maadi'),
];

const educationSystems = [
  EducationSystemRef(code: 'ig', nameAr: 'آي جي', nameEn: 'IG'),
  EducationSystemRef(
    code: 'nationalArabic',
    nameAr: 'وطني عربي',
    nameEn: 'National Arabic',
  ),
];

const schoolsPage = CursorPage<NamedRef>(
  items: [NamedRef(id: 'school-42', nameAr: 'مدرسة النيل', nameEn: 'Nile School')],
  hasMore: false,
);

/// One university with two faculties; the second faculty carries a `soon` year
/// that must never be selectable.
const universities = [
  UniversityRef(
    id: 'uni-cairo',
    nameAr: 'جامعة القاهرة',
    nameEn: 'Cairo University',
    faculties: [
      FacultyRef(
        id: 'fac-medicine',
        nameAr: 'كلية الطب',
        nameEn: 'Faculty of Medicine',
        years: [
          StudyYearRef(id: 'year-1', yearNumber: 1, status: 'active'),
          StudyYearRef(id: 'year-2', yearNumber: 2, status: 'active'),
          // Contract: `soon` years answer validation_failed — never offered.
          StudyYearRef(id: 'year-3', yearNumber: 3, status: 'soon'),
        ],
      ),
      FacultyRef(
        id: 'fac-pharmacy',
        nameAr: 'كلية الصيدلة',
        nameEn: 'Faculty of Pharmacy',
        years: [StudyYearRef(id: 'year-p1', yearNumber: 1, status: 'active')],
      ),
    ],
  ),
  UniversityRef(
    id: 'uni-ain-shams',
    nameAr: 'جامعة عين شمس',
    nameEn: 'Ain Shams University',
    faculties: [],
  ),
];

/// Every reference endpoint resolving successfully.
void stubReferenceHappyPath(MockReferenceRepository repo) {
  when(repo.getCountries).thenAnswer((_) async => countries);
  when(() => repo.getGovernorates(any())).thenAnswer((_) async => governorates);
  when(
    () => repo.getCities(
      countryCode: any(named: 'countryCode'),
      governorateId: any(named: 'governorateId'),
    ),
  ).thenAnswer((_) async => cities);
  when(repo.getEducationSystems).thenAnswer((_) async => educationSystems);
  when(repo.getUniversities).thenAnswer((_) async => universities);
  when(repo.getAvatars).thenAnswer((_) async => const []);
  when(
    () => repo.searchSchools(
      q: any(named: 'q'),
      governorateId: any(named: 'governorateId'),
      cityId: any(named: 'cityId'),
      cursor: any(named: 'cursor'),
      limit: any(named: 'limit'),
    ),
  ).thenAnswer((_) async => schoolsPage);
}

/// Leaves `/reference/countries` in flight so the Loading state can be asserted.
Completer<List<Country>> stubCountriesPending(MockReferenceRepository repo) {
  final completer = Completer<List<Country>>();
  when(repo.getCountries).thenAnswer((_) => completer.future);
  return completer;
}
