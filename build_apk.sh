#!/bin/bash

# Machine Task - APK Build Script
# This script builds both debug and release APKs

echo "🚀 Building Machine Task APK..."

# Clean the project
echo "🧹 Cleaning project..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Build debug APK
echo "🔨 Building debug APK..."
flutter build apk --debug

# Build release APK
echo "🔨 Building release APK..."
flutter build apk --release

echo "✅ Build completed!"
echo ""
echo "📱 APK files location:"
echo "   Debug: build/app/outputs/flutter-apk/app-debug.apk"
echo "   Release: build/app/outputs/flutter-apk/app-release.apk"
echo ""
echo "🎉 Ready for testing!"
