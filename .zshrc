# Function to compile and run a C program
# Usage: comp <filename_without_extension>
# Example: comp hello (will compile hello.c to hello, then run ./hello)
comp() {
    clear
    clang "$1.c" -o "$1" && "./$1"
}

# Alias
alias ll='ls -a'
alias reload='source ~/.zshrc'

# Oh-My-Zsh
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="bira"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

path=('/Users/nano/.juliaup/bin' $path)
export PATH

# <<< juliaup initialize <<<
