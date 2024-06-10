# Sticks Keypad

A simple script to have a keypad inside of your city.

## Installation

1. Download the latest version of the script using the "Download ZIP" button on the right side of this page.
2. Extract the ZIP file.
3. Rename the folder to `sticks-keypad` and copy it to your `resources` directory.
4. Add `ensure sticks-keypad` to your `server.cfg`.
5. All done, start your server and enjoy!

## Configuration

You can configure the script in the `server/server.lua` file. To add a new entry, you need the door ID, the cords of the door, the teleport cords, and the password. An example is already in the file to help you understand how to add a new entry, and can also be seen below.

```lua
-- Example
{1, {x = -3029.3825683594, y = 72.813552856445, z = 11.4}, {x = -3031.3232421875, y = 93.021644592285, z = 12.346099853516}, "1234"},
```

## Credits

This script used a boilerplate from [NPWD](https://github.com/project-error/fivem-react-boilerplate-lua). Thank you for the boilerplate!
