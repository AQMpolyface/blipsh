# uishell

A lightweight, configurable shell UI (User Interface) that lets you run commands and shell aliases using a simple window instead of a terminal.  Think of it as a graphical shortcut launcher for your terminal commands.

## Installation

1.  You need the [V language](https://github.com/vlang/v) installed.  Follow the instructions on the V website to install it.
2.  Download the `uishell` code (Clone this repository).
3.  Build the project  with this (for better perf):  `v . -prod -gc none`

## Configuration

`uishell` uses a TOML file for its settings.  TOML files are like simple text-based configuration files.  The program looks for this file in these places:

1.  `~/.config/uishell/uish.toml` (This is the best place to put it).
2.  `./uish.toml` (This means the same directory as the `uishell` program).

If it can't find a configuration file, it uses some built-in default settings.

### Configuration Options

Here's what you can put in your `uish.toml` file. Those are the default settings:

```toml
[display]
width = 800    # How wide the window is (in pixels)
height = 600   # How tall the window is

[background]
color = "white"  # The background color (like "black", "white", "blue", etc.)

[text]
content = "enter text:"  # The text that appears above the input box

[shell]
shell = "zsh"  # Which shell you use: "zsh", "bash", or "fish"
```

### Shell Configuration (Aliases)

`uishell` can automatically use your shell aliases!  It figures out where your aliases are stored based on the `shell` setting in your `uish.toml` file:

**IMPORTANT:**  `uishell` *only* reads lines that start with the word `alias`.

*   **It will understand this:**
    ```
    alias aa="long aa command"
    ```

*   **It will NOT understand this:**
    ```
    alias aa="long aa command" &&  alias aanumber2="long aa command number 2"
    alias \
    aa="long aa command"
    ```


Here's where it looks for aliases for each shell:

*   `zsh`:  Looks in `~/.zshrc` (The `~` means your home directory)
*   `bash`: Looks in `~/.bashrc`
*   `fish`: Looks in `~/.config/fish/config.fish`

If you don't specify a shell, `uishell` assumes you're using `zsh`.

## Usage

1.  Run `uishell`.
2.  You'll see a window with a text input box.
3.  Type a command or one of your aliases into the box.
4.  Press `Enter` to run the command.
5.  Press `Escape` to close `uishell`.


## Example Configuration

Here's an example of a complete `uish.toml` file:

```toml
[display]
width = 1024
height = 768

[background]
color = "white"

[text]
content = "Command:"

[shell]
shell = "bash"
```

This will make the `uishell` window 1024 pixels wide and 768 pixels tall, set the background to white, show "Command:" above the input box, and use your `bash` aliases from your `~/.bashrc` file.

## Troubleshooting

*   If `uishell` can't read your `uish.toml` file, it will show an error message in the terminal and use its default settings.
*   If you don't tell it which shell to use, it will assume `zsh`.
*   Make sure your shell configuration file (like `.bashrc` or `.zshrc`) exists and that your aliases are written correctly (starting with the word `alias`).

Uishell is basically a replacement to this rofi command i used before creating this:
```sh
rofi -dmenu -p "Enter command:" -theme-str 'entry { placeholder: "Type command here..."; }' | zsh
```
But it didnt used aliases.

## Todo

- [ ] Tab (autocomplete)
- [ ] History
- [ ] Customizable color
- [ ] Add possibility of pic as background



If you want another featur, or support for another shell, feel free to open an issue
