import sys

if (len(sys.argv)!=3):
    print("Command line tool for ROM conversion")
    print(sys.argv[0] + " input_file.bin output_file.mem")
    print("")
    exit(0)

file = open(sys.argv[2],"w") 

with open(sys.argv[1], "rb") as f:
    while True:
        byte = f.read(1)
        if not byte:
            break
        file.write("{:02x}\n".format(ord(byte)))

file.close()
