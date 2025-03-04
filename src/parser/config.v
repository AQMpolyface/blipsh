module parser

import os
import strconv

pub struct Config {
pub mut:
	background_type BackgroundType
	background      string
	text            string
	width           int
	height          int
}

pub enum BackgroundType {
	color
	picture
}

pub fn init_config(path string) !Config {
	config_content := os.read_lines(path) or { return error('Error reading config file: ${err}') }
	mut config_struct := Config{}
	for line in config_content {
		line_splitted := line.split('=')
		// ignoring badly written lines
		if line_splitted.len < 2 {
			continue
		}
		match line_splitted[0].trim(' ') {
			'background-type' {
				match line_splitted[1] {
					'color' {
						config_struct.background_type = BackgroundType.color
					}
					'picture' {
						config_struct.background_type = BackgroundType.picture
					}
					else {
						// default value on error
						return error('Error parsing config: Unkown background type: ${line_splitted}')
					}
				}
			}
			'background' {
				config_struct.background = line_splitted[1]
			}
			'text' {
				config_struct.text = line_splitted[1]
			}
			'width' {
				config_struct.width = strconv.atoi(line_splitted[1]) or { 800 }
			}
			'height' {
				config_struct.height = strconv.atoi(line_splitted[1]) or { 600 }
			}
			else {
				eprintln('Error parsing config: Unkown type: ${line_splitted.join('')}')
				return error('Error parsing config: Unkown type: ${line_splitted}')
			}
		}
	}

	return config_struct
}
