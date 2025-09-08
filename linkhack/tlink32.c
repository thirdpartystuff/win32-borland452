#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static char buf[1048576 * 100];
static char cmd[32768] = __FILE__;

int main(int argc, char** argv)
{
    const char* p;
    size_t len;

    FILE* f = fopen(argv[1] + 1, "rb");
    size_t n = fread(buf, 1, sizeof(buf), f);
    fclose(f);

    for (p = getenv("DEFFILE"); *p; ++p) {
        char ch = *p;
        if (ch == '/')
            ch = '\\';
        buf[n++] = ch;
    }
    buf[n++] = '\r';
    buf[n++] = '\n';

    //fwrite(buf, 1, n, stdout);

    f = fopen(argv[1] + 1, "wb");
    fwrite(buf, 1, n, f);
    fclose(f);

    len = strlen(cmd) - 9; /* "tlink32.c" */
    sprintf(&cmd[len], "..\\bin\\tlink32.exe \"%s\"", argv[1]);

    (void)argc;

    return system(cmd);
}
