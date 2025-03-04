
module main

import raylib as r
import os
import parser as p

const config_path = if os.exists('${os.getenv('HOME')}/.config/uishell/uish.conf') {
	'${os.getenv('HOME')}/.config/uishell/uish.conf'
} else {
	'./uish.conf'
}

fn main() {
	zsh_profile := '${os.getenv('HOME')}/.zshrc'
	println('${zsh_profile}')
	aliases := go p.parse_shell_aliases(zsh_profile)
	// println('Parsed aliases: ${aliases}')
	// Set window dimensions (you can also use r.get_screen_width()/r.get_screen_height() if preferred)
	config := if os.exists(config_path) {
		p.init_config(config_path)
	} else {
		p.Config{'black', 'enter text:', 800, 600}
	}
	r.init_window(config.width, config.height, config.text)
	r.set_exit_key(int(r.KeyboardKey.key_escape))
	r.set_target_fps(60)

	// This variable will store the user's input
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

		// Process backspace key to remove the last character if pressed
		if r.is_key_pressed(int(r.KeyboardKey.key_backspace)) {
			if input_text.len > 0 {
				input_text = input_text[..input_text.len - 1]
			}
		} else if r.is_key_pressed(int(r.KeyboardKey.key_enter)) {
			if input_text in aliases.wait() {
				to_execute := aliases.wait()
				os.execute(to_execute[input_text])
			} else {
				os.execute(input_text)
			}

			input_text = ''
		}

		// Drawing
		r.begin_drawing()
		r.clear_background(r.blue)
		r.draw_text('Type something:', 10, 10, 20, r.darkgray)
		r.draw_text(input_text, 10, 40, 20, r.black)
		r.end_drawing()
	}

	r.close_window()
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
