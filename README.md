# blipsh

A lightweight, configurable shell UI (User Interface) that lets you run commands and shell aliases using a simple window instead of a terminal.  Think of it as a graphical shortcut launcher for your terminal commands. It is usefull if you have to launch a binary that you have on your PATH but dont have a .desktop that rofi can detect

## Installation

1.  You need the [V language](https://github.com/vlang/v) installed.  Follow the instructions on the V website to install it.
2.  Download the `uishell` code (Clone this repository).
3.  Download [Raylib](https://github.com/raysan5/raylib)
4.  Build the project  with this:
`
v install raylib
v . -prod -gc none
`

## Configuration

`blipsh` uses a TOML file for its settings.  TOML files are like simple text-based configuration files.  The program looks for this file in these places:

1.  `~/.config/uishell/blipsh.toml` (This is the best place to put it).
2.  `./blipsh.toml` (This means the same directory as the `blipsh` program).

If it can't find a configuration file, it uses some built-in default settings.

### Configuration Options

Here's what you can put in your `blipsh.toml` file. Those are the default settings:

```toml
[display]
width = 800    # How wide the window is (in pixels)
height = 600   # How tall the window is

[background]
color = "white"  # The background color (like "black", "white", "blue", etc.)

[text]
content = "enter text:"  # The text that appears above the input box
color = "darkgray" # The color of the prompt text
input_color = "darkgray" # The color of the text you type

[shell]
shell = "zsh"  # Which shell you use: "zsh", "bash", or "fish"
```

### Shell Configuration (Aliases)

`blipsh` can automatically use your shell aliases!  It figures out where your aliases are stored based on the `shell` setting in your `blipsh.toml` file:

**IMPORTANT:**  `blipsh` *only* reads lines that start with the word `alias`.

*   **It will understand this:**
    ```
    alias aa="long aa command"
    ```

*   **It will NOT understand this:**
    ```
    alias aa="long aa command" &&  alias aa2="long aa command number 2"
    alias \
    aa="long aa command"
    ```


Here's where it looks for aliases for each shell:

*   `zsh`:  Looks in `~/.zshrc` (The `~` means your home directory)
*   `bash`: Looks in `~/.bashrc`
*   `fish`: Looks in `~/.config/fish/config.fish`

If you don't specify a shell, `blipsh` assumes you're using `zsh`.

## Usage

1.  Run `blipsh`.
2.  You'll see a window with a text input box.
3.  Type a command or one of your aliases into the box.
4.  Press `Enter` to run the command. `blipsh` closes after you hit enter, but continues executing the comand in the background

Press `Escape` to close `blipsh` if you dont wanna execute anything.


## Example Configuration

Here's an example of a complete `blipsh.toml` file:

```toml
[display]
width = 1024
height = 768

[background]
color = "white"

[text]
content = "Command:"
color = "blue" # Prompt text in blue
input_color = "red" # User input text in red
[shell]
shell = "bash"
```

This will make the `blipsh` window 1024 pixels wide and 768 pixels tall, set the background to white, show "Command:" above the input box, and use your `bash` aliases from your `~/.bashrc` file.

### Supported Colors

Here's the list of color supported for bpth background and text:

*   `lightgray`
*   `gray`
*   `darkgray`
*   `yellow`
*   `gold`
*   `orange`
*   `pink`
*   `red`
*   `maroon`
*   `green`
*   `lime`
*   `darkgreen`
*   `skyblue`
*   `blue`
*   `darkblue`
*   `purple`
*   `violet`
*   `darkpurple`
*   `beige`
*   `brown`
*   `darkbrown`
*   `white`
*   `black`
*   `blank`
*   `magenta`
*   `raywhite`

## Troubleshooting

*   If `blipsh` can't read your `blipsh.toml` file, it will show an error message in the terminal and use its default settings.
*   If you don't tell it which shell to use, it will assume `zsh`.
*   Make sure your shell configuration file (like `.bashrc` or `.zshrc`) exists and that your aliases are written correctly (starting with the word `alias`).

Uishell is basically a replacement to this rofi command i used before creating this:
```sh
rofi -dmenu -p "Enter command:" -theme-str 'entry { placeholder: "Type command here..."; }' | zsh
```
But it didnt used aliases.

## Todo


- [ ] Support for sourcing (including other file in shell config)
- [x] Parse aliases
- [ ] Parse function
- [ ] Tab (autocomplete)
- [ ] History
- [ ] Customizable fonts
- [x] Customizable colors
- [ ] Add possibility of using a pic as background


If you want another feature, or support for another shell, feel free to open an issue.

If you have a better name for this im all ears
