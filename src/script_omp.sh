#!/bin/bash

EXEC=sobel

gcc -o $EXEC readImage-openmp.c -lm -fopenmp

echo "Sobel con imagen 4K y Kernel de 5x5 - 1 Hilo"
echo "messi4k.jpg m4k-5.jpg 5 1" | ./$EXEC > out.txt

echo "Sobel con imagen 4K y Kernel de 5x5 - 2 Hilo"
echo "messi4k.jpg m4k-5.jpg 5 2" | ./$EXEC >> out.txt

echo "Sobel con imagen 4K y Kernel de 5x5 - 3 Hilo"
echo "messi4k.jpg m4k-5.jpg 5 3" | ./$EXEC >> out.txt

echo "Sobel con imagen 4K y Kernel de 5x5 - 4 Hilo"
echo "messi4k.jpg m4k-5.jpg 5 4" | ./$EXEC >> out.txt

echo "Sobel con imagen 4K y Kernel de 5x5 - 6 Hilo"
echo "messi4k.jpg m4k-5.jpg 5 6" | ./$EXEC >> out.txt

echo "Sobel con imagen 4K y Kernel de 5x5 - 8 Hilo"
echo "messi4k.jpg m4k-5.jpg 5 8" | ./$EXEC >> out.txt

echo "Sobel con imagen 4K y Kernel de 5x5 - 12 Hilo"
echo "messi4k.jpg m4k-5.jpg 5 12" | ./$EXEC >> out.txt

echo "Sobel con imagen 4K y Kernel de 5x5 - 16 Hilo"
echo "messi4k.jpg m4k-5.jpg 5 16" | ./$EXEC >> out.txt
