// Conditional export: resolves to IO implementation on native, web stub on web.
export 'platform_mushaf_factory_io.dart'
    if (dart.library.html) 'platform_mushaf_factory_web.dart';
