seq = [ 5.301517 , 2.490891, 1.993358, 0.986464, 0.885450, 0.445078 ]
names = ['out_mpi_4k-3.txt','out_mpi_4k-5.txt','out_mpi_1080-3.txt','out_mpi_1080-5.txt','out_mpi_720-3.txt','out_mpi_720-5.txt']


fout = open('sp-mpi.txt','w')
for i in range(6):
    fin = open(names[i],'r')
    max_speed = 0
    for line in fin:
        threads = line.split(' ')[0]
        speedup = seq[i]/float(line.split(' ')[1])
        max_speed = max(speedup,max_speed)
    fout.write(str(max_speed)+'\n')
    fin.close()
fout.close()
