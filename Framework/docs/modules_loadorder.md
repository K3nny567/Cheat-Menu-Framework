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
