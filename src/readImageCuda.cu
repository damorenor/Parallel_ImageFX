/************* add vector ******************************************************/
#include <stdio.h>
// For the CUDA runtime routines (prefixed with "cuda_")
#include <cuda_runtime.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <sys/time.h>
#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"

/*******************************************************************************/

__global__ void
vectorAdd(const int *A, char *B, int numElements, int width, int kernelSize)
{
    int k;
    int i = blockDim.x * blockIdx.x + threadIdx.x;
    int aux = 0;
    int aux2 = 0;
   for(int p = 0; p < (width*3); p++)
   {
    if (i < numElements)
    {    
        if(k == 3){
            aux = A[(i*width*3)+ p]* -1 + A[(i*width*3)+p+3] * 0 + A[(i*width*3)+p+6] * 1 
                + A[(i+1)*(width*3) + p]* -2 + A[(i+1)*(width*3) + p+3] * 0 + A[(i+1)*(width*3) + p+6] * 2 
                + A[(i+2)*(width*3) + p]* -1 + A[(i+2)*(width*3) + p+3] * 0 + A[(i+2)*(width*3) + p+6] * 1;
            aux2= A[(i*width*3) + p]* -1 + A[(i*width*3) + p+3] * -2 + A[(i*width*3)+p+6] * -1 
                + A[(i+1)*(width*3) + p]* 0 + A[(i+1)*(width*3) + p+3] * 0 + A[(i+1)*(width*3) + p+6] * 0 
                + A[(i+2)*(width*3) + p]* 1 + A[(i+2)*(width*3) + p+3] * 2 + A[(i+2)*(width*3) + p+6] * 1;
            B[p+(i*width*3)] = (char) sqrt((float)(aux*aux + aux2*aux2));    
        }
        if(k == 5){
            aux = A[(i*width*3)+ p]* -2 + A[(i*width*3)+p+3] * -1 + A[(i*width*3)+p+6] * 0 + A[(i*width*3)+p+9] * 1 + A[(i*width*3)+p+12] * 2
                + A[(i+1)*(width*3) + p]* -2 + A[(i+1)*(width*3) + p+3] * -1 + A[(i+1)*(width*3) + p+6] * 0 + A[(i+1)*(width*3) + p+9] * 1 + A[(i+1)*(width*3) + p+12] * 2
                + A[(i+2)*(width*3) + p]* -4 + A[(i+2)*(width*3) + p+3] * -2 + A[(i+2)*(width*3) + p+6] * 0 + A[(i+2)*(width*3) + p+9] * 2 + A[(i+2)*(width*3) + p+12] * 4
                + A[(i+3)*(width*3) + p]* -2 + A[(i+3)*(width*3) + p+3] * -1 + A[(i+3)*(width*3) + p+6] * 0 + A[(i+3)*(width*3) + p+9] * 1 + A[(i+3)*(width*3) + p+12] * 2
                + A[(i+4)*(width*3) + p]* -2 + A[(i+4)*(width*3) + p+3] * -1 + A[(i+4)*(width*3) + p+6] * 0 + A[(i+4)*(width*3) + p+9] * 1 + A[(i+4)*(width*3) + p+12] * 2;
            aux2= A[(i*width*3)+ p]* -2 + A[(i*width*3)+p+3] * -2 + A[(i*width*3)+p+6] * -4 + A[(i*width*3)+p+9] * -2 + A[(i*width*3)+p+12] * -2
                + A[(i+1)*(width*3) + p]* -1 + A[(i+1)*(width*3) + p+3] * -1 + A[(i+1)*(width*3) + p+6] * -2 + A[(i+1)*(width*3) + p+9] * -1 + A[(i+1)*(width*3) + p+12] * -1  
                + A[(i+2)*(width*3) + p]* 0 + A[(i+2)*(width*3) + p+3] * 0 + A[(i+2)*(width*3) + p+6] * 0 + A[(i+2)*(width*3) + p+9] * 0 + A[(i+2)*(width*3) + p+12] * 0
                + A[(i+3)*(width*3) + p]* 1 + A[(i+3)*(width*3) + p+3] * 1 + A[(i+3)*(width*3) + p+6] * 2 + A[(i+3)*(width*3) + p+9] * 1 + A[(i+3)*(width*3) + p+12] * 1
                + A[(i+4)*(width*3) + p]* 2 + A[(i+4)*(width*3) + p+3] * 2 + A[(i+4)*(width*3) + p+6] * 4 + A[(i+4)*(width*3) + p+9] * 2 + A[(i+4)*(width*3) + p+12] * 2;

            B[p+(i*width*3)] = (char) sqrt((float)(aux*aux + aux2*aux2));   
        }
        //printf("hilo %d : %d %d %d %d %d %d %d %d %d con resultado x %d y %d = %d en la posición: %d\n",i, A[(i*width*3)+ p], A[(i*width*3)+p+3], A[(i*width*3)+p+6], A[(i+1)*width*3 + p], A[(i+1)*width*3 + p+3], A[(i+1)*width*3 + p+6], A[(i+2)*(width*3) + p], A[(i+2)*(width*3)+p+3], A[(i+2)*(width*3)+p+6],aux,aux2,B[p+(i*width*3)],p+(i*width*3));
        aux=0;
        aux2 = 0;
    }   
   }
}

/*******************************************************************************/
int main(void)
{
    //char *img2;
    char *name;
    char *nameOutput;
    int width, height, channels, kernel;
    struct timeval tval_before, tval_after, tval_result;

    name = (char *) malloc(sizeof(char)*20);
    nameOutput = (char *) malloc(sizeof(char)*20);

    printf("Introduce el nombre de la imagen, el nombre de la nueva imagen y el tamaño del kernel (3 o 5)  separados por un espacio: \n");
    scanf("%s %s %d", name, nameOutput, &kernel);
    if(kernel != 3 && kernel != 5){
        exit(1);
    }
    gettimeofday(&tval_before, NULL);    
    unsigned char *img = stbi_load(name, &width, &height, &channels, 3);
    if(img == NULL){
        printf("Error al Cargar Imagen: ");
        printf("%s\n", stbi_failure_reason());
        exit(1);
    }
    int pixel_row_num = width * channels;

    // Error code to check return values for CUDA calls
    cudaError_t err = cudaSuccess;

    // Print the vector length to be used, and compute its size
    int numElements = pixel_row_num*height;
    size_t size = numElements * sizeof(int);
    //img2 = (char *) malloc(numElements*sizeof(char));

    // Allocate the host input vector A
    int *h_A = (int *)malloc(size);

    // Allocate the host input vector B
    char *h_B = (char *)malloc(size);

    // Verify that allocations succeeded
    if (h_A == NULL || h_B == NULL)
    {
        fprintf(stderr, "Failed to allocate host vectors!\n");
        exit(EXIT_FAILURE);
    }

    // Initialize the host input vectors
    for (int i = 0; i < numElements; i+=3)
    {
        //printf("%d ",img[i]);
        int t = img[i]*0.299 + img[i+1]*0.587 + img[i+2]*0.114;
        h_A[i] = t;
        h_A[i+1] = t;
        h_A[i+2] = t;
    }
    
    // Allocate the device input vector A
    int *d_A = NULL;
    err = cudaMalloc((void **)&d_A, size);

    if (err != cudaSuccess)
    {
        fprintf(stderr, "Failed to allocate device vector A (error code %s)!\n", cudaGetErrorString(err));
        exit(EXIT_FAILURE);
    }

    // Allocate the device input vector B
    char *d_B = NULL;
    err = cudaMalloc((void **)&d_B, size);

    if (err != cudaSuccess)
    {
        fprintf(stderr, "Failed to allocate device vector B (error code %s)!\n", cudaGetErrorString(err));
        exit(EXIT_FAILURE);
    }

    
    // Copy the host input vectors A in host memory to the device input vectors in
    // device memory
    printf("Copy input data from the host memory to the CUDA device\n");
    err = cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);

    if (err != cudaSuccess)
    {
        fprintf(stderr, "Failed to copy vector A from host to device (error code %s)!\n", cudaGetErrorString(err));
        exit(EXIT_FAILURE);
    }

    
    // Launch the Vector Add CUDA Kernel
    int threadsPerBlock = 128;
    int blocksPerGrid =(height + threadsPerBlock - 1) / threadsPerBlock;
    printf("CUDA kernel launch with %d blocks of %d threads\n", blocksPerGrid, threadsPerBlock);
    vectorAdd<<<blocksPerGrid, threadsPerBlock>>>(d_A, d_B, height, width, kernel);
    err = cudaGetLastError();

    if (err != cudaSuccess)
    {
        fprintf(stderr, "Failed to launch vectorAdd kernel (error code %s)!\n", cudaGetErrorString(err));
        exit(EXIT_FAILURE);
    }

    // Copy the device result vector in device memory to the host result vector
    // in host memory.
    printf("Copy output data from the CUDA device to the host memory\n");
    err = cudaMemcpy(h_B, d_B, size, cudaMemcpyDeviceToHost);

    if (err != cudaSuccess)
    {
        fprintf(stderr, "Failed to copy vector B from device to host (error code %s)!\n", cudaGetErrorString(err));
        exit(EXIT_FAILURE);
    }
    
    // Free device global memory
    err = cudaFree(d_A);

    if (err != cudaSuccess)
    {
        fprintf(stderr, "Failed to free device vector A (error code %s)!\n", cudaGetErrorString(err));
        exit(EXIT_FAILURE);
    }
    err = cudaFree(d_B);

    if (err != cudaSuccess)
    {
        fprintf(stderr, "Failed to free device vector B (error code %s)!\n", cudaGetErrorString(err));
        exit(EXIT_FAILURE);
    }
    /*for (int i = 0; i < numElements; ++i)
    {
        //printf("%d ",img[i]);
        img2[i] = h_B[i];
    }*/
    /*for (int i = 0; i < numElements; ++i)
    {
        printf("%d ", h_B[i]);
    }*/
    
    // Free host memory
    // Reset the device and exit
    err = cudaDeviceReset();

    if (err != cudaSuccess)
    {
        fprintf(stderr, "Failed to deinitialize the device! error=%s\n", cudaGetErrorString(err));
        exit(EXIT_FAILURE);
    }
    stbi_write_jpg(nameOutput, width, height, channels, h_B, 100);
    gettimeofday(&tval_after, NULL);
    timersub(&tval_after, &tval_before, &tval_result);
    
    printf("t: %ld.%06lld\n", (long int)tval_result.tv_sec, (long long int)tval_result.tv_usec);
    
    free(nameOutput);
    free(name);
    free(h_A);
    free(h_B);
    return 0;
}
