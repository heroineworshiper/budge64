#!/usr/bin/python


# generate the rotation tables for 128 angles & 16 magnitude nibble values

import math

# the total angle steps
TOTAL_ANGLES = 128
# the total number of angles we're solving.  The other 64 are a mirror of the 1st 64.
ANGLE_STEPS = 64


def to_hex8(n):
    hex_table = [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 
        'a', 'b', 'c', 'd', 'e', 'f' ]
    string = '$' + hex_table[n >> 4] + hex_table[n & 0xf]
    return string

def to_hex16(n):
    hex_table = [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 
        'a', 'b', 'c', 'd', 'e', 'f' ]
    string = '$' + \
        hex_table[((n >> 12) & 0xf)] + \
        hex_table[((n >> 8) & 0xf)] + \
        hex_table[((n >> 4) & 0xf)] + \
        hex_table[n & 0xf]
    return string

# reuse solved angles to create all the angle steps
def recycle_sin_angle(angle):
    if angle < ANGLE_STEPS / 2:
        angle2 = ANGLE_STEPS / 2 - angle
    elif angle < ANGLE_STEPS * 3 / 2:
        angle2 = angle - ANGLE_STEPS / 2
    else:
        angle2 = ANGLE_STEPS * 5 / 2 - angle - 1
    return angle2

def recycle_cos_angle(angle):
    if angle < ANGLE_STEPS:
        angle2 = angle
    else:
        angle2 = ANGLE_STEPS - (angle - ANGLE_STEPS) - 1
    return angle2

# compute tables from 8 bit magnitude & 6 bit angle
rot_tab_lo = []
rot_tab_hi = []
for i in range(16 * ANGLE_STEPS):
    rot_tab_lo.append(0)
    rot_tab_hi.append(0)

# tabulate low 4 bits of magnitude
for mag in range(-16, 0, 1):
    for angle in range(ANGLE_STEPS):
        value = int(math.cos(angle * math.pi / ANGLE_STEPS) * mag)
# bits 0:3 lower 4 bits of magnitude
# bits 4:9 angle.  This part is looked up in the RotIndex tables
        rot_tab_lo[mag + (angle << 4)] = value

# tabulate high 4 bits of magnitude
for mag in range(-128, 128, 16):
    for angle in range(ANGLE_STEPS):
# 4 high bits of magnitude & all angles
        value = int(math.cos(angle * math.pi / ANGLE_STEPS) * mag)
# bits 0:3 lower 4 bits of angle.  This part is looked up in the RotIndex tables
# bits 4:7 upper 4 bits of the magnitude
# bits 8:9 upper 2 bits of angle.  This part is looked up in the RotIndex tables
        rot_tab_hi[(angle & 0xf) | (mag & 0xf0) | ((angle & 0x30) << 4)] = value

# print the tables
print("RotTabLo:")
for i in range(0, 16 * ANGLE_STEPS, 8):
    string = "    .byte "
    for j in range(8):
        string += to_hex8(rot_tab_lo[i + j])
        if j < 7:
            string += ", "
    print(string)


print("RotTabHi:")
for i in range(0, 16 * ANGLE_STEPS, 8):
    string = "    .byte "
    for j in range(8):
        string += to_hex8(rot_tab_hi[i + j])
        if j < 7:
            string += ", "
    print(string)



# create offsets into the lo & hi tables

print("; left shift the value 4 bits to get the RotIndexLo offset for magnitude 0")
print("; left shift bits 4:5 4 bits to get the RotIndexHi offset for magnitude 0")
print("RotIndex_sin:")
for i in range(0, TOTAL_ANGLES, 8):
    string = "    .byte "
    for j in range(8):
        angle = recycle_sin_angle(i + j)
        string += to_hex8(angle)
        if j < 7:
            string += ", "
    print(string)



print("RotIndex_cos:")
for i in range(0, TOTAL_ANGLES, 8):
    string = "    .byte "
    for j in range(8):
        angle = recycle_cos_angle(i + j)
        string += to_hex8(angle)
        if j < 7:
            string += ", "
    print(string)




