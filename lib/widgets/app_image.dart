import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/constants/app_colors.dart';

/// Renders local assets, device file paths, or remote URLs transparently.
/// Defaults to [Alignment.topCenter] so portrait/fashion photos never crop heads.
class AppImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final Alignment alignment;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.topCenter,
    this.placeholder,
    this.errorWidget,
  });

  bool get _isAsset => imageUrl.startsWith('assets/');
  bool get _isFile => imageUrl.startsWith('/') || imageUrl.startsWith('file://');

  Widget get _placeholder =>
      placeholder ?? Container(color: AppColors.card);

  Widget get _error =>
      errorWidget ?? Container(color: AppColors.card);

  @override
  Widget build(BuildContext context) {
    if (_isAsset) {
      return Image.asset(
        imageUrl,
        fit: fit,
        alignment: alignment,
        errorBuilder: (_, __, ___) => _error,
      );
    }
    if (_isFile) {
      final path = imageUrl.startsWith('file://') ? imageUrl.substring(7) : imageUrl;
      return Image.file(
        File(path),
        fit: fit,
        alignment: alignment,
        errorBuilder: (_, __, ___) => _error,
      );
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      alignment: alignment,
      placeholder: (_, __) => _placeholder,
      errorWidget: (_, __, ___) => _error,
    );
  }
}
