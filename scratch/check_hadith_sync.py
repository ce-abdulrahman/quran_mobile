import shutil

src = 'assets/data/packages/hadith/data.json'
dst = 'assets/data/hadiths.json'

shutil.copyfile(src, dst)
print("Successfully copied data.json to hadiths.json!")
