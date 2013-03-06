#include <stdio.h>
#define arr_length 5

void block(int);
void each(int[], void (*)(int));

int main(int argc, char const* argv[]) {
    int arr[arr_length] = {1, 1, 2, 3, 5};

    each(arr, block);
    
    return 0;
}

void block(int item) {
    printf("%d\n", item);
}

void each(int arr[], void (*block)(int)) {
    int i;
    for (i = 0; i < arr_length; i++) {
        block(arr[i]);
    }
}

/* =>
 * 1
 * 1
 * 2
 * 3
 * 5
 */
