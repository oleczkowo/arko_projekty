#include <stdio.h>

char *leaverng(char *s, char a, char b);

int main(int argc, char *argv[])
{
    if (argc != 4)
        return 1;

    char* input_str = argv[1];
    char a = argv[2][0];
    char b = argv[3][0];

    char *result = leaverng(input_str, a, b);
    printf("Result: %s\n", result);
}

