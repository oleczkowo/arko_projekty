#include <stdio.h>

char *rmrngasm(char *s, char a, char b);

int main(int argc, char *argv[])
{
    if (argc != 4)
        {
            return 1;
        }
    char* input_str = argv[1];
    char a = argv[2][0];
    char b = argv[3][0];

    if (b <= a) {
        return 1;
    }
    char *result = rmrngasm(input_str, a, b);
    printf("Result: %s\n", result);
}