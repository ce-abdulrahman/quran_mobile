Place Roboto font files here so Flutter can bundle them for web.

Download the following files and save them in this folder:
- Roboto-Regular.ttf
- Roboto-Medium.ttf
- Roboto-Bold.ttf

After adding the files run:

```
flutter clean
flutter pub get
flutter run -d edge
```

This prevents Flutter web from fetching the fonts from fonts.gstatic.com.
