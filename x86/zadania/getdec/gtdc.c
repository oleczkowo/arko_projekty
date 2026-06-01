#include <stdio.h>

unsigned int getdec(char *s);

int main(int argc, char *argv[])
{
    if (argc != 2)
        return 1;

    printf("Result : %u\n", getdec(argv[1]));
}