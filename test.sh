(set -ex
CFLAGS=""
CFLAGS="$CFLAGS -DHAVE_UNISTD_H"
# CFLAGS="$CFLAGS -D_LARGEFILE64_SOURCE=1"
CFLAGS="$CFLAGS -I."
CFLAGS="$CFLAGS -L."
CFLAGS="$CFLAGS -O3"
CFLAGS="$CFLAGS -Wall"
CFLAGS="$CFLAGS -Werror"

export LD_LIBRARY_PATH="."

VERSION=1.2.13


printf "\n\ntest zlib static\n"
rm -f \
  *.a \
  *.exe \
  *.o \
  libz.* \
  test_file_*

printf "\nbuild static libz.a\n"
gcc $CFLAGS \
    -DZLIB_C2 \
    -c \
    -o zlib_rollup.o \
    zlib_rollup.c
ar rc libz.a zlib_rollup.o
ranlib libz.a

printf "\nbuild static test_example.exe\n"
gcc $CFLAGS \
    -DZLIB_TEST_EXAMPLE_C2 \
    -c \
    -o test_example.o \
    zlib_rollup.c
gcc $CFLAGS \
    -o test_example.exe \
    test_example.o \
    libz.a

printf "\nbuild static test_minigzip.exe\n"
gcc $CFLAGS \
    -DZLIB_TEST_MINIGZIP_C2 \
    -c \
    -o test_minigzip.o \
    zlib_rollup.c
gcc $CFLAGS \
    -o test_minigzip.exe \
    test_minigzip.o \
    libz.a

printf "\ntest static\n"
if [ "Hello world!" = "$( \
    printf "Hello world!\n" | ./test_minigzip.exe | ./test_minigzip.exe -d \
    )" ] \
    && ./test_example.exe test_file_static
then
    printf "\n    *** zlib test static OK ***\n"
else
    printf "\n    *** zlib test static FAILED ***\n"
    exit 1
fi


printf "\n\ntest zlib shared\n"
rm -f \
  *.a \
  *.exe \
  *.o \
  libz.* \
  test_file_*

printf "\nbuild shared libz.a\n"
gcc $CFLAGS \
    -DPIC \
    -DZLIB_C2 \
    -c \
    -fPIC \
    -o zlib_rollup.o \
    zlib_rollup.c
gcc $CFLAGS \
    -DZLIB_C2 \
    -fPIC \
    -o libz.so.$VERSION \
    -shared \
    zlib_rollup.o
ln -s libz.so.$VERSION libz.so
ln -s libz.so.$VERSION libz.so.1

printf "\nbuild shared test_example.exe\n"
gcc $CFLAGS \
    -DZLIB_TEST_EXAMPLE_C2 \
    -c \
    -o test_example.o \
    zlib_rollup.c
gcc $CFLAGS \
    -o test_example.exe \
    test_example.o \
    libz.so.$VERSION

printf "\nbuild shared test_minigzip.exe\n"
gcc $CFLAGS \
    -DZLIB_TEST_MINIGZIP_C2 \
    -c \
    -o test_minigzip.o \
    zlib_rollup.c
gcc $CFLAGS \
    -o test_minigzip.exe \
    test_minigzip.o \
    libz.so.$VERSION

printf "\ntest shared\n"
if [ "Hello world!" = "$( \
    printf "Hello world!\n" | ./test_minigzip.exe | ./test_minigzip.exe -d \
    )" ] \
    && ./test_example.exe test_file_shared
then
    printf "\n    *** zlib test shared OK ***\n"
else
    printf "\n    *** zlib test shared FAILED ***\n"
    exit 1
fi


printf "\n\ntest zlib 64\n"
rm -f \
  *.a \
  *.exe \
  *.o \
  libz.* \
  test_file_*

printf "\nbuild 64 libz.a\n"
gcc $CFLAGS \
    -DZLIB_C2 \
    -D_LARGEFILE64_SOURCE=1 \
    -c \
    -o zlib_rollup.o \
    zlib_rollup.c
ar rc libz.a zlib_rollup.o
ranlib libz.a

printf "\nbuild 64 test_example.exe\n"
gcc $CFLAGS \
    -DZLIB_TEST_EXAMPLE_C2 \
    -D_FILE_OFFSET_BITS=64 \
    -D_LARGEFILE64_SOURCE=1 \
    -c \
    -o test_example.o \
    zlib_rollup.c
gcc $CFLAGS \
    -D_LARGEFILE64_SOURCE=1 \
    -o test_example.exe \
    test_example.o \
    libz.a

printf "\nbuild 64 test_minigzip.exe\n"
gcc $CFLAGS \
    -DZLIB_TEST_MINIGZIP_C2 \
    -D_FILE_OFFSET_BITS=64 \
    -D_LARGEFILE64_SOURCE=1 \
    -c \
    -o test_minigzip.o \
    zlib_rollup.c
gcc $CFLAGS \
    -D_LARGEFILE64_SOURCE=1 \
    -o test_minigzip.exe \
    test_minigzip.o \
    libz.a

printf "\ntest 64\n"
if [ "Hello world!" = "$( \
    printf "Hello world!\n" | ./test_minigzip.exe | ./test_minigzip.exe -d \
    )" ] \
    && ./test_example.exe test_file_64
then
    printf "\n    *** zlib test 64 OK ***\n"
else
    printf "\n    *** zlib test 64 FAILED ***\n"
    exit 1
fi
)
