# CheatModule Load Order

## Purpose of this file

To declare a standard load order for CheatModules (a.k.a. Addons)

## Reserved Load Order Slots

- 0-19:     Console Command Only modules
- 20-29:    Hotkey Only modules
- 30-49:    Root Menu modules
- 50-59:    Race Changer Support modules
- 60-69:    Toggle Cheats SubMenu modules

All other slots are free to use.

## Why did this happen?

After the Legacy Module was created, there was an unidentified issue when the module was not installed.
It took a while, but I finally tracked down the issue.

## What was the issue?

An index out of bounds error that RGSS doesn't seem to know how to classify.

## The cause?

Trying to insert a menu entry into a slot that was out of bounds. All affected modules have been fixed.

## How do I make my menu entries go to a specific index in the menu?

Short answer:   You don't.

Long answer:    This is now accomplished by choosing a position in the load order.
Depending on what a module adds to the Cheat Menu determines where in the load order the module should be.
If it covers multiple reserved slots, an unreserved slot should be used. If the load order position is already taken, conflicting positions will be sorted by filesystem order (as discovered)

## Addendum

With the new addition of TorD's Plugin Framework, this no longer applies.

However, while the new load order can be whatever the user wants, please try to keep to the Reserved Order. Anything not specified in the load order file will be sorted by filename below everything that is in the load order.

Adding to the load order is as simple as adding the basename of the CheatModule (term interchangable with addon, plugin, etc) to the list. e.g: If the Legacy Cheatmodule had been taken out so that it gets ordered by filename, bringing it back in is as simple as adding `"Legacy"` into the array.

To completely reset the load order to the defaults, ensure the game is not running and simply delete the `loadorder.json` file from the mod folder and launch the game to generate the default file.
