import 'package:json_annotation/json_annotation.dart';

part 'common_error_model.g.dart';

@JsonSerializable()
class CommonErrorModel {
  final String? detail;

  // final List<CommonRemoteError>? errors;

  const CommonErrorModel({this.detail});

  factory CommonErrorModel.fromJson(Map<String, dynamic> json) => _$CommonErrorModelFromJson(json);

  String? get errorMessage => detail;
}

@JsonSerializable()
class CommonRemoteError {
  final String? code;
  final String? detail;
  final String? attr;

  const CommonRemoteError({required this.code, required this.detail, required this.attr});

  factory CommonRemoteError.fromJson(Map<String, dynamic> json) => _$CommonRemoteErrorFromJson(json);
}
