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