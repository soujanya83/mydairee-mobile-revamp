import 'dart:async';

import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/settings/parent_setting/data/model/parent_model.dart';
import 'package:mydiaree/features/settings/staff_setting/data/model/staff_model.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/apiresoponse.dart'; 

class ParentRepository {
  static List<Map<String, dynamic>> dummyParentData = [
    {
      'id': '270',
      'name': 'Test Parents',
      'email': 'testingparentemail@mydiaree.com',
      'password': '',
      'contactNo': '5487986598',
      'gender': 'MALE',
      'avatarUrl': 'https://mydiaree.com.au/assets/img/xs/avatar9.jpg',
      'children': [
        {'name': 'David Meklyn', 'role': 'Father'},
      ],
    },
    {
      'id': '319',
      'name': 'Test Parents',
      'email': 'testingparentemail@mydiaree.com',
      'password': '',
      'contactNo': '5487986598',
      'gender': 'MALE',
      'avatarUrl': 'https://mydiaree.com.au/assets/img/xs/avatar10.jpg',
      'children': [
        {'name': 'David Meklyn', 'role': 'Father'},
        {'name': 'David Meklyn', 'role': 'Father'},
        {'name': 'David Meklyn', 'role': 'Father'},
      ],
    },
    {
      'id': '321',
      'name': 'Test Parents',
      'email': 'testingparentemail@mydiaree.com',
      'password': '',
      'contactNo': '5487986598',
      'gender': 'MALE',
      'avatarUrl': 'https://mydiaree.com.au/assets/img/xs/avatar1.jpg',
      'children': [
        {'name': 'David Meklyn', 'role': 'Father'},
        {'name': 'Arpita Saxsena', 'role': 'Sister'},
      ],
    },
    {
      'id': '322',
      'name': 'Test Parents',
      'email': 'testingparentemail@mydiaree.com',
      'password': '',
      'contactNo': '5487986598',
      'gender': 'MALE',
      'avatarUrl': 'https://mydiaree.com.au/assets/img/xs/avatar10.jpg',
      'children': [
        {'name': 'David Meklyn', 'role': 'Father'},
      ],
    },
    {
      'id': '372',
      'name': 'testing Parent',
      'email': 'parebt@email',
      'password': '',
      'contactNo': '4578457854',
      'gender': 'MALE',
      'avatarUrl': 'https://mydiaree.com.au/uploads/parents/1749416910.jpg',
      'children': [
        {'name': 'David Meklyn', 'role': 'Father'},
        {'name': 'Izabella Mathews', 'role': 'Mother'},
      ],
    },
    {
      'id': '373',
      'name': 'new parents test',
      'email': 'test@parentnew',
      'password': '',
      'contactNo': '215487985',
      'gender': 'MALE',
      'avatarUrl': 'https://mydiaree.com.au/uploads/parents/1749417717.jpg',
      'children': [
        {'name': 'Iron Man Avenger', 'role': 'Mother'},
        {'name': 'Saga Sagar', 'role': 'Father'},
      ],
    },
  ];

  Future<List<ParentModel>> getParents() async {
    await Future.delayed(Duration(seconds: 3));
    return dummyParentData.map((data) => ParentModel.fromJson(data)).toList();
  }

  Future<ApiResponse> addParent({
    required String name,
    required String email,
    required String password,
    required String contactNo,
    required String gender,
    required String avatarUrl,
    required List<Map<String, String>> children,
  }) async {
    return await postAndParse(
      AppUrls.parentStore,
      dummy: true,
      {
        'name': name,
        'email': email,
        'password': password,
        'contactNo': contactNo,
        'gender': gender,
        'avatarUrl': avatarUrl,
        'children': children,
      },
    );
  }

  Future<ApiResponse> updateParent({
    required String id,
    required String name,
    required String email,
    required String password,
    required String contactNo,
    required String gender,
    required String avatarUrl,
    required List<Map<String, String>> children,
  }) async {
    return await postAndParse(
      '${AppUrls.parentUpdate}/$id',
      dummy: true,
      {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'contactNo': contactNo,
        'gender': gender,
        'avatarUrl': avatarUrl,
        'children': children,
      },
    );
  }

  Future<ApiResponse> deleteParent(String parentId) async {
    return await postAndParse(
      '${AppUrls.parentDelete}/$parentId',
      dummy: true,
      {
        '_method': 'DELETE',
      },
    );
  }
}