module parser


pub type Config = struct {
	pub
	background string
	text       string
	width      i32
	height     i32
}

pub fn init_config(path string) Config {
	config_content := os.read_lines(path)
}
