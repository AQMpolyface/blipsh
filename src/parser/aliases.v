module parser

import os

pub fn parse_shell_aliases(path string) map[string]string {
	lines := os.read_lines(path) or { panic('Error reading ${path}: ${err}') }
	mut alias_map := map[string]string{}
	for line in lines {
		if line.starts_with('alias') {
			alias_name, alias_command := line.split_once('=') or { continue }
			alias_map[alias_name['alias '.len..]] = alias_command
		} else {
			continue
		}
	}

	return alias_map
}
