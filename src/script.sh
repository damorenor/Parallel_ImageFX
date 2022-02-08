#!/bin/bash

EXEC=sobel

gcc -o $EXEC readImage.c -lm

echo "Sobel con imagen 4K y Kernel de 5x5"
echo "messi4k.jpg m4k-5.jpg 5" | ./$EXEC > out.txt

echo "Sobel con imagen 4K y Kernel de 3x3"
echo "messi4k.jpg m4k-3.jpg 3" | ./$EXEC >> out.txt

echo "Sobel con imagen 1080 y Kernel de 5x5"
echo "messi1080.jpg m1080-5.jpg 5" | ./$EXEC >> out.txt

echo "Sobel con imagen 1080 y Kernel de 3x3"
echo "messi1080.jpg m1080-3.jpg 3" | ./$EXEC >> out.txt

echo "Sobel con imagen 720 y Kernel de 5x5"
echo "messi720.jpg m720-5.jpg 5" | ./$EXEC >> out.txt

echo "Sobel con imagen 720 y Kernel de 3x3"
echo "messi720.jpg m720-3.jpg 3" | ./$EXEC >> out.txt



