#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <sys/time.h>

#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"
#define MAX_BRIGHTNESS  255 /* Maximum gray level */



int main()
{
    int width, height, channels, kernel;
    char *name;
    char *nameOutput;
    float minR = 100, maxR = -minR, minG = minR, maxG = -minR, minB = minR, maxB = -minR;
    int kernelx[3][3] = { {-1, 0, 1} ,{-2, 0, 2 },{-1, 0, 1 }};
    int kernelx2[5][5] = { {-2, -1, 0, 1, 2}, {-2, -1, 0, 1, 2} ,{-4, -2, 0, 2, 4}, {-2, -1, 0, 1, 2}, {-2, -1, 0, 1, 2} };
    name = malloc(sizeof(char));
    nameOutput = malloc(sizeof(char));
    printf("Introduce el nombre de la imagen, el nombre de la nueva imagen separados por un espacio: \n");
    scanf("%s %s", name, nameOutput);

    unsigned char *img = stbi_load(name, &width, &height, &channels, 3);
    unsigned char *img2 = stbi_load(name, &width, &height, &channels, 3);
    int pixel_row_num = width * channels;
    if(img == NULL){
        printf("Error al Cargar Imagen: ");
        printf("%s\n", stbi_failure_reason());
        exit(1);
    }
    

    //Recorre fila por fila recogiendo los canales R,G,B y cambiandolos
    //Esta primera doble iteración pasa la imagen a escala de grises
    for(int j = 0; j<height; j++){
        for(int i = 0; i<pixel_row_num; i+=3){
               char *str;
            int r = img[i + (pixel_row_num * j)];
            int g = img[i+1 + (pixel_row_num * j)];
            int b = img[i+2 + (pixel_row_num * j)];
            int t = r*0.299 + g*0.587 + b*0.114;
            img[i + (pixel_row_num * j)] = t;
            img[i + 1 + (pixel_row_num * j)] = t;
            img[i + 2 + (pixel_row_num * j)] = t;

        } 
    }

    //Se aplica el operador sobel con un gradiente (X)

    //Recorre cada fila de la matriz de pixl
    for(int j = 1; j<height-1; j++){

        //Recorre cada pixel de la fila
        for(int i = 3; i<pixel_row_num-3; i+=3){

            //Se recorren los pixeles adyacenetes al pixel actual
            int rAux = 0, gAux = 0,bAux = 0,y1 = 0;
            for (int x = -1; x <= 1; x++) {
                int x1 = 0;
                for (int y = -3; y <= 3; y+=3) {
                    int r = img[(i + y)+((j+x)*pixel_row_num)];
                    int g = img[(i + 1 + y)+((j+x)*pixel_row_num)];
                    int b = img[(i + 2 + y)+((j+x)*pixel_row_num)];
                    rAux += r*kernelx[x1][y1];
                    gAux += g*kernelx[x1][y1];
                    bAux += b*kernelx[x1][y1];
                    x1++;
                }
                y1++;
            }
            if (rAux < minR)
                minR = rAux;
            if (rAux > maxR)
                maxR = rAux;
            if (gAux < minG) 
                minG = gAux;
            if (gAux > maxG)
                maxG = gAux;
            if (bAux < minB) 
                minB = bAux;
            if (bAux > maxB)
                maxB = bAux;

            //Se asigna los resultados normalizados a una variable img2
            img2[(i)+(j*pixel_row_num)] =  MAX_BRIGHTNESS * (rAux - minR)/(maxR-minR);
            img2[(i + 1)+(j*pixel_row_num)] = MAX_BRIGHTNESS * (gAux - minG)/(maxG-minG);
            img2[(i + 2)+(j*pixel_row_num)] = MAX_BRIGHTNESS * (bAux - minB)/(maxB-minB);

     } 

    }
    //Se crea la nueva imagen
    stbi_write_jpg(nameOutput, width, height, channels, img2, 100);
    free(nameOutput);
    free(name);
    return 0;
}