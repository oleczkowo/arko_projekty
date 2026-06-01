#include <stdio.h>
#include <inttypes.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>


#define BMP_HDR_SIZE 54
#define DEFAULT_PIXEL_OFFSET 54 + 1024
#define DEFAULT_BMP_PLANES 1
#define DEFAULT_BPP 8
#define DEFAULT_DIB_HDR_SIZE 40


// To create empty .bmp files with different resolutions, width / height and filename, change variables below (values above 0 and name not empty)

#define BMP_OUTPUT_FILE "output.bmp"

#define VARI_HOR_RES 1920
#define VARI_VER_RES 1080

#define MAIN_BMP_WIDTH 3000
#define MAIN_BMP_HEIGHT 3000

// ----------------------------------------------------------------------------------------------------------------------------------------------

#pragma pack(1)
typedef struct {
    unsigned char sig0;
    unsigned char sig1;
    uint32_t size;
    uint32_t reserved;
    uint32_t pixel_offset;
    uint32_t header_size;
    uint32_t width;
    uint32_t height;
    uint16_t planes;
    uint16_t bpp;
    uint32_t compression;
    uint32_t image_size;
    uint32_t horizontal_resolution;
    uint32_t vertical_resolution;
    uint32_t color_pallete;
    uint32_t important_colors;
} BmpHeader;

void init_bmp_header(BmpHeader *header) {
    header->sig0 = 'B';
    header->sig1 = 'M';
    header->reserved = 0;
    header->pixel_offset = DEFAULT_PIXEL_OFFSET;
    header->header_size = DEFAULT_DIB_HDR_SIZE;
    header->planes = DEFAULT_BMP_PLANES;
    header->bpp = DEFAULT_BPP;
    header->compression = 0;
    header->image_size = 0;
    header->horizontal_resolution = VARI_HOR_RES;
    header->vertical_resolution = VARI_VER_RES;
    header->color_pallete = 256;
    header->important_colors = 0;
}

void write_bmp(unsigned char *buffer, size_t size)
{
    FILE *image;

    image = fopen(BMP_OUTPUT_FILE, "wb");
    if (image == NULL) {
        printf("Could not open the file %s\n", "output");
        exit(-1);
    }
    fwrite(buffer, 1, size, image);
    fclose(image);
}

unsigned char *generate_empty_bitmap(unsigned int width, unsigned int height, size_t *output_size)
{
    unsigned int stride = (width + 3) & ~3;
    *output_size = stride * height + BMP_HDR_SIZE + 256 * 4;
    unsigned char *bitmap = (unsigned char *) malloc(*output_size);

    BmpHeader header;
    init_bmp_header(&header);
    header.size = *output_size;
    header.width = width;
    header.height = height;
    memcpy(bitmap, &header, BMP_HDR_SIZE);
    for (int i = 0; i < 256; i++) {
        bitmap[BMP_HDR_SIZE + i * 4 + 0] = i; // Blue
        bitmap[BMP_HDR_SIZE + i * 4 + 1] = i; // Green
        bitmap[BMP_HDR_SIZE + i * 4 + 2] = i; // Red
        bitmap[BMP_HDR_SIZE + i * 4 + 3] = 0; // Reserved
    }
    for (int i = BMP_HDR_SIZE + 256 * 4; i < *output_size; ++i) {
        bitmap[i] = 0x00;
    }
    return bitmap;
}

extern void wu_line(unsigned char *bmp, uint32_t xs, uint32_t ys, uint32_t xe, uint32_t ye, uint32_t color);


int main(int argc, char* argv[])
{
    int flag = 0;

    if (argc != 6) {
        printf("Expected 5 arguments, got %d. Required: start x, start y, end x, end y, color in hex.\n", argc - 1);
        return 1;
    }

    uint32_t x_start = strtol(argv[1], NULL, 0);
    uint32_t y_start = strtol(argv[2], NULL, 0);
    uint32_t x_end = strtol(argv[3], NULL, 0);
    uint32_t y_end = strtol(argv[4], NULL, 0);
    uint32_t color = strtol(argv[5], NULL, 0);

    // below I have to define the range of colors, so that the program works correctly

    if (color < 0x00 || color > 0xFF) {
        printf("Color in hex has to be in range of <0x00 (0), 0xFF (255)>\n");
        return 1;
    }

    // if any of the coordinates are out of range, don't run the program

    uint32_t x1 = x_start >> 0x10;
    uint32_t y1 = y_start >> 0x10;
    uint32_t x2 = x_end >> 0x10;
    uint32_t y2 = y_end >> 0x10;
    uint32_t c = color;

    if (x1 < 0 || x1 > MAIN_BMP_WIDTH - 1) {printf("x1 is invalid. Expected x1 in range 0-%d.\n", MAIN_BMP_WIDTH - 1);flag = 1;}
    if (y1 < 0 || y1 > MAIN_BMP_HEIGHT - 1) {printf("y1 is invalid. Expected y1 in range 0-%d.\n", MAIN_BMP_HEIGHT - 1); flag = 1;}
    if (x2 < 0 || x2 > MAIN_BMP_WIDTH - 1) {printf("x2 is invalid. Expected x2 in range 0-%d.\n", MAIN_BMP_WIDTH - 1); flag = 1;}
    if (y2 < 0 || y2 > MAIN_BMP_HEIGHT - 1) {printf("y2 is invalid. Expected y2 in range 0-%d.\n", MAIN_BMP_HEIGHT - 1); flag = 1;}

    if (flag == 1) return 1;

    size_t bmp_size = 0;
    unsigned char *bmp_buffer = generate_empty_bitmap(MAIN_BMP_WIDTH, MAIN_BMP_HEIGHT, &bmp_size);
    printf("======START======\n");
    printf("Struct size [bytes]: %d\n", sizeof(BmpHeader));
    printf("BMP buffer size [bytes]: %d\n", bmp_size);
    printf("Bitmap resolution: %d x %d; Bitmap width: %d, Bitmap height: %d\n", VARI_HOR_RES, VARI_VER_RES, MAIN_BMP_WIDTH, MAIN_BMP_HEIGHT);
    printf("Start point : (%u, %u); end point : (%u, %u)\n", x1, y1, x2, y2);
    printf("Saving bitmap to output file: %s\n", BMP_OUTPUT_FILE);
    wu_line(bmp_buffer, x1, y1, x2, y2, c);
    write_bmp(bmp_buffer, bmp_size);
    free(bmp_buffer);
    printf("=======END=======\n");
    return 0;
}