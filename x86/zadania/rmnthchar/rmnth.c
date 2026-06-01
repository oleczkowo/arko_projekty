#include <stdio.h>

char *rmnthasm(char *s, int n);

int main(int argc, char *argv[])
{
    if (argc != 3)
        return 1;
    char* input_str = argv[1];
    int x;
    if (sscanf(argv[2], "%d", &x))
        printf("arg %d is number %d\n", 2, x);
    else {
        printf("wrong argument %d\n", 2);
        return 1;
    }
    if (x > 0 && x <= sizeof(input_str)){
        char *result = rmnthasm(input_str, x);
        printf("Result: %s\n", result);
        return 0;
    }
    else
        return 1;
}