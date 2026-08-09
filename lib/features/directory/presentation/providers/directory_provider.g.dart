// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$alumniDirectoryHash() => r'e8a86024111e0da3d0e7d055a98d91dcd1361f2b';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [alumniDirectory].
@ProviderFor(alumniDirectory)
const alumniDirectoryProvider = AlumniDirectoryFamily();

/// See also [alumniDirectory].
class AlumniDirectoryFamily
    extends Family<AsyncValue<List<AlumniDirectoryModel>>> {
  /// See also [alumniDirectory].
  const AlumniDirectoryFamily();

  /// See also [alumniDirectory].
  AlumniDirectoryProvider call({
    String? department,
  }) {
    return AlumniDirectoryProvider(
      department: department,
    );
  }

  @override
  AlumniDirectoryProvider getProviderOverride(
    covariant AlumniDirectoryProvider provider,
  ) {
    return call(
      department: provider.department,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'alumniDirectoryProvider';
}

/// See also [alumniDirectory].
class AlumniDirectoryProvider
    extends AutoDisposeStreamProvider<List<AlumniDirectoryModel>> {
  /// See also [alumniDirectory].
  AlumniDirectoryProvider({
    String? department,
  }) : this._internal(
          (ref) => alumniDirectory(
            ref as AlumniDirectoryRef,
            department: department,
          ),
          from: alumniDirectoryProvider,
          name: r'alumniDirectoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$alumniDirectoryHash,
          dependencies: AlumniDirectoryFamily._dependencies,
          allTransitiveDependencies:
              AlumniDirectoryFamily._allTransitiveDependencies,
          department: department,
        );

  AlumniDirectoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.department,
  }) : super.internal();

  final String? department;

  @override
  Override overrideWith(
    Stream<List<AlumniDirectoryModel>> Function(AlumniDirectoryRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AlumniDirectoryProvider._internal(
        (ref) => create(ref as AlumniDirectoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        department: department,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<AlumniDirectoryModel>> createElement() {
    return _AlumniDirectoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AlumniDirectoryProvider && other.department == department;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, department.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AlumniDirectoryRef
    on AutoDisposeStreamProviderRef<List<AlumniDirectoryModel>> {
  /// The parameter `department` of this provider.
  String? get department;
}

class _AlumniDirectoryProviderElement
    extends AutoDisposeStreamProviderElement<List<AlumniDirectoryModel>>
    with AlumniDirectoryRef {
  _AlumniDirectoryProviderElement(super.provider);

  @override
  String? get department => (origin as AlumniDirectoryProvider).department;
}

String _$mentorsListHash() => r'e26f00c72e8900e26112493192c50c2cf509c335';

/// See also [mentorsList].
@ProviderFor(mentorsList)
final mentorsListProvider =
    AutoDisposeStreamProvider<List<AlumniDirectoryModel>>.internal(
  mentorsList,
  name: r'mentorsListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$mentorsListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MentorsListRef
    = AutoDisposeStreamProviderRef<List<AlumniDirectoryModel>>;
String _$searchAlumniHash() => r'918e4d9ced1815f5e0d605aa0cc40400b7b3353d';

/// See also [searchAlumni].
@ProviderFor(searchAlumni)
const searchAlumniProvider = SearchAlumniFamily();

/// See also [searchAlumni].
class SearchAlumniFamily
    extends Family<AsyncValue<List<AlumniDirectoryModel>>> {
  /// See also [searchAlumni].
  const SearchAlumniFamily();

  /// See also [searchAlumni].
  SearchAlumniProvider call(
    String query,
  ) {
    return SearchAlumniProvider(
      query,
    );
  }

  @override
  SearchAlumniProvider getProviderOverride(
    covariant SearchAlumniProvider provider,
  ) {
    return call(
      provider.query,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'searchAlumniProvider';
}

/// See also [searchAlumni].
class SearchAlumniProvider
    extends AutoDisposeFutureProvider<List<AlumniDirectoryModel>> {
  /// See also [searchAlumni].
  SearchAlumniProvider(
    String query,
  ) : this._internal(
          (ref) => searchAlumni(
            ref as SearchAlumniRef,
            query,
          ),
          from: searchAlumniProvider,
          name: r'searchAlumniProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchAlumniHash,
          dependencies: SearchAlumniFamily._dependencies,
          allTransitiveDependencies:
              SearchAlumniFamily._allTransitiveDependencies,
          query: query,
        );

  SearchAlumniProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<List<AlumniDirectoryModel>> Function(SearchAlumniRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchAlumniProvider._internal(
        (ref) => create(ref as SearchAlumniRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<AlumniDirectoryModel>> createElement() {
    return _SearchAlumniProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchAlumniProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SearchAlumniRef
    on AutoDisposeFutureProviderRef<List<AlumniDirectoryModel>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _SearchAlumniProviderElement
    extends AutoDisposeFutureProviderElement<List<AlumniDirectoryModel>>
    with SearchAlumniRef {
  _SearchAlumniProviderElement(super.provider);

  @override
  String get query => (origin as SearchAlumniProvider).query;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
