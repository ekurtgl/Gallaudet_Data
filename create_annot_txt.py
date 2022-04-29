import glob


vidPath = r'C:\Users\emrek\Desktop\Technical\Gallaudet\videos\*\*.mp4'
textPath = r'C:\Users\emrek\Desktop\Technical\Gallaudet\annotations'

files = glob.glob(vidPath)
print(len(files))
files = [f for f in files if 'Exp2' in f or 'Exp3' in f]
print(len(files))

header_exp2 = 'Start Frame, End Frame, Class Number\nExample: 156,203,2\n----------------------\n1,'
header_exp3 = 'Start Frame, End Frame, Word\nExample: 5,48,Hello\n----------------------\n1,'

for i, f in enumerate(files):
    fname = f.split('\\')[-1]
    with open(textPath + '\\' + fname[:-3] + 'txt', 'w') as file:
        if 'Exp2' in f:
            file.write(header_exp2)
        elif 'Exp3' in f:
            file.write(header_exp3)

    # break

