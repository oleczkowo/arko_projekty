#include <stdio.h>

char *replnum(char *s, char a);

int main(int argc, char *argv[])
{
    if (argc != 3)
        return 1;

    char* input_str = argv[1];
    char a = argv[2][0];

    char *result = replnum(input_str, a);
    printf("Result : %s\n", result);
}