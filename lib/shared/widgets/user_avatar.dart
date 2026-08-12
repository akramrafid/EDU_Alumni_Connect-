import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class UserAvatar extends StatelessWidget {
  final String? photoUrl;
  final String fullName;
  final double radius;
  final double borderWidth;
  final Color borderColor;
  final VoidCallback? onTap;
  final bool showCameraIcon;
  final Widget? badge;

  const UserAvatar({
    super.key,
    this.photoUrl,
    required this.fullName,
    this.radius = 24,
    this.borderWidth = 0,
    this.borderColor = Colors.white,
    this.onTap,
    this.showCameraIcon = false,
    this.badge,
  });

  String _getInitials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'U';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return trimmed.substring(0, trimmed.length >= 2 ? 2 : 1).toUpperCase();
  }

  Widget _buildImageContent() {
    final size = radius * 2;
    final url = photoUrl?.trim();

    if (url != null && url.isNotEmpty) {
      if (url.startsWith('data:image/')) {
        try {
          final base64Data = url.split(',').last;
          final bytes = base64Decode(base64Data);
          return ClipOval(
            child: Image.memory(
              bytes,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildInitialsFallback(),
            ),
          );
        } catch (_) {
          return _buildInitialsFallback();
        }
      }

      if (url.startsWith('http://') || url.startsWith('https://')) {
        return ClipOval(
          child: CachedNetworkImage(
            imageUrl: url,
            width: size,
            height: size,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: AppColors.mulledWine.withOpacity(0.1),
              child: Center(
                child: SizedBox(
                  width: radius * 0.8,
                  height: radius * 0.8,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.mulledWine,
                  ),
                ),
              ),
            ),
            errorWidget: (context, url, error) => _buildInitialsFallback(),
          ),
        );
      }

      final file = File(url);
      if (file.existsSync()) {
        return ClipOval(
          child: Image.file(
            file,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildInitialsFallback(),
          ),
        );
      }
    }

    return _buildInitialsFallback();
  }

  Widget _buildInitialsFallback() {
    final size = radius * 2;
    final initials = _getInitials(fullName);

    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Color(0xFF670627),
            Color(0xFF8B1A3A),
            Color(0xFFFF6B35),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.75,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget avatarWidget = Container(
      padding: EdgeInsets.all(borderWidth),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: borderColor,
      ),
      child: _buildImageContent(),
    );

    if (showCameraIcon || badge != null) {
      avatarWidget = Stack(
        clipBehavior: Clip.none,
        children: [
          avatarWidget,
          if (showCameraIcon)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.mulledWine,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: radius * 0.45,
                  color: Colors.white,
                ),
              ),
            ),
          if (badge != null && !showCameraIcon)
            Positioned(
              bottom: 0,
              right: 0,
              child: badge!,
            ),
        ],
      );
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: avatarWidget,
      );
    }

    return avatarWidget;
  }
}
