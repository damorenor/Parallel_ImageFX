#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <sys/time.h>
#include <omp.h>

#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"
#define MAX_BRIGHTNESS  255 /* Maximum gray level */



int main(int argc, char **argv)
{
    /*----Preparacion de los parametros----*/

    int width, height, channels, sizeKernel, kernel, threads, process_id, num_procs;
    double tval_result = 0.0;

    //MPI initialization
    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &num_procs);
    MPI_Comm_rank(MPI_COMM_WORLD, &process_id);

    char *name;
    char *nameOutput;

    //Matrices de Convolucion
    int kernelx[3][3] = { {-1, 0, 1} ,{-2, 0, 2 },{-1, 0, 1 }};
    int kernelx2[5][5] = { {-2, -1, 0, 1, 2}, {-2, -1, 0, 1, 2} ,{-4, -2, 0, 2, 4}, {-2, -1, 0, 1, 2}, {-2, -1, 0, 1, 2} };

    //Informacion de entrada
    name = malloc(sizeof(char));
    nameOutput = malloc(sizeof(char));
    //printf("Introduce el nombre de la imagen, el nombre de la nueva imagen y el tamaño del kernel (3 o 5)  separados por un espacio: \n");
    scanf("%s %s %d %d", name, nameOutput, &kernel, &threads);

    omp_set_num_threads(threads);

    if(kernel != 3 && kernel != 5){
        exit(1);
    }

    tval_result -= MPI_Wtime();

    sizeKernel = (kernel - 1) / 2;

    //Carga de imagen usando laS librerias
    unsigned char *img = stbi_load(name, &width, &height, &channels, 3);
    char *img2;
    img2 = malloc(width * channels* height*sizeof(char));
    sub_img2 = malloc(width * channels* height*sizeof(char) / num_procs);
    int pixel_row_num = width * channels;
    if(img == NULL){
        printf("Error al Cargar Imagen: ");
        printf("%s\n", stbi_failure_reason());
        exit(1);
    }

    /*----Aplicacion del operador sobel----*/

    //Itera por cada fila del arreglo de pixeles
    int chunk_size = (height - sizeKernel*2)/num_procs;
    int start = chunk_size*process_id, finish = chunk_size*(process_id+1);

    #pragma omp parallel for
    for(int j = start; j<finish; j++){

        int hilo = omp_get_thread_num();
        //printf("%d %d\n", j, hilo);
        
        //Itera por cada pixel en la fila (cada 3 canales en el arreglo)
        for(int i = sizeKernel*3; i<pixel_row_num-(sizeKernel* 3); i+=3){
            int rAux = 0, gAux = 0,bAux = 0, rXAux = 0, gXAux = 0,bXAux = 0, rYAux = 0, gYAux = 0,bYAux = 0,y1 = 0;
            
            //Itera entre los 8 o 16 vecinos del pixel segun la matriz a aplicar
            for (int x = -1*sizeKernel; x <= 1*sizeKernel; x++) {
                int x1 = 0;

                for (int y = -3*sizeKernel; y <= 3*sizeKernel; y+=3) {
                    
                    //Extraccion del color en cada canal del pixel
                    int r = img[(i + y)+((j+x)*pixel_row_num)];
                    int g = img[(i + 1 + y)+((j+x)*pixel_row_num)];
                    int b = img[(i + 2 + y)+((j+x)*pixel_row_num)];
                    
                    
                    // Filtro a escala de grises 
                    int t = r*0.299 + g*0.587 + b*0.114;
                    r = t;
                    g = t;
                    b = t;

                    //Gradiente X y Y del Sobel segun matriz a utilizar (3x3 o 5x5)
                    if(sizeKernel == 2){
                        //Caso 5x5
                        //GradX
                        rXAux += r * kernelx2[y1][x1];
                        gXAux += g * kernelx2[y1][x1];
                        bXAux += b * kernelx2[y1][x1];
                        //GradY
                        rYAux += r * kernelx2[x1][y1];
                        gYAux += g * kernelx2[x1][y1];
                        bYAux += b * kernelx2[x1][y1];
                    }else if(sizeKernel == 1 ){
                        //Caso 3x3
                        //GradX
                        rXAux += r * kernelx[y1][x1];
                        gXAux += g * kernelx[y1][x1];
                        bXAux += b * kernelx[y1][x1];
                        //GradY
                        rYAux += r * kernelx[x1][y1];
                        gYAux += g * kernelx[x1][y1];
                        bYAux += b * kernelx[x1][y1];
                    }
                    
                    //Suma de los gradientes
                    rAux = sqrt((rXAux*rXAux)+(rYAux*rYAux));
                    gAux = sqrt((gXAux*gXAux)+(gYAux*gYAux));
                    bAux = sqrt((bXAux*bXAux)+(bYAux*bYAux));
                    x1 = x1 + 1;
                    }
                y1 = y1 + 1;
            }
            //Insercion de los nuevos pixeles en una nueva imagen
            sub_img2[(i)+(j*pixel_row_num)] =  rAux;
            sub_img2[(i + 1)+(j*pixel_row_num)] = gAux;
            sub_img2[(i + 2)+(j*pixel_row_num)] = bAux;
        } 

    }

    //Creacion de la nueva imagen
    int tam = width * channels* height*sizeof(char) / num_procs;
    MPI_Gather(sub_img2, tam, MPI_UNSIGNED_CHAR, img2, tam, MPI_UNSIGNED_CHAR, 0, MPI_COMM_WORLD);
    stbi_write_jpg(nameOutput, width, height, channels, img2, 100);

    tval_result += MPI_Wtime();

    printf("t: %.6f", tval_result);

    free(nameOutput);
    free(name);
    free(img2);
    MPI_Finalize();
    return 0;
}
