
module main

import raylib as r
import os
import parser as p

const config_path = if os.exists('${os.getenv('HOME')}/.config/blipsh/blipsh.toml') {
	'${os.getenv('HOME')}/.config/blipsh/blipsh.toml'
} else {
	'./blipsh.toml'
}

fn main() {
	config := if os.exists(config_path) {
		p.init_config(config_path) or {
			// default config on error
			println('Error parsing config: ${err}')
			p.Config{'black', 'enter text:', 'darkgrey', 800, 600, none, 'darkgray'}
		}
	} else {
		// default config on not found
		println('Error: Config not found')
		p.Config{'black', 'enter text:', 'darkgrey', 800, 600, none, 'darkgray'}
	}
	shell_profile := if config.shell_path == none {
		eprintln('Error: no shell provided. Defaulting to zsh')
		'${os.getenv('HOME')}/.zshrc'
	} else {
		'${config.shell_path?}'
	}
	println('${shell_profile}')

	aliases := p.parse_shell_aliases(shell_profile)
	// println('Parsed aliases: ${aliases}')
	println('config: ${config}')

	text_color := get_color_from_config(config.text_color)
	input_text_color := get_color_from_config(config.input_text_color)
	println('Color: ${config.background_color}')
	background_color := get_color_from_config(config.background_color)
	println('received COLOR:	${background_color}')
	r.init_window(config.width, config.height, 'uishell')
	r.set_exit_key(int(r.KeyboardKey.key_escape))
	r.set_target_fps(60)

	// storing user input
	mut input_text := ''

	for !r.window_should_close() {
		for {
			c := r.get_char_pressed()
			if c == 0 {
				break
			}
			// Only process printable ASCII characters (from space to ~)
			if c >= 32 && c <= 126 {
				input_text += get_key_from_ascii(c)
			}
		}

		if r.is_key_pressed(int(r.KeyboardKey.key_backspace)) {
			if input_text.len > 0 {
				input_text = input_text[..input_text.len - 1]
			}
		} else if r.is_key_pressed(int(r.KeyboardKey.key_enter)) {
			if input_text in aliases {
				println('Executing alias: ${aliases[input_text]}')

				spawn os.execute(aliases[input_text].trim('"'))
			} else {
				println('executing: ${input_text}')

				spawn os.execute(input_text)
			}
			r.close_window()
			exit(0)
			break
		}

		// Drawing
		r.begin_drawing()
		r.clear_background(background_color)
		r.draw_text(config.text, 10, 10, 20, text_color)
		r.draw_text(input_text, 10, 40, 20, input_text_color)
		r.end_drawing()
	}

	r.close_window()
}

fn get_color_from_config(color string) r.Color {
	println('received ${color}')
	return match color {
		'darkgray' { r.darkgray }
		'gray' { r.gray }
		'lightgray' { r.lightgray }
		'yellow' { r.yellow }
		'gold' { r.gold }
		'orange' { r.orange }
		'pink' { r.pink }
		'red' { r.red }
		'maroon' { r.maroon }
		'green' { r.green }
		'lime' { r.lime }
		'darkgreen' { r.darkgreen }
		'skyblue' { r.skyblue }
		'blue' { r.blue }
		'darkblue' { r.darkblue }
		'beige' { r.beige }
		'brown' { r.brown }
		'darkbrown' { r.darkbrown }
		'white' { r.white }
		'black' { r.black }
		'blank' { r.blank }
		'magenta' { r.magenta }
		'raywhite' { r.raywhite }
		else { r.darkgray }
	}
}

fn get_key_from_ascii(key int) string {
	return match key {
		32 { ' ' }
		33 { '!' }
		34 { '"' }
		35 { '#' }
		36 { '$' }
		37 { '%' }
		38 { '&' }
		39 { "'" }
		40 { '(' }
		41 { ')' }
		42 { '*' }
		43 { '+' }
		44 { ',' }
		45 { '-' }
		46 { '.' }
		47 { '/' }
		48 { '0' }
		49 { '1' }
		50 { '2' }
		51 { '3' }
		52 { '4' }
		53 { '5' }
		54 { '6' }
		55 { '7' }
		56 { '8' }
		57 { '9' }
		58 { ':' }
		59 { ';' }
		60 { '<' }
		61 { '=' }
		62 { '>' }
		63 { '?' }
		64 { '@' }
		65 { 'A' }
		66 { 'B' }
		67 { 'C' }
		68 { 'D' }
		69 { 'E' }
		70 { 'F' }
		71 { 'G' }
		72 { 'H' }
		73 { 'I' }
		74 { 'J' }
		75 { 'K' }
		76 { 'L' }
		77 { 'M' }
		78 { 'N' }
		79 { 'O' }
		80 { 'P' }
		81 { 'Q' }
		82 { 'R' }
		83 { 'S' }
		84 { 'T' }
		85 { 'U' }
		86 { 'V' }
		87 { 'W' }
		88 { 'X' }
		89 { 'Y' }
		90 { 'Z' }
		91 { '[' }
		92 { '\\' }
		93 { ']' }
		94 { '^' }
		95 { '_' }
		96 { '`' }
		97 { 'a' }
		98 { 'b' }
		99 { 'c' }
		100 { 'd' }
		101 { 'e' }
		102 { 'f' }
		103 { 'g' }
		104 { 'h' }
		105 { 'i' }
		106 { 'j' }
		107 { 'k' }
		108 { 'l' }
		109 { 'm' }
		110 { 'n' }
		111 { 'o' }
		112 { 'p' }
		113 { 'q' }
		114 { 'r' }
		115 { 's' }
		116 { 't' }
		117 { 'u' }
		118 { 'v' }
		119 { 'w' }
		120 { 'x' }
		121 { 'y' }
		122 { 'z' }
		123 { '{' }
		124 { '|' }
		125 { '}' }
		126 { '~' }
		else { '' }
	}
}
