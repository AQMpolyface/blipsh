module utils

pub fn merge_maps(ali_map map[string]string, func_map map[string][]string, new_ali_map map[string]string, new_func_map map[string][]string) (map[string]string, map[string][]string) {
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
