#!/bin/bash

EXEC=sobel

gcc -o $EXEC readImage-openmp.c -lm -fopenmp

echo "4k - 5x5" > out4k-5.txt
for hilos in 1 2 3 4 6 8 10 12 14 16 18 20
do
	echo "Sobel con imagen 4K y Kernel de 5x5 - $hilos Hilo"
	echo "messi4k.jpg m4k-5.jpg 5 $hilos" | ./$EXEC >> out4k-5.txt
done

echo "4k - 3x3" > out4k-3.txt
for hilos in 1 2 3 4 6 8 10 12 14 16 18 20
do
	echo "Sobel con imagen 4K y Kernel de 3x3 - $hilos Hilo"
	echo "messi4k.jpg m4k-3.jpg 3 $hilos" | ./$EXEC >> out4k-3.txt
done

echo "1080 - 5x5" > out1080-5.txt
for hilos in 1 2 3 4 6 8 10 12 14 16 18 20
do
	echo "Sobel con imagen 1080 y Kernel de 5x5 - $hilos Hilo"
	echo "messi1080.jpg m1080-5.jpg 5 $hilos" | ./$EXEC >> out1080-5.txt
done

echo "1080 - 3x3" > out1080-3.txt
for hilos in 1 2 3 4 6 8 10 12 14 16 18 20
do
	echo "Sobel con imagen 1080 y Kernel de 3x3 - $hilos Hilo"
	echo "messi1080.jpg m1080-3.jpg 3 $hilos" | ./$EXEC >> out1080-3.txt
done

echo "720 - 5x5" > out720-5.txt
for hilos in 1 2 3 4 6 8 10 12 14 16 18 20
do
	echo "Sobel con imagen 720 y Kernel de 5x5 - $hilos Hilo"
	echo "messi720.jpg m720-5.jpg 5 $hilos" | ./$EXEC >> out720-5.txt
done

echo "720 - 3x3" > out720-3.txt
for hilos in 1 2 3 4 6 8 10 12 14 16 18 20
do
	echo "Sobel con imagen 720 y Kernel de 3x3 - $hilos Hilo"
	echo "messi720.jpg m720-3.jpg 5 $hilos" | ./$EXEC >> out720-3.txt
done
