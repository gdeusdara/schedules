import 'package:flutter/material.dart';

// Fields Decoration
  decoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(),
    );
  }

