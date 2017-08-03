from PIL import Image
import sys

print "filename?"
sys.stdout.flush()
filename = raw_input()
print "top_col?"
sys.stdout.flush()
top_col = raw_input()
print "top_row?"
sys.stdout.flush()
top_row = raw_input()

thick = 5

im = Image.open("../png/" + filename + ".png")

bi_im = im.convert("1")

size = bi_im.size

for x in range(size[0]):
    for y in range(size[1]):
        if bi_im.getpixel((x, y)) == 0:
            print "else if(row >= top_row+" + str(y) + "*thick && row < top_row+(" + str(y) + "+1)*thick && col >= top_col+" + str(x) + "*thick && col < top_col+(" + str(x) + "+1)*thick)) begin"
            print "\t{red, green, blue} <= 3'b000"
            print "end"
            

