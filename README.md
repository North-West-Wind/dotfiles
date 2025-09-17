# Niri Laptop!
My colorful dotfiles for Niri  
![](/preview.png)  
![](/preview.gif)

## Usage
1. `git clone` this repository
2. Install all dependencies in `PKGBUILD`
	- You can run `makepkg -si`
	- If you are not using an Arch-based distro, just install everything under `depends` and `optdepends` in `PKGBUILD`
3. Create all symbolic links
	- `mako/` -> `~/.config/mako/`
	- `niri/` -> `~/.config/niri/`
	- `waybar/` -> `~/.config/waybar/`
4. Copy some more files
	- `additional/niri-portals.conf` -> `~/.config/xdg-desktop-portal/`
5. Install funny fonts. Mainly used for `mako` notifications and `hyprlock` for lock screen
	- [`Mario64`](https://fontmeme.com/fonts/mario-64-font/): Font from Super Mario 64
	- [`UnifontMonoEx`](https://www.dafont.com/unifontexmono.font): Fallback for characters not in `Mario64`
	- [`New Super Mario Font U`](https://fontmeme.com/fonts/new-super-mario-font-u-font/): Font from New Soup U for the lock screen