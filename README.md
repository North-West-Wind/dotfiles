# HyprSquid!
My colorful dotfiles for Hyprland  
![](https://lemmy.world/pictrs/image/42b95fda-d3b2-4f10-8e11-bfa9b256f38b.png?format=webp)

## Usage
1. `git clone` this repository
2. Install all dependencies in `PKGBUILD`
	- You can run `makepkg -si`
	- If you are not using an Arch-based distro, just install everything under `depends` and `optdepends` in `PKGBUILD`
3. Create all symbolic links
	- `hypr/` -> `~/.config/hypr/`
	- `waybar/` -> `~/.config/waybar`