module parser

import os
import log

pub fn parse_shell_aliases_and_function(path string) (map[string]string, map[string][]string) {
	lines := os.read_lines(path) or { panic('Error reading ${path}: ${err}') }

	mut alias_map := map[string]string{}
	mut function_map := map[string][]string{}

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
		} else if line.starts_with('source') {
			source_path := line['source '.len..]
			// if contain $ assume there is an env var in the path
			if source_path.contains('$') {
				source_path_after_parsing_env := parse_env(source_path)
				log.info('Sourcing file with env vars: ${source_path} -> ${source_path_after_parsing_env}')
				n_alias_map, n_function_map := parse_shell_aliases_and_function(source_path_after_parsing_env)
				alias_map, function_map = merge_maps(alias_map, function_map, n_alias_map,
					n_function_map)
			} else {
				log.info('Sourcing file: ${source_path}')
				n_alias_map, n_function_map := parse_shell_aliases_and_function(source_path)
				alias_map, function_map = merge_maps(alias_map, function_map, n_alias_map,
					n_function_map)
			}
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

fn merge_maps(ali_map map[string]string, func_map map[string][]string, new_ali_map map[string]string, new_func_map map[string][]string) (map[string]string, map[string][]string) {
	mut return_alias_map := map[string]string{}
	mut return_function_map := map[string][]string{}

	// Handle alias maps
	for key, val in ali_map {
		if key in new_ali_map {
			continue
		} else {
			return_alias_map[key] = val
		}
	}

	for key, val in new_ali_map {
		return_alias_map[key] = val
	}

	// Handle function maps
	for key, val in func_map {
		if key in new_func_map {
			continue
		} else {
			return_function_map[key] = val
		}
	}

	for key, val in new_func_map {
		return_function_map[key] = val
	}

	return return_alias_map, return_function_map
}

pub fn parse_env(path string) string {
	mut result := path
	// Match patterns like ${VAR} or $VAR
	for i := 0; i < result.len; {
		if result[i] == `$` {
			if i + 1 < result.len && result[i + 1] == `{` {
				// Handle ${VAR} format
				end_idx := result.index_after('}', i + 2)
				if end_idx > i + 2 {
					var_name := result[i + 2..end_idx]
					env_value := os.getenv(var_name)
					result = result.replace(var_name, env_value)
					i = i // Stay at same position as string length changed
					continue
				}
			} else {
				// Handle $VAR format
				mut end_idx := i + 1
				for end_idx < result.len && (result[end_idx].is_letter()
					|| result[end_idx] == `_` || (end_idx > i + 1 && result[end_idx].is_digit())) {
					end_idx++
				}
				if end_idx > i + 1 {
					var_name := result[i + 1..end_idx]
					env_value := os.getenv(var_name)
					result = result.replace('$' + var_name, env_value)
					i = i // Stay at same position as string length changed
					continue
				}
			}
		}
		i++
	}

	return result
}
