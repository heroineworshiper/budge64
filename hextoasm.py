#!/usr/bin/python


# convert block hex codes to comma separated assembly
# usage hextoasm.py > /tmp/x

import os
import sys

output = ""
total = 0
LINE_BYTES = 8

while True:
    try:
        text = raw_input()
    except EOFError:
        break

# group 2 characters in 1 byte
    for i in range(0, len(text), 2):
        if i + 1 >= len(text):
            break
        if (total % LINE_BYTES) == 0:
            output += "    .byte "
        else:
            output += ', '
        output += '$' + text[i] + text[i + 1]
        total += 1
        if (total % LINE_BYTES) == 0:
            output += '\n'

print output
    

