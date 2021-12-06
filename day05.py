from collections import Counter

def parse_vent(vent):
    left_vent, right_vent = [v.strip() for v in vent.split('->')]
    left_vent = tuple([int(p) for p in left_vent.split(',')])
    right_vent = tuple([int (p) for p in right_vent.split(',')])
    return (left_vent, right_vent)

def generate_lines_y(vents):
    left_vent, right_vent = vents
    if right_vent[1] < left_vent[1]:
        y_range = range(right_vent[1], left_vent[1]+1)
    else:
        y_range = range(left_vent[1], right_vent[1] + 1)
    return [(left_vent[0], y) for y in y_range]

def generate_lines_x(vents):
    left_vent, right_vent = vents
    if right_vent[0] < left_vent[0]:
        x_range = range(right_vent[0], left_vent[0]+1)
    else:
        x_range = range(left_vent[0], right_vent[0] + 1)
    return [(x, left_vent[1]) for x in x_range]

def generate_lines(vents):
    left_vent, right_vent = vents
    if left_vent[0] == right_vent[0]:
        return generate_lines_y(vents)
    elif left_vent[1] == right_vent[1]:
        return generate_lines_x(vents)
    return []

lines = open('day05.input', 'r').readlines()
lines = [l.strip() for l in lines]
vents = [parse_vent(l) for l in lines]
all_positions = [generate_lines(vent) for vent in vents]
all_positions = [pos for sublist in all_positions for pos in sublist]
counted_pos = Counter(all_positions)
repeated_pos = [pos for pos in counted_pos.keys() if counted_pos[pos] > 1]
print(len(repeated_pos))