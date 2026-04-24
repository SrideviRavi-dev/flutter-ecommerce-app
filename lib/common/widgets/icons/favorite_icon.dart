// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myapp/services/favorite_service/favorite_service.dart';

class FavoriteIconButton extends StatefulWidget {
  final String productId; // Unique identifier for the product
  final String title; // Product title
  final String imageUrl; // Product image URL
  final String price; // Product price
  final String salePrice; // Product sale price

  const FavoriteIconButton({
    super.key,
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.salePrice,
  });

  @override
  _FavoriteIconButtonState createState() => _FavoriteIconButtonState();
}

class _FavoriteIconButtonState extends State<FavoriteIconButton> {
  bool _isFavorite = false;
  final FavoriteService _favoriteService = FavoriteService(); // Instantiate the service

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  void _checkIfFavorite() async {
    final doc = await FirebaseFirestore.instance
        .collection('favorites')
        .doc(widget.productId)
        .get();

    if (!mounted) return; // Ensure widget is still in the tree

    setState(() {
      _isFavorite = doc.exists;
    });
  }

  void _toggleFavorite(BuildContext context) async {
    final product = FavoriteProduct(
      productId: widget.productId,
      title: widget.title,
      imageUrl: widget.imageUrl,
      price: widget.price,
      salePrice: widget.salePrice,
    );

    if (_isFavorite) {
      await _favoriteService.removeFavorite(widget.productId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Removed from favorites')),
        );
      }
    } else {
      await _favoriteService.addFavorite(product);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to favorites')),
        );
      }
    }

    if (!mounted) return; // Ensure widget is still active before updating state

    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isFavorite ? Iconsax.heart5 : Iconsax.heart,
        color: _isFavorite ? Colors.red : Colors.grey,
      ),
      onPressed: () => _toggleFavorite(context),
    );
  }
}
