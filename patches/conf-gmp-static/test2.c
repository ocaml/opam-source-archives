#include <stdio.h>
#include <gmp.h>

int main(void) {
    // 1. Declare GMP integer types (mpz_t)
    mpz_t a, b, result;

    // 2. Initialize the variables
    mpz_init(a);
    mpz_init(b);
    mpz_init(result);

    // 3. Assign large values (fits arbitrary precision strings)
    mpz_set_str(a, "123456789012345678901234567890", 10);
    mpz_set_str(b, "987654321098765432109876543210", 10);

    // 4. Perform arithmetic: result = a + b
    mpz_add(result, a, b);

    // 5. Print the result using gmp_printf
    gmp_printf("Hello, World from GMP!\n");
    gmp_printf("%Zd + %Zd\n  = %Zd\n", a, b, result);

    // 6. Free memory used by GMP variables
    mpz_clear(a);
    mpz_clear(b);
    mpz_clear(result);

    return 0;
}