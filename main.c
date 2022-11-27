#include <stdio.h>
#include <time.h>
#include <string.h>
#include <stdlib.h>

double f(double, double);

double gen_double() {
    srand(time(NULL));
    double num = rand() % 2000 - 1000;
    double denom = rand() % 1000 + 1;
    return num / denom;
}

int main(int argc, char *argv[]) {

    FILE *fin, *fout;

    if (argc < 3) {
        fprintf(stderr, "At least 3 parameters must be provided\n");
        return 1;
    }

    double eps = strtod(argv[1], NULL);
    int iterations = atoi(argv[2]);
    
    if (!strcmp(argv[3], "-i")) {
        fin = stdin;
        fout = stdout;
    } else if (!strcmp(argv[3], "-f")) {
        if (argc < 6) {
            fprintf(stderr, "Input/output files are not provided\n");
            return 1;
        }
        fin = fopen(argv[4], "r");
        fout = fopen(argv[5], "w");
    } else if (!strcmp(argv[3], "-g")) {
        if (argc < 5) {
            fprintf(stderr, "Output file is not provided\n");
            return 1;
        }
        fin = NULL;
        fout = fopen(argv[4], "w");
    } else {
        fprintf(stderr, "Invalid parameter\n");
    }
    
    double x;
    if (fin == NULL) {
        x = gen_double();
        printf("%f\n", x);
    } else {
        fscanf(fin, "%lf", &x);
    }

    double res = -1;
    clock_t start = clock();
    for (int i = 0; i < iterations; i++) {
        res = f(x, eps); 
    }
    clock_t end = clock();

    fprintf(fout, "%f\n", res);
    fprintf(fout, "The time of the calculating of %d iterations: %f clocks or %f seconds\n", iterations, (double)(end - start), (end - start) / (double)CLOCKS_PER_SEC);

    if (fin != stdin && fin != NULL) {
        fclose(fin);
    }
    if (fout != stdout) {
        fclose(fout);
    }

    return 0;
}