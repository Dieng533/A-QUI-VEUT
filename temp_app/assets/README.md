# Assets Directory

This directory contains all the static assets used by the A QUI VEUT ? application.

## Structure

```
assets/
├── fonts/          # Font files
├── images/         # Images and icons
├── animations/      # Lottie animations
└── icons/          # App icons and launch images
```

## Fonts

### Required Font Files
Please download the following Poppins font files from Google Fonts (https://fonts.google.com/specimen/Poppins):

- `Poppins-Regular.ttf` - Regular weight (400)
- `Poppins-Medium.ttf` - Medium weight (500)  
- `Poppins-SemiBold.ttf` - Semi-bold weight (600)
- `Poppins-Bold.ttf` - Bold weight (700)

### Installation
1. Go to https://fonts.google.com/specimen/Poppins
2. Click "Download family"
3. Extract the ZIP file
4. Copy the font files to `assets/fonts/`
5. Make sure the file names match exactly as listed above

## Images

### App Icon
Replace the default app icon with your custom design:
- `android/app/src/main/res/mipmap-*/ic_launcher.png`
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

### Launch Screen
Customize the launch screen images:
- `assets/images/launch_logo.png` - Logo for splash screen
- `assets/images/launch_background.png` - Background image

### Illustrations
Add custom illustrations for:
- Onboarding screens
- Empty states
- Error states

## Animations

### Lottie Files
Add Lottie animations for:
- Loading states
- Success animations
- Feature introductions

### Recommended Sources
- LottieFiles (https://lottiefiles.com/)
- Create custom animations with Adobe After Effects + Bodymovin

## Icons

### Tab Bar Icons
Bottom navigation icons are already included using Material Icons.

### Custom Icons
For custom icons, use SVG format and convert to Flutter icons using:
- flutter_svg package
- Icon generation tools

## Optimization

### Images
- Use WebP format for better compression
- Optimize image sizes for different screen densities
- Implement lazy loading for large images

### Fonts
- Subset fonts to include only necessary characters
- Consider using Google Fonts package for dynamic loading

## Usage in Code

### Fonts
```dart
// Using Google Fonts package (recommended)
GoogleFonts.poppins()

// Using local fonts
TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w600,
)
```

### Images
```dart
Image.asset('assets/images/launch_logo.png')
```

### Animations
```dart
Lottie.asset('assets/animations/loading.json')
```

## Notes

- All assets must be declared in `pubspec.yaml`
- Use descriptive names for better organization
- Keep assets optimized for mobile performance
- Test assets on both Android and iOS platforms
