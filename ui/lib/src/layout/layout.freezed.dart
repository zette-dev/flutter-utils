// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'layout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$LayoutData {
  double get phoneScreenBreakpoint => throw _privateConstructorUsedError;
  double get mobileScreenBreakpoint => throw _privateConstructorUsedError;
  double get laptopScreenBreakpoint => throw _privateConstructorUsedError;
  BoxConstraints? get constraints => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LayoutDataCopyWith<LayoutData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LayoutDataCopyWith<$Res> {
  factory $LayoutDataCopyWith(
          LayoutData value, $Res Function(LayoutData) then) =
      _$LayoutDataCopyWithImpl<$Res>;
  $Res call(
      {double phoneScreenBreakpoint,
      double mobileScreenBreakpoint,
      double laptopScreenBreakpoint,
      BoxConstraints? constraints});
}

/// @nodoc
class _$LayoutDataCopyWithImpl<$Res> implements $LayoutDataCopyWith<$Res> {
  _$LayoutDataCopyWithImpl(this._value, this._then);

  final LayoutData _value;
  // ignore: unused_field
  final $Res Function(LayoutData) _then;

  @override
  $Res call({
    Object? phoneScreenBreakpoint = freezed,
    Object? mobileScreenBreakpoint = freezed,
    Object? laptopScreenBreakpoint = freezed,
    Object? constraints = freezed,
  }) {
    return _then(_value.copyWith(
      phoneScreenBreakpoint: phoneScreenBreakpoint == freezed
          ? _value.phoneScreenBreakpoint
          : phoneScreenBreakpoint // ignore: cast_nullable_to_non_nullable
              as double,
      mobileScreenBreakpoint: mobileScreenBreakpoint == freezed
          ? _value.mobileScreenBreakpoint
          : mobileScreenBreakpoint // ignore: cast_nullable_to_non_nullable
              as double,
      laptopScreenBreakpoint: laptopScreenBreakpoint == freezed
          ? _value.laptopScreenBreakpoint
          : laptopScreenBreakpoint // ignore: cast_nullable_to_non_nullable
              as double,
      constraints: constraints == freezed
          ? _value.constraints
          : constraints // ignore: cast_nullable_to_non_nullable
              as BoxConstraints?,
    ));
  }
}

/// @nodoc
abstract class _$$_LayoutDataCopyWith<$Res>
    implements $LayoutDataCopyWith<$Res> {
  factory _$$_LayoutDataCopyWith(
          _$_LayoutData value, $Res Function(_$_LayoutData) then) =
      __$$_LayoutDataCopyWithImpl<$Res>;
  @override
  $Res call(
      {double phoneScreenBreakpoint,
      double mobileScreenBreakpoint,
      double laptopScreenBreakpoint,
      BoxConstraints? constraints});
}

/// @nodoc
class __$$_LayoutDataCopyWithImpl<$Res> extends _$LayoutDataCopyWithImpl<$Res>
    implements _$$_LayoutDataCopyWith<$Res> {
  __$$_LayoutDataCopyWithImpl(
      _$_LayoutData _value, $Res Function(_$_LayoutData) _then)
      : super(_value, (v) => _then(v as _$_LayoutData));

  @override
  _$_LayoutData get _value => super._value as _$_LayoutData;

  @override
  $Res call({
    Object? phoneScreenBreakpoint = freezed,
    Object? mobileScreenBreakpoint = freezed,
    Object? laptopScreenBreakpoint = freezed,
    Object? constraints = freezed,
  }) {
    return _then(_$_LayoutData(
      phoneScreenBreakpoint: phoneScreenBreakpoint == freezed
          ? _value.phoneScreenBreakpoint
          : phoneScreenBreakpoint // ignore: cast_nullable_to_non_nullable
              as double,
      mobileScreenBreakpoint: mobileScreenBreakpoint == freezed
          ? _value.mobileScreenBreakpoint
          : mobileScreenBreakpoint // ignore: cast_nullable_to_non_nullable
              as double,
      laptopScreenBreakpoint: laptopScreenBreakpoint == freezed
          ? _value.laptopScreenBreakpoint
          : laptopScreenBreakpoint // ignore: cast_nullable_to_non_nullable
              as double,
      constraints: constraints == freezed
          ? _value.constraints
          : constraints // ignore: cast_nullable_to_non_nullable
              as BoxConstraints?,
    ));
  }
}

/// @nodoc

class _$_LayoutData extends _LayoutData {
  const _$_LayoutData(
      {this.phoneScreenBreakpoint = 480.0,
      this.mobileScreenBreakpoint = 768.0,
      this.laptopScreenBreakpoint = 992.0,
      this.constraints})
      : super._();

  @override
  @JsonKey()
  final double phoneScreenBreakpoint;
  @override
  @JsonKey()
  final double mobileScreenBreakpoint;
  @override
  @JsonKey()
  final double laptopScreenBreakpoint;
  @override
  final BoxConstraints? constraints;

  @override
  String toString() {
    return 'LayoutData(phoneScreenBreakpoint: $phoneScreenBreakpoint, mobileScreenBreakpoint: $mobileScreenBreakpoint, laptopScreenBreakpoint: $laptopScreenBreakpoint, constraints: $constraints)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LayoutData &&
            const DeepCollectionEquality()
                .equals(other.phoneScreenBreakpoint, phoneScreenBreakpoint) &&
            const DeepCollectionEquality()
                .equals(other.mobileScreenBreakpoint, mobileScreenBreakpoint) &&
            const DeepCollectionEquality()
                .equals(other.laptopScreenBreakpoint, laptopScreenBreakpoint) &&
            const DeepCollectionEquality()
                .equals(other.constraints, constraints));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(phoneScreenBreakpoint),
      const DeepCollectionEquality().hash(mobileScreenBreakpoint),
      const DeepCollectionEquality().hash(laptopScreenBreakpoint),
      const DeepCollectionEquality().hash(constraints));

  @JsonKey(ignore: true)
  @override
  _$$_LayoutDataCopyWith<_$_LayoutData> get copyWith =>
      __$$_LayoutDataCopyWithImpl<_$_LayoutData>(this, _$identity);
}

abstract class _LayoutData extends LayoutData {
  const factory _LayoutData(
      {final double phoneScreenBreakpoint,
      final double mobileScreenBreakpoint,
      final double laptopScreenBreakpoint,
      final BoxConstraints? constraints}) = _$_LayoutData;
  const _LayoutData._() : super._();

  @override
  double get phoneScreenBreakpoint => throw _privateConstructorUsedError;
  @override
  double get mobileScreenBreakpoint => throw _privateConstructorUsedError;
  @override
  double get laptopScreenBreakpoint => throw _privateConstructorUsedError;
  @override
  BoxConstraints? get constraints => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_LayoutDataCopyWith<_$_LayoutData> get copyWith =>
      throw _privateConstructorUsedError;
}
