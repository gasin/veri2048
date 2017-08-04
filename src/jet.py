from PIL import Image
import sys

im = Image.open("../png/jet_right.png")

bi_im = im.convert("1")

size = bi_im.size

for x in range(size[0]):
    for y in range(size[1]):
        if bi_im.getpixel((x, y)) == 0:
            print "\t\t\telse if(jet_pos<=600&&row>=520+"+str(y)+"*2&&row<520+"+str(y)+"*2+2"+"&&col>=70+jet_pos+"+str(x)+"*2&&col<70+jet_pos+"+str(x)+"*2+2) {red, green, blue} <= 3'b000;"

im = Image.open("../png/jet_top.png")

bi_im = im.convert("1")

size = bi_im.size

for x in range(size[0]):
    for y in range(size[1]):
        if bi_im.getpixel((x, y)) == 0:
            print "\t\t\telse if(jet_pos>600&&jet_pos<=1100&&row>=520+600-jet_pos+"+str(y)+"*2&&row<520+600-jet_pos+"+str(y)+"*2+2"+"&&col>=670+"+str(x)+"*2&&col<670+"+str(x)+"*2+2) {red, green, blue} <= 3'b000;"

im = Image.open("../png/jet_left.png")

bi_im = im.convert("1")

size = bi_im.size

for x in range(size[0]):
    for y in range(size[1]):
        if bi_im.getpixel((x, y)) == 0:
            print "\t\t\telse if(jet_pos>1100&&jet_pos<=1700&&row>=20+"+str(y)+"*2&&row<20+"+str(y)+"*2+2&&col>=670+1100-jet_pos+"+str(x)+"*2&&col<670+1100-jet_pos+"+str(x)+"*2+2) {red, green, blue} <= 3'b000;"

im = Image.open("../png/jet_down.png")

bi_im = im.convert("1")

size = bi_im.size

for x in range(size[0]):
    for y in range(size[1]):
        if bi_im.getpixel((x, y)) == 0:
            print "\t\t\telse if(jet_pos>1700&&jet_pos<=2200row>=20+jet_pos-1700+"+str(y)+"*2&&row<20+jet_pos-1700+"+str(y)+"*2+2&&col>=70+"+str(x)+"*2&&col<70+"+str(x)+"*2+2) {red, green, blue} <= 3'b000;"

