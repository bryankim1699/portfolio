/************************************************************************
**
** NAME:        gameoflife.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Justin Yokota - Starter Code
**				Bryan Kim
**
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

//Determines what color the cell at the given row/col should be. This function allocates space for a new Color.
//Note that you will need to read the eight neighbors of the cell in question. The grid "wraps", so we treat the top row as adjacent to the bottom row
//and the left column as adjacent to the right column.
Color *evaluateOneCell(Image *image, int row, int col, uint32_t rule)
{
  //neighbor prep
  int row_below = row + 1;
  if (row_below >= image->rows) {
    row_below = 0;
  }
  int row_above = row - 1;
  if (row_above < 0) {
    row_above = image->rows - 1;
  }
  int col_left = col - 1;
  if (col_left < 0) {
    col_left = image->cols - 1;
  }
  int col_right = col + 1;
  if (col_right >= image->cols) {
    col_right = 0;
  }
  uint8_t one_zero;
  // shitty read rule
  /*int alive_counter[9];
  int dead_counter[9];
  for (int i = 0; i < 18; i++) {
    one_zero = rule & 1;
    if (one_zero == 1) {
      if (i < 9) {
        dead_counter[i] = one_zero;
      }
      else {
        alive_counter[i - 9] = one_zero;
      }
    }
    rule = rule >> 1;
  }*/
  struct Color *onecell = malloc(sizeof(struct Color));
  if (onecell == NULL) {
    return 0;
  }
  onecell->R = 0;
  onecell->G = 0;
  onecell->B = 0;
  int how_many_alive;
  for (int i = 0; i < 8; i++) {
    one_zero = (image->image[row][col].R >> i) & 1;
    if ((image->image[row_above][col].R >> i) & 1) {
      how_many_alive = how_many_alive + 1;
    }
    if ((image->image[row_above][col_right].R >> i) & 1) {
      how_many_alive = how_many_alive + 1;
    }
    if ((image->image[row][col_right].R >> i) & 1) {
      how_many_alive = how_many_alive + 1;
    }
    if ((image->image[row_below][col_right].R >> i) & 1) {
      how_many_alive = how_many_alive + 1;
    }
    if ((image->image[row_below][col].R >> i) & 1) {
      how_many_alive = how_many_alive + 1;
    }
    if ((image->image[row_below][col_left].R >> i) & 1) {
      how_many_alive = how_many_alive + 1;
    }
    if ((image->image[row][col_left].R >> i) & 1) {
      how_many_alive = how_many_alive + 1;
    }
    if ((image->image[row_above][col_left].R >> i) & 1) {
      how_many_alive = how_many_alive + 1;
    }
    if (one_zero == 1) {
      if (((rule >> (9 + i)) & 1) == 1) {
        onecell->R = onecell->R + (uint8_t) (1<<i);
      } else {
        onecell->R = onecell->R + (uint8_t) (0<<i);
      }
    } else {
      if (((rule >> i) & 1) == 1) {
        onecell->R = onecell->R + (uint8_t) (1<<i);
      } else {
        onecell->R = onecell->R + (uint8_t) (0<<i);
      }
    }
    how_many_alive = 0;
  }

  for (int i = 0; i < 8; i++) {
    one_zero = (image->image[row][col].G >> i) & 1;
    if ((image->image[row_above][col].G >> i) & 1) {
      how_many_alive = how_many_alive + 1;
    }
    if ((image->image[row_above][col_right].G >> i) & 1) {
      how_many_alive = how_many_alive + 1;
    }
    if ((image->image[row][col_right].G >> i) & 1) {
      how_many_alive = how_many_alive + 1;
    }
    if ((image->image[row_below][col_right].G >> i) & 1) {
      how_many_alive = how_many_alive + 1;
    }
    if ((image->image[row_below][col].G >> i) & 1) {
      how_many_alive = how_many_alive + 1;
    }
    if ((image->image[row_below][col_left].G >> i) & 1) {
      how_many_alive = how_many_alive + 1;
    }
    if ((image->image[row][col_left].G >> i) & 1) {
      how_many_alive = how_many_alive + 1;
    }
    if ((image->image[row_above][col_left].G >> i) & 1) {
      how_many_alive = how_many_alive + 1;
    }
    if (one_zero == 1) {
      if (((rule >> (9 + i)) & 1) == 1) {
        onecell->G = onecell->G + (uint8_t) (1<<i);
      } else {
        onecell->G = onecell->G + (uint8_t) (0<<i);
      }
    } else {
      if (((rule >> i) & 1) == 1) {
        onecell->G = onecell->G + (uint8_t) (1<<i);
      } else {
        onecell->G = onecell->G + (uint8_t) (0<<i);
      }
    }
    how_many_alive = 0;
  }

  for (int i = 0; i < 8; i++) {
    one_zero = (image->image[row][col].B >> i) & 1;
    if ((image->image[row_above][col].B >> i) & 1) {
      how_many_alive = how_many_alive + 1;
    }
    if ((image->image[row_above][col_right].B >> i) & 1) {
      how_many_alive = how_many_alive + 1;
    }
    if ((image->image[row][col_right].B >> i) & 1) {
      how_many_alive = how_many_alive + 1;
    }
    if ((image->image[row_below][col_right].B >> i) & 1) {
      how_many_alive = how_many_alive + 1;
    }
    if ((image->image[row_below][col].B >> i) & 1) {
      how_many_alive = how_many_alive + 1;
    }
    if ((image->image[row_below][col_left].B >> i) & 1) {
      how_many_alive = how_many_alive + 1;
    }
    if ((image->image[row][col_left].B >> i) & 1) {
      how_many_alive = how_many_alive + 1;
    }
    if ((image->image[row_above][col_left].B >> i) & 1) {
      how_many_alive = how_many_alive + 1;
    }
    if (one_zero == 1) {
      if (((rule >> (9 + i)) & 1) == 1) {
        onecell->B = onecell->B + (uint8_t) (1<<i);
      } else {
        onecell->B = onecell->B + (uint8_t) (0<<i);
      }
    } else {
      if (((rule >> i) & 1) == 1) {
        onecell->B = onecell->B + (uint8_t) (1<<i);
      } else {
        onecell->B = onecell->B + (uint8_t) (0<<i);
      }
    }
    how_many_alive = 0;
  }
  /*uint32_t mask = ~(1 << 9)
  uint32_t alive_rule = rule >> 9;
  uint32_t dead_rule = rule & mask; */
  return onecell;
}

//The main body of Life; given an image and a rule, computes one iteration of the Game of Life.
//You should be able to copy most of this from steganography.c
Image *life(Image *image, uint32_t rule)
{
  struct Image *new_image = (struct Image*) malloc(sizeof(struct Image));
  if (new_image == NULL) {
    return 0;
  }
  new_image->rows = image->rows;
  new_image->cols = image->cols;
  struct Color *what_color;
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
      what_color = evaluateOneCell(image, i, j, rule);
			if (what_color == 0) {
				return 0;
			}
      new_image->image[i][j].R = what_color->R;
      new_image->image[i][j].G = what_color->G;
      new_image->image[i][j].B = what_color->B;
      free(what_color);
    }
  }
  return new_image;
}

/*
Loads a .ppm from a file, computes the next iteration of the game of life, then prints to stdout the new image.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a .ppm.
argv[2] should contain a hexadecimal number (such as 0x1808). Note that this will be a string.
You may find the function strtol useful for this conversion.
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!

You may find it useful to copy the code from steganography.c, to start.
*/
void processCLI(int argc, char **argv, char **filename)
{
        if (argc != 3) {
                printf("filename is an ASCII PPM file (type P3) with maximum value 255.\n");
                printf("rule is a hex number beginning with 0x; Life is 0x1808.\n");
                exit(-1);
        }
        *filename = argv[1];
}

int main(int argc, char **argv)
{
  char *filename;
  //char *rule;
  uint32_t rule_int;
  processCLI(argc, argv, &filename);
  char *ptr;
  rule_int = strtol(argv[2], &ptr, 16);
  struct Image *tolife = readData(filename);
	if (tolife == 0) {
		return -1;
	}
  struct Image *lifed = life(tolife, rule_int);
	if (lifed == 0) {
		return -1;
	}
  freeImage(tolife);
  writeData(lifed);
  freeImage(lifed);
  return 0;
}
