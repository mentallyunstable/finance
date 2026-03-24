// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_error_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommonErrorModel _$CommonErrorModelFromJson(Map<String, dynamic> json) =>
    CommonErrorModel(
      detail: json['detail'] as String?,
    );

Map<String, dynamic> _$CommonErrorModelToJson(CommonErrorModel instance) =>
    <String, dynamic>{
      'detail': instance.detail,
    };

CommonRemoteError _$CommonRemoteErrorFromJson(Map<String, dynamic> json) =>
    CommonRemoteError(
      code: json['code'] as String?,
      detail: json['detail'] as String?,
      attr: json['attr'] as String?,
    );

Map<String, dynamic> _$CommonRemoteErrorToJson(CommonRemoteError instance) =>
    <String, dynamic>{
      'code': instance.code,
      'detail': instance.detail,
      'attr': instance.attr,
    };
