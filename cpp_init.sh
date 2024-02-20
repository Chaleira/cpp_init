#!/bin/zsh

# chmod +x cpp_init.sh

if [ $# -eq 0 ]; then
	echo "Usage: $0 name1 [name2 ...]"
	exit 1
fi

if [ $# -eq 1 ] && [ "${1:0:1}" = "-" ]; then
	if [ "$1" = "-config" ]; then
		mkdir -p "$HOME"
		mkdir -p "$HOME/.scripts"
		mkdir -p "$HOME/.scripts/cpp_init"
		chmod +x cpp_init.sh
		mv cpp_init.sh "$HOME/.scripts/cpp_init/cpp_init"
		echo -e "\nexport PATH=~/.scripts/cpp_init:\$PATH" >> ~/.bashrc
		echo -e "\nexport PATH=~/.scripts/cpp_init:\$PATH" >> ~/.zshrc
		cd ..
		rm -rf cpp_init
		exit 0
	elif [ "$1" = "-h" ] || [ "$1" = "-help" ]; then
		echo "Usage: $0 name1 [name2 ...]"
		exit 0
	fi
	echo "Something went wrong"
	exit 1
fi

for name in "${@:2}"; do
	if [[ ! "$name" =~ ^[[:alnum:]]+$ ]]; then
		echo "Invalid name: $name"
		exit 1
	fi
done

if [ ! -d "$1" ]; then
	mkdir -p $1
fi
main_folder="$1"
srcs_folder="$main_folder/sources"
incs_folder="$main_folder/includes"

if [ ! -d "$srcs_folder" ]; then
	mkdir -p $srcs_folder
fi
if [ ! -d "$incs_folder" ]; then
	mkdir -p $incs_folder
fi

set -o shwordsplit

write_hpp() {

local name="$1"

	cat <<EOF > "$main_folder/includes/$name.hpp"
#ifndef ${name}_HPP
# define ${name}_HPP

# include <iostream>
# include <string>
# include <exception>

class $name
{
	private:

	public:
		$name();
		$name(const $name &copy);
		$name &operator=(const $name &copy);
		~$name();
};

#endif
EOF
}

write_cpp() {

local name="$1"

	cat <<EOF > "$main_folder/sources/$name.cpp"
#include "$name.hpp"

$name::$name()
{
	std::cout << "$name constructor called" << std::endl;
}

$name::$name(const $name &copy)
{
	std::cout << "$name copy constructor called" << std::endl;
	// Don't forget to copy the variables here
	*this = copy;
}

$name &$name::operator=(const $name &copy)
{
	(void)copy;
	std::cout << "$name operator= called" << std::endl;
	// Don't forget to copy the variables here
	return *this;
}

$name::~$name()
{
	std::cout << "$name destructor called" << std::endl;
}
EOF
}

write_Makefile() {

	cat <<EOF > "$main_folder/Makefile"
NAME = main

CC = c++

SRCS = 

OBJS_PATH = obj/
SRC_PATH = sources/

CPPFLAGS = -Wall -Werror -Wextra -std=c++98 -Wshadow -I./includes -fsanitize=address

RM = rm -fr

\$(OBJS): \$(OBJS_PATH)

OBJS = \$(SRCS:\$(SRC_PATH)%.cpp=\$(OBJS_PATH)%.o)

all : \$(NAME)

\$(OBJS_PATH)%.o: \$(SRC_PATH)%.cpp | \$(OBJS_PATH)
			@\$(CC) \$(CPPFLAGS) -c \$< -o \$@

\$(OBJS_PATH):
	@mkdir -p \$(OBJS_PATH)

\$(NAME):	\$(OBJS)
			@\$(CC) \$(CPPFLAGS) \$(OBJS) -o \$(NAME)

clean:			
				@\$(RM) \$(OBJS_PATH)	

fclean:			clean
				@\$(RM) \$(NAME)

re:				fclean att all

att:
				@sed -i "5s,.*,SRCS = \$\$(echo sources/*.cpp)," Makefile

r:				re
				@valgrind ./\$(NAME)
EOF
}

write_main() {
    cat << EOF >> "$main_folder/sources/main.cpp"
#include <iostream>

int main(void)
{
    return 0;
}
EOF
}

write_main_includes() {
    local file="$main_folder/sources/main.cpp"
    local temp_file=$(mktemp)

	echo "#include \"$name.hpp\"" >> "$temp_file"
    
	cat "$file" >> "$temp_file"

    mv "$temp_file" "$file"
}

if [ ! -f "$main_folder/sources/main.cpp" ]; then
	touch "$main_folder/sources/main.cpp"
	write_main
fi

for name in "${@:2}"; do

	file_inc="$main_folder/includes/$name.hpp"
	file_src="$main_folder/sources/$name.cpp"
	if [ ! -f "$file_inc" ]; then
		write_hpp $name
		write_main_includes $name
	fi
	if [ ! -f "$file_src" ]; then
		write_cpp $name
	fi
done

if [ ! -f "$main_folder/Makefile" ]; then
	write_Makefile
fi

cd $main_folder
make att
cd ..


