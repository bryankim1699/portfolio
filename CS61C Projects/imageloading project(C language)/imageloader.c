/************************************************************************
**
** NAME:        imageloader.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**              Justin Yokota - Starter Code
**				Bryan Kim
**
**
** DATE:        2020-08-15
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>
#include "imageloader.h"

//Opens a .ppm P3 image file, and constructs an Image object.
//You may find the function fscanf useful.
//Make sure that you close the file with fclose before returning.
Image *readData(char *filename)
{
struct Image *picture = (struct Image*) malloc(sizeof(struct Image));
if (picture == NULL) {
  return 0;
}
FILE *fp = fopen(filename, "r");
fscanf(fp, "%*s %u %u %*s", &(picture->cols), &(picture->rows));
picture->image = (struct Color**) malloc(picture->rows * sizeof(struct Color*));
///*(picture->image) = (struct Color*) malloc(picture->rows * picture->cols * sizeof(struct Color));
if (picture->image == NULL) {
  return 0;
}
for (int z = 0; z<picture->rows; z++) {
  (picture->image)[z] = (struct Color*) malloc(picture->cols * sizeof(struct Color));
}
for (int i = 0; i<picture->rows; i++) {
  if ((picture->image)[i] == NULL) {
    return 0;
  }
  for(int j = 0; j<picture->cols; j++) {
    fscanf(fp, "%hhu %hhu %hhu",
          &(picture->image[i][j].R),
          &(picture->image[i][j].G),
          &(picture->image[i][j].B));
  }
}
fclose(fp);
return picture;
}


//Given an image, prints to stdout (e.g. with printf) a .ppm P3 file with the image's data.
void writeData(Image *image)
{
  printf("P3\n");
  printf("%hhu %hhu\n", image->cols, image->rows);
  printf("255\n");
  for (int i = 0; i<image->rows; i++){
    for (int j = 0; j<image->cols; j++) {
      if (j == 0) {
        printf("%3hhu %3hhu %3hhu",
          image->image[i][j].R,
          image->image[i][j].G,
          image->image[i][j].B);
      }
      else if (j == image->cols - 1) {
        printf("   %3hhu %3hhu %3hhu\n",
          image->image[i][j].R,
          image->image[i][j].G,
          image->image[i][j].B);
      }
      else {
        printf("   %3hhu %3hhu %3hhu",
          image->image[i][j].R,
          image->image[i][j].G,
          image->image[i][j].B);
      }
    }
  }
}

//Frees an image
void freeImage(Image *image)
{
  for (int z = 0; z<image->rows; z++) {
    free((image->image)[z]);
  }
  free(image->image);
  free(image);
}
