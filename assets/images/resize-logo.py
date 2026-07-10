from PIL import Image

def resize_icons(image_path):
    # کردنەوەی وێنەکە
    try:
        img = Image.open(image_path)
    except FileNotFoundError:
        print("وێنەکە نەدۆزرایەوە! تکایە دڵنیابە لە ناوی فایلەکە.")
        return

    # پێوانە و قەبارەکان بەپێی داواکارییەکەت
    sizes = {
        'MDPI': 48,
        'HDPI': 72,
        'XHDPI': 96,
        'XXHDPI': 144,
        'XXXHDPI': 192
    }

    # گۆڕینی قەبارە و خەزنکردنیان لە هەمان فۆڵدەر
    for name, size in sizes.items():
        # بەکارهێنانی LANCZOS بۆ هێشتنەوەی کوالێتییەکی بەرز لە کاتی بچووککردنەوەدا
        resized_img = img.resize((size, size), Image.Resampling.LANCZOS)
        output_name = f'icon_{name}_{size}x{size}.png'
        # output_name = f'ic_launcher-{name}-{size}x{size}.png'
        resized_img.save(output_name)
        print(f'وێنەی {output_name} بە سەرکەوتوویی دروستکرا.')

# دڵنیابە ناوی وێنەکەت لێرەدا دروستە
resize_icons('lo.png')