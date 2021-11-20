#!/bin/bash

EXEC=sobel

gcc -o $EXEC readImage-openmp.c -lm -fopenmp

for hilos in 1 2 3 4 6 8 10 12 14 16 18 20
do
	echo "Sobel con imagen 4K y Kernel de 5x5 - $ Hilo"
	echo "messi4k.jpg m4k-5.jpg 5 $hilos" | ./$EXEC >> out4k-5.txt
done

for hilos in 1 2 3 4 6 8 10 12 14 16 18 20
do
	echo "Sobel con imagen 4K y Kernel de 3x3 - $ Hilo"
	echo "messi4k.jpg m4k-3.jpg 3 $hilos" | ./$EXEC >> out4k-3.txt
done

for hilos in 1 2 3 4 6 8 10 12 14 16 18 20
do
	echo "Sobel con imagen 1080 y Kernel de 5x5 - $ Hilo"
	echo "messi1080.jpg m1080-5.jpg 5 $hilos" | ./$EXEC >> out1080-5.txt
done

for hilos in 1 2 3 4 6 8 10 12 14 16 18 20
do
	echo "Sobel con imagen 1080 y Kernel de 3x3 - $ Hilo"
	echo "messi1080.jpg m1080-3.jpg 3 $hilos" | ./$EXEC > out1080-3.txt
done

for hilos in 1 2 3 4 6 8 10 12 14 16 18 20
do
	echo "Sobel con imagen 720 y Kernel de 5x5 - $ Hilo"
	echo "messi720.jpg m720-5.jpg 5 $hilos" | ./$EXEC > out720-5.txt
done

for hilos in 1 2 3 4 6 8 10 12 14 16 18 20
do
	echo "Sobel con imagen 720 y Kernel de 3x3 - $ Hilo"
	echo "messi720.jpg m720-3.jpg 5 $hilos" | ./$EXEC > out720-3.txt
done