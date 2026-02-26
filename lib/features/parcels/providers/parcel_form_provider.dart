import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final List<String> photos;

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
    this.photos = const [],
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
    List<String>? photos,
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
      photos: photos ?? this.photos,
    );
  }
}

class ParcelFormNotifier extends StateNotifier<ParcelFormState> {
  ParcelFormNotifier() : super(ParcelFormState());

  void updateLocation({String? commune, String? quarter, String? address, double? lat, double? lng}) {
    state = state.copyWith(
      commune: commune,
      quarter: quarter,
      address: address,
      latitude: lat,
      longitude: lng,
    );
  }

  void nextStep() => state = state.copyWith(currentStep: state.currentStep + 1);
  void prevStep() => state = state.copyWith(currentStep: state.currentStep - 1);
  
  void setType(String type) => state = state.copyWith(type: type);
  
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

  void reset() => state = ParcelFormState();
}

final parcelFormProvider = StateNotifierProvider<ParcelFormNotifier, ParcelFormState>((ref) {
  return ParcelFormNotifier();
});
