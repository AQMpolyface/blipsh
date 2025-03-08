module parser

import os
import toml

pub struct Config {
pub mut:
	// background_type BackgroundType
	background_color string
	text             string
	text_color       string
	width            int
	height           int
	shell_path       string
	input_text_color string
	font             string
}

/*
//if i find a way to add pics maybe usefull
pub enum BackgroundType {
	color
	picture
}*/

pub fn init_config(path string) !Config {
	home_path := os.getenv('HOME')
	config_content := toml.parse_file(path) or { return error('Error reading config file: ${err}') }
	mut config_struct := Config{}

	config_struct.height = config_content.value('display.height').default_to(600).int()
	config_struct.width = config_content.value('display.width').default_to(800).int()

	config_struct.background_color = config_content.value('background.color').default_to('black').string()

	config_struct.text = config_content.value('text.content').default_to('Enter command here:').string()
	config_struct.text_color = config_content.value('text.color').default_to('darkgrey').string()
	config_struct.input_text_color = config_content.value('text.input_text_color').default_to('darkgrey').string()
	config_struct.font = config_content.value('text.font').default_to('').string()

	// TODO fix custom path
	shell := config_content.value('shell.name').string()
	shell_path := config_content.value('shell.path').default_to('${home_path}/.zshrc').string()

	if shell_path != 'n' {
		config_struct.shell_path = get_shell_path(shell, home_path)
	} else {
		config_struct.shell_path = shell_path
	}
	return config_struct
}

fn get_shell_path(shell string, home_path string) string {
	return match shell {
		'zsh' {
			'${home_path}/.zshrc'
		}
		'bash' {
			'${home_path}/.bashrc'
		}
		'fish' {
			'${home_path}/.config/fish/config'
		}
		else {
			// defaulting to zsh
			'${home_path}/.zshrc'
		}
	}
}
