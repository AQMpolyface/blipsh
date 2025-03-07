module parser

import os

// Test for parse_env function
fn test_env() {
	// Test basic environment variable expansion
	assert parse_env('\$HOME/Desktop') == os.getenv('HOME') + '/Desktop'

	// Test with multiple environment variables
	assert parse_env('\$HOME/\$USER') == os.getenv('HOME') + '/' + os.getenv('USER')

	// Test with environment variable in the middle of string
	assert parse_env('/usr/\$USER/bin') == '/usr/' + os.getenv('USER') + '/bin'

	// Test with non-existent environment variable (should remain unchanged)
	assert parse_env('\$NONEXISTENT_VAR') == ''
}

// Test for merge_maps function
fn test_merge_maps() {
	// Test merging alias maps
	mut alias_map1 := {
		'ls':   'ls -la'
		'grep': 'grep --color=auto'
	}
	mut alias_map2 := {
		'ls': 'ls -l'
		'cd': 'cd ~'
	}

	// Test merging function maps
	mut func_map1 := {
		'func1': ['echo "Hello"', 'return 0']
		'func2': ['echo "World"', 'return 0']
	}
	mut func_map2 := {
		'func1': ['echo "Overridden"', 'return 1']
		'func3': ['echo "New function"', 'return 0']
	}

	merged_alias_map, merged_func_map := merge_maps(alias_map1, func_map1, alias_map2,
		func_map2)

	// Check that alias maps were merged correctly (new map should override old map)
	assert merged_alias_map['ls'] == 'ls -l'
	assert merged_alias_map['grep'] == 'grep --color=auto'
	assert merged_alias_map['cd'] == 'cd ~'
	assert merged_alias_map.len == 3

	// Check that function maps were merged correctly
	assert merged_func_map['func1'].len == 2
	assert merged_func_map['func1'][0] == 'echo "Overridden"'
	assert merged_func_map['func2'].len == 2
	assert merged_func_map['func3'].len == 2
	assert merged_func_map.len == 3
}

// Test for parse_shell_aliases_and_function function
fn test_parse_shell_aliases_and_function() {
	// Create a temporary shell file for testing
	tmp_file := os.temp_dir() + '/test_shell_rc'
	os.write_file(tmp_file, '# Test shell file
alias ls="ls -la"
alias grep="grep --color=auto"

# Test function
test_func() {
    echo "This is a test function"
    return 0
}

another_func() {
    if [ -f "$1" ]; then
        echo "File exists"
    else
        echo "File does not exist"
    }
    return $?
}
') or {
		panic(err)
	}

	defer {
		os.rm(tmp_file) or {}
	}

	// Parse the shell file
	alias_map, func_map := parse_shell_aliases_and_function(tmp_file)

	// Check that aliases were parsed correctly
	assert alias_map['ls'] == '"ls -la"'
	assert alias_map['grep'] == '"grep --color=auto"'
	assert alias_map.len == 2

	// Check that functions were parsed correctly
	assert 'test_func' in func_map
	assert func_map['test_func'].len == 2
	assert func_map['test_func'][0] == 'echo "This is a test function"'
	assert func_map['test_func'][1] == 'return 0'
	// test fail. TODO: fix, prolly fails cuz of if-else-done
	println(func_map['another_func'])
	assert 'another_func' in func_map
	assert func_map['another_func'].len == 6
}

// Test for get_shell_path function
fn test_get_shell_path() {
	home := os.getenv('HOME')

	// Test with different shell types
	assert get_shell_path('zsh', home) == '${home}/.zshrc'
	assert get_shell_path('bash', home) == '${home}/.bashrc'
	assert get_shell_path('fish', home) == '${home}/.config/fish/config'

	// Test with unknown shell (should default to zsh)
	assert get_shell_path('unknown', home) == '${home}/.zshrc'
}
