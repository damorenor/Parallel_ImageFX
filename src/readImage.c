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
    int width, height, channels, sizeKernel, kernel;
    char *name;
    char *nameOutput;
    int kernelx[3][3] = { {-1, 0, 1} ,{-2, 0, 2 },{-1, 0, 1 }};
    int kernelx2[5][5] = { {-2, -1, 0, 1, 2}, {-2, -1, 0, 1, 2} ,{-4, -2, 0, 2, 4}, {-2, -1, 0, 1, 2}, {-2, -1, 0, 1, 2} };
    name = malloc(sizeof(char));
    nameOutput = malloc(sizeof(char));
    printf("Introduce el nombre de la imagen, el nombre de la nueva imagen y el tamaño del kernel (3 o 5)  separados por un espacio: \n");
    scanf("%s %s %d", name, nameOutput, &kernel);
    if(kernel != 3 && kernel != 5){
        exit(1);
    }
    sizeKernel = (kernel - 1) / 2;
    unsigned char *img = stbi_load(name, &width, &height, &channels, 3);
    char *img2;
    img2 = malloc(width * channels* height*sizeof(char));

    int pixel_row_num = width * channels;
    if(img == NULL){
        printf("Error al Cargar Imagen: ");
        printf("%s\n", stbi_failure_reason());
        exit(1);
    }
    
//En este for aplica el operador sobel con un gradiente (X)
    for(int j = sizeKernel*1; j<height- (sizeKernel * 1); j++){
        for(int i = sizeKernel*3; i<pixel_row_num-(sizeKernel* 3); i+=3){
            int rAux = 0, gAux = 0,bAux = 0, rXAux = 0, gXAux = 0,bXAux = 0, rYAux = 0, gYAux = 0,bYAux = 0,y1 = 0;
            for (int x = -1; x <= 1; x++) {
                int x1 = 0;
                for (int y = -3; y <= 3; y+=3) {
                    int r = img[(i + y)+((j+x)*pixel_row_num)];
                    int g = img[(i + 1 + y)+((j+x)*pixel_row_num)];
                    int b = img[(i + 2 + y)+((j+x)*pixel_row_num)];
                    
                    // Filtro a escala de grises 
                    int t = r*0.299 + g*0.587 + b*0.114;
                    img[i + (pixel_row_num * j)] = t;
                    img[i + 1 + (pixel_row_num * j)] = t;
                    img[i + 2 + (pixel_row_num * j)] = t;

                    //Gradiente
                    if(sizeKernel == 2){
                        rXAux += img[i + (pixel_row_num * j)]*kernelx2[y1][x1];
                        gXAux += img[i + 1 + (pixel_row_num * j)]*kernelx2[y1][x1];
                        bXAux += img[i + 2 + (pixel_row_num * j)]*kernelx2[y1][x1];
                        rYAux += img[i + (pixel_row_num * j)]*kernelx2[x1][y1];
                        gYAux += img[i + 1 + (pixel_row_num * j)]*kernelx2[x1][y1];
                        bYAux += img[i + 2 + (pixel_row_num * j)]*kernelx2[x1][y1];
                    }else if(sizeKernel == 1 ){
                        rXAux += img[i + (pixel_row_num * j)]*kernelx[y1][x1];
                        gXAux += img[i + 1 + (pixel_row_num * j)]*kernelx[y1][x1];
                        bXAux += img[i + 2 + (pixel_row_num * j)]*kernelx[y1][x1];
                        rYAux += img[i + (pixel_row_num * j)]*kernelx[x1][y1];
                        gYAux += img[i + 1 + (pixel_row_num * j)]*kernelx[x1][y1];
                        bYAux += img[i + 2 + (pixel_row_num * j)]*kernelx[x1][y1];
                    }
                    
                    //Suma de los gradientes
                    rAux = sqrt((rXAux*rXAux)+(rYAux*rYAux));
                    gAux = sqrt((gXAux*gXAux)+(gYAux*gYAux));
                    bAux = sqrt((bXAux*bXAux)+(bYAux*bYAux));
                    x1 = x1 + 1;
                    }
                y1 = y1 + 1;
            }
            img2[(i)+(j*pixel_row_num)] =  rAux;
            img2[(i + 1)+(j*pixel_row_num)] = gAux;
            img2[(i + 2)+(j*pixel_row_num)] = bAux;
        } 

    }
    
    //Se crea la nueva imagen
    stbi_write_jpg(nameOutput, width, height, channels, img2, 100);
    free(nameOutput);
    free(name);
    free(img2);
    return 0;
}