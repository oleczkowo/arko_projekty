#include <stdio.h>

char *reverselet(char *s);

int main(int argc, char *argv[])
{
    if (argc != 2)
        return 1;

    char* input_str = argv[1];

    char *result = reverselet(input_str);

    printf("Result : %s\n", result);
}