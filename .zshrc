# Function to compile and run a C program
# Usage: comp <filename_without_extension>
# Example: comp hello (will compile hello.c to hello, then run ./hello)
comp() {
    clear
    clang "$1.c" -o "$1" && "./$1"
}
