module parser

import os

pub fn parse_shell_aliases_and_function(path string) (map[string]string, map[string][]string) {
	lines := os.read_lines(path) or { panic('Error reading ${path}: ${err}') }

	mut alias_map := map[string]string{}
	mut function_map := map[string][]string{}

	// println('lines: ${lines}')
	mut i := 0
	for i < lines.len {
		line := lines[i].trim_space()
		if line == '' || line.starts_with('#') {
			i++
			continue
		} else if line.starts_with('alias') {
			alias_name, alias_command := line.split_once('=') or { 
				i++
				continue
			}
			alias_map[alias_name['alias '.len..]] = alias_command
			i++
		} else if line.contains('()') && line.contains('{') {
			// This is likely the start of a function
			// Extract the function name (everything before '()')
			func_name := line.split('(')[0].trim_space()
			
			// Start collecting function body
			mut function_body := []string{}
			mut braces_count := 1 // Already encountered one opening brace
			
			// If there's content after the opening brace on the same line
			if line.index_after('{', 0) < line.len - 1 {
				function_body << line[line.index_after('{', 0) + 1..].trim_space()
			}
			
			i++ // Move to the next line
			
			// Continue until we find the matching closing brace
			for i < lines.len && braces_count > 0 {
				current := lines[i].trim_space()
				
				if current.contains('{') {
					braces_count++
				}
				if current.contains('}') {
					braces_count--
					if braces_count == 0 {
						// Don't include the closing brace line
						break
					}
				}
				
				function_body << current
				i++
			}
			
			// Store the function in the map
			function_map[func_name] = function_body
			i++ // Move past the closing brace
		} else {
			i++
		}
	}

	return alias_map, function_map
}
