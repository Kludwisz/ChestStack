
def printCommand(txt):
    if 'skipSupport' in txt:
        print('if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);')
    elif 'skipChest' in txt:
        print('if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);')
    elif 'skipSpiderChest' in txt:
        print('xNextIntJ(xrand, 100);')
    elif 'processColumnChest' in txt:
        print('if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3); // COLUMN CHEST!')
    elif 'nextInt(100)' in txt:
        print(f'xNextIntJ(xrand, 100);')
    else:
        print(f'{txt}\n')


with open('skips3.txt') as f:
    lines = [line.strip().split('//')[0].strip() for line in f.readlines()]

for line in lines:
    # check for regular skip
    if 'skip ' in line:
        print(f'xSkipN(xrand, {line.split(' ')[-1]});')
        continue
    
    times = 1 if not ' x' in line else int(line.split('x')[-1])
    if times == 1:
        printCommand(line)
    else:
        print(f'#pragma unroll\nfor (int i = 0; i < {times}; i++) ', end='')
        printCommand(line)