from PIL import Image
import sys

sys.stderr.write("filename?")
sys.stderr.flush()
filename = raw_input()
sys.stderr.write("color?")
sys.stderr.flush()
color = raw_input()
sys.stderr.write("row?")
sys.stderr.flush()
row = raw_input()
sys.stderr.write("col?")
sys.stderr.flush()
col = raw_input()

thick = 8

im = Image.open("../png/" + filename + ".png")

bi_im = im.convert("1")

size = bi_im.size

for x in range(size[0]):
    for y in range(size[1]):
        if bi_im.getpixel((x, y)) == 0:
            print "else if(row>="+str(row)+"&&row<"+str(row)+"+80&&col>="+str(col)+"&&col<"+str(col)+"+80) begin"
            print "\t{red, green, blue} <= 3'b" + color + ";"
            print "end"
            

