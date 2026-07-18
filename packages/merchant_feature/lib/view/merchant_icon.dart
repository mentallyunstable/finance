import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:merchant_feature/data/iconify_merchant_icon_repository.dart';
import 'package:merchant_feature/data/merchant_icon_repository.dart';

final class MerchantIcon extends StatefulWidget {
  static final MerchantIconRepository _defaultRepository = IconifyMerchantIconRepository();

  final String? iconId;
  final MerchantIconRepository? repository;
  final double size;
  final Color? color;
  final Widget? fallback;

  const MerchantIcon({
    super.key,
    required this.iconId,
    this.repository,
    this.size = 24,
    this.color,
    this.fallback,
  });

  @override
  State<MerchantIcon> createState() => _MerchantIconState();
}

final class _MerchantIconState extends State<MerchantIcon> {
  Future<File>? _file;

  @override
  void initState() {
    super.initState();
    _file = _loadFile();
  }

  @override
  void didUpdateWidget(covariant MerchantIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.iconId != widget.iconId || oldWidget.repository != widget.repository) {
      _file = _loadFile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: widget.size,
      child: widget.iconId == null
          ? _fallback()
          : FutureBuilder<File>(
              future: _file,
              builder: (context, snapshot) {
                final file = snapshot.data;
                if (snapshot.connectionState != ConnectionState.done || snapshot.hasError || file == null) {
                  return _fallback();
                }

                return SvgPicture.file(
                  file,
                  width: widget.size,
                  height: widget.size,
                  fit: BoxFit.contain,
                  colorFilter: widget.color == null ? null : ColorFilter.mode(widget.color!, BlendMode.srcIn),
                  placeholderBuilder: (_) => _fallback(),
                  errorBuilder: (_, _, _) => _fallback(),
                );
              },
            ),
    );
  }

  Future<File>? _loadFile() {
    final iconId = widget.iconId;
    if (iconId == null) {
      return null;
    }
    final repository = widget.repository ?? MerchantIcon._defaultRepository;
    return Future.sync(() => repository.getFile(iconId));
  }

  Widget _fallback() {
    return widget.fallback ?? Icon(Icons.storefront_outlined, size: widget.size, color: widget.color);
  }
}
