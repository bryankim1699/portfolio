/************************************************************************
**
** NAME:        steganography.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**				Justin Yokota - Starter Code
**				YOUR NAME HERE
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

//Determines what color the cell at the given row/col should be. This should not affect Image, and should allocate space for a new Color.
Color *evaluateOnePixel(Image *image, int row, int col)
{
  struct Color *onepix = malloc(sizeof(struct Color));
  	if (onepix == NULL) {
      return 0;
  }
  uint8_t b_w = (image->image[row][col].B) & 1;
  if (b_w == 1) {
    onepix->R = 255;
    onepix->G = 255;
    onepix->B = 255;
  } else {
    onepix->R = 0;
    onepix->G = 0;
    onepix->B = 0;
  }
  return onepix;
}


//Given an image, creates a new image extracting the LSB of the B channel.
Image *steganography(Image *image)
{
        struct Image *new_image = (struct Image*) malloc(sizeof(struct Image));
  if (new_image == NULL) {
    return 0;
  }
  new_image->rows = image->rows;
  new_image->cols = image->cols;
  struct Color *black_or_white;
  new_image->image = (struct Color**) malloc(new_image->rows * sizeof(struct Color*));
        ///added null check
        if (new_image->image == NULL) {
    return 0;
  }
  for (int z = 0; z<new_image->rows; z++) {
    (new_image->image)[z] = (struct Color*) malloc(new_image->cols * sizeof(struct Color));
  }
  for (int i = 0; i < new_image->rows; i++) {
                ///added null check
                if ((new_image->image)[i] == NULL) {
      return 0;
    }
    for (int j = 0; j < new_image->cols; j++) {
      black_or_white = evaluateOnePixel(image, i, j);
                        if (black_or_white == 0) {
                                return 0;
                        }
      new_image->image[i][j].R = black_or_white->R;
      new_image->image[i][j].G = black_or_white->G;
      new_image->image[i][j].B = black_or_white->B;
      free(black_or_white);
    }
  }
  return new_image;
}

/*
Loads a .ppm from a file, and prints to stdout (e.g. with printf) a new image,
where each pixel is black if the LSB of the B channel is 0,
and white if the LSB of the B channel is 1.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a .ppm.
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!
*/
void processCLI(int argc, char **argv, char **filename)
{
        if (argc != 2) {
                printf("usage: %s filename\n",argv[0]);
                printf("filename is an ASCII PPM file (type P3) with maximum value 255.\n");
                exit(-1);
        }
        *filename = argv[1];
}

int main(int argc, char **argv)
{
  char *filename;
  processCLI(argc, argv, &filename);
  struct Image *apples = readData(filename);
        if (apples == 0) {
                return -1;
        }
  struct Image *pears = steganography(apples);
        if (pears == 0) {
                return -1;
        }
  freeImage(apples);
  writeData(pears);
  freeImage(pears);
  return 0;
}
