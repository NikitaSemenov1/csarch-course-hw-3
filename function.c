#include <math.h>

double f(double x, double eps) {
    
    double exp = 1;
    double term = 1;
    int iteration = 0;
    
    while (1) {
        term *= x;
        term /= ++iteration;
        if (fabs(1 / exp - 1 / (exp + term)) <= eps) {
            return 1 / (exp + term);
        }
        exp += term;
    }
}