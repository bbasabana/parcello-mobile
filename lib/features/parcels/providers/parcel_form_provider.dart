import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:parcello_mobile/core/database/database_helper.dart';
import 'package:parcello_mobile/core/api/api_client.dart';
import 'package:parcello_mobile/features/auth/providers/auth_provider.dart';

class Resident {
  String firstName;
  String lastName;
  String? postName;
  String sex;
  String role;
  String? photo;

  Resident({
    required this.firstName,
    required this.lastName,
    this.postName,
    required this.sex,
    required this.role,
    this.photo,
  });

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'postName': postName,
    'sex': sex,
    'role': role,
    'photo': photo,
  };
}

class Apartment {
  String name;
  String type;
  List<Resident> residents;

  Apartment({
    required this.name,
    required this.type,
    this.residents = const [],
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'type': type,
    'residents': residents.map((r) => r.toJson()).toList(),
  };
}

class ParcelFormState {
  final int currentStep;
  final String? commune;
  final String? quarter;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? type;
  final List<String> mixedTypes;
  final double? area;
  final Map<String, dynamic> ownerData;
  final List<Apartment> apartments;
  final String? mapPhoto;
  final String? parcelPhoto;
  final String? idCardPhoto;
  final bool isSubmitting;
  final Map<String, bool> uploadingPhotos;
  final String? error;

  ParcelFormState({
    this.currentStep = 0,
    this.commune,
    this.quarter,
    this.address,
    this.latitude,
    this.longitude,
    this.type,
    this.mixedTypes = const [],
    this.area,
    this.ownerData = const {},
    this.apartments = const [],
    this.mapPhoto,
    this.parcelPhoto,
    this.idCardPhoto,
    this.isSubmitting = false,
    this.uploadingPhotos = const {},
    this.error,
  });

  ParcelFormState copyWith({
    int? currentStep,
    String? commune,
    String? quarter,
    String? address,
    double? latitude,
    double? longitude,
    String? type,
    List<String>? mixedTypes,
    double? area,
    Map<String, dynamic>? ownerData,
    List<Apartment>? apartments,
    String? mapPhoto,
    String? parcelPhoto,
    String? idCardPhoto,
    bool? isSubmitting,
    Map<String, bool>? uploadingPhotos,
    String? error,
  }) {
    return ParcelFormState(
      currentStep: currentStep ?? this.currentStep,
      commune: commune ?? this.commune,
      quarter: quarter ?? this.quarter,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      type: type ?? this.type,
      mixedTypes: mixedTypes ?? this.mixedTypes,
      area: area ?? this.area,
      ownerData: ownerData ?? this.ownerData,
      apartments: apartments ?? this.apartments,
      mapPhoto: mapPhoto ?? this.mapPhoto,
      parcelPhoto: parcelPhoto ?? this.parcelPhoto,
      idCardPhoto: idCardPhoto ?? this.idCardPhoto,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      uploadingPhotos: uploadingPhotos ?? this.uploadingPhotos,
      error: error ?? this.error,
    );
  }

  Map<String, dynamic> toJson() => {
    'commune': commune,
    'quarter': quarter,
    'address': address,
    'latitude': latitude,
    'longitude': longitude,
    'type': type,
    'mixedTypes': mixedTypes,
    'area': area,
    'ownerData': ownerData,
    'apartments': apartments.map((a) => a.toJson()).toList(),
    'mapPhoto': mapPhoto,
    'parcelPhoto': parcelPhoto,
    'idCardPhoto': idCardPhoto,
  };
}

class ParcelFormNotifier extends StateNotifier<ParcelFormState> {
  final Ref _ref;

  ParcelFormNotifier(this._ref) : super(ParcelFormState());

  void updateLocation({String? commune, String? quarter, String? address, double? lat, double? lng}) {
    state = state.copyWith(
      commune: commune ?? state.commune,
      quarter: quarter ?? state.quarter,
      address: address ?? state.address,
      latitude: lat ?? state.latitude,
      longitude: lng ?? state.longitude,
    );
  }

  void nextStep() => state = state.copyWith(currentStep: state.currentStep + 1);
  void prevStep() => state = state.copyWith(currentStep: state.currentStep - 1);
  
  void setType(String type) {
    if (type == 'MIXED') {
      state = state.copyWith(type: type);
    } else {
      state = state.copyWith(type: type, mixedTypes: []); 
    }
  }

  void toggleMixedType(String type) {
    final current = List<String>.from(state.mixedTypes);
    if (current.contains(type)) {
      current.remove(type);
    } else {
      current.add(type);
    }
    state = state.copyWith(mixedTypes: current);
  }

  
  void updateOwner(Map<String, dynamic> data) {
    state = state.copyWith(ownerData: {...state.ownerData, ...data});
  }

  void addApartment(String name, String type) {
    final newApartment = Apartment(name: name, type: type);
    state = state.copyWith(apartments: [...state.apartments, newApartment]);
  }

  void removeApartment(int index) {
    final newList = List<Apartment>.from(state.apartments)..removeAt(index);
    state = state.copyWith(apartments: newList);
  }

  void addResident(int apartmentIndex, Resident resident) {
    final apartments = List<Apartment>.from(state.apartments);
    final apartment = apartments[apartmentIndex];
    apartments[apartmentIndex] = Apartment(
      name: apartment.name,
      type: apartment.type,
      residents: [...apartment.residents, resident],
    );
    state = state.copyWith(apartments: apartments);
  }

  void removeResident(int apartmentIndex, int residentIndex) {
    final apartments = List<Apartment>.from(state.apartments);
    final apartment = apartments[apartmentIndex];
    final residents = List<Resident>.from(apartment.residents)..removeAt(residentIndex);
    apartments[apartmentIndex] = Apartment(
      name: apartment.name,
      type: apartment.type,
      residents: residents,
    );
    state = state.copyWith(apartments: apartments);
  }

  Future<String?> _uploadPhoto(String path) async {
    try {
      final apiClient = _ref.read(apiClientProvider);
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(path),
        'parcelId': 'new_parcel', // Could be more specific if editing existing
      });

      final response = await apiClient.dio.post('/upload', data: formData);
      if (response.data['success'] == true) {
        return response.data['url'] as String;
      }
    } catch (e) {
      print('Upload error: $e');
    }
    return null;
  }

  void addPhoto(String type, String path) async {
    // 1. Set local path immediately for UI feedback and set uploading status
    final uploading = Map<String, bool>.from(state.uploadingPhotos);
    uploading[type] = true;

    if (type == 'mapPhoto') {
      state = state.copyWith(mapPhoto: path, uploadingPhotos: uploading);
    } else if (type == 'parcelPhoto') {
      state = state.copyWith(parcelPhoto: path, uploadingPhotos: uploading);
    } else if (type == 'idCardPhoto') {
      state = state.copyWith(idCardPhoto: path, uploadingPhotos: uploading);
    }

    // 2. Try to upload if online
    final results = await Connectivity().checkConnectivity();
    if (results.any((r) => r != ConnectivityResult.none)) {
      final url = await _uploadPhoto(path);
      
      final updatedUploading = Map<String, bool>.from(state.uploadingPhotos);
      updatedUploading[type] = false;

      if (url != null) {
        if (type == 'mapPhoto') {
          state = state.copyWith(mapPhoto: url, uploadingPhotos: updatedUploading);
        } else if (type == 'parcelPhoto') {
          state = state.copyWith(parcelPhoto: url, uploadingPhotos: updatedUploading);
        } else if (type == 'idCardPhoto') {
          state = state.copyWith(idCardPhoto: url, uploadingPhotos: updatedUploading);
        }
      } else {
        state = state.copyWith(uploadingPhotos: updatedUploading);
      }
    } else {
      final updatedUploading = Map<String, bool>.from(state.uploadingPhotos);
      updatedUploading[type] = false;
      state = state.copyWith(uploadingPhotos: updatedUploading);
    }
  }

  Future<bool> submit() async {
    state = state.copyWith(isSubmitting: true, error: null);
    
    final results = await Connectivity().checkConnectivity();
    final isOnline = results.any((r) => r != ConnectivityResult.none);

    if (isOnline) {
      try {
        final apiClient = _ref.read(apiClientProvider);
        await apiClient.dio.post('/parcels', data: state.toJson());
        state = state.copyWith(isSubmitting: false);
        return true;
      } catch (e) {
        print('Server submission failed, saving locally: $e');
        // fallthrough to offline save
      }
    }

    // Offline save as pending sync
    try {
      await DatabaseHelper().insertParcel(state.toJson(), status: 'pending');
      state = state.copyWith(isSubmitting: false, error: 'Enregistré localement (hors-ligne)');
      return true;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: 'Erreur d\'enregistrement: $e');
      return false;
    }
  }

  Future<bool> saveAsDraft() async {
    state = state.copyWith(isSubmitting: true, error: null);
    try {
      await DatabaseHelper().insertParcel(state.toJson(), status: 'draft');
      state = state.copyWith(isSubmitting: false, error: 'Brouillon sauvegardé avec succès');
      return true;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: 'Erreur sauvegarde brouillon: $e');
      return false;
    }
  }

  void reset() => state = ParcelFormState();
}


final parcelFormProvider = StateNotifierProvider<ParcelFormNotifier, ParcelFormState>((ref) {
  return ParcelFormNotifier(ref);
});

final draftParcelsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return await DatabaseHelper().getDrafts();
});
