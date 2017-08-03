from PIL import Image
import sys

sys.stderr.write("filename?")
sys.stderr.flush()
filename = raw_input()

thick = 6

im = Image.open("../png/" + filename + ".png")

bi_im = im.convert("1")

size = bi_im.size

for x in range(size[0]):
    for y in range(size[1]):
        if bi_im.getpixel((x, y)) == 0:
            print "else if(row >= cell_position_row[cell_index] + 10 +"+ str(y) + "*" + str(thick) + " && row < cell_position_row[cell_index]+10+(" + str(y) + "+1)*" + str(thick) + " && col >= cell_position_col[cell_index]+10+" + str(x) + "*" + str(thick) + " && col < cell_position_col[cell_index]+10+(" + str(x) + "+1)*" + str(thick) + ") begin"
            print "\t{red, green, blue} <= 3'b000;"
            print "end"
            

