# archivemount.yazi

Mounting and unmounting archives in yazi in Linux using `archivemount` command. You can now temporarily view and edit files inside your archive creating a new archive along with original, all using the
features of `archivemount`. You can also view mounpoints in your system based on the list provided by command `mount` on Linux.

## Previews/Screenshots

[archivemount_p1.webm](https://github.com/user-attachments/assets/f5f8810b-cfbb-4054-b7c2-fa77ed4fc22c)

## Requirements

> [!Note]
>
> Currently, it works on Linux. Help wanted for MacOS!

1. [archivemount](https://github.com/cybernoid/archivemount)

You can download the command using `sudo apt install archivemount` or build from source from their github repository.

2. [Yazi](https://github.com/sxyazi/yazi) version >= 0.4.x

## Installation

To install `archivemount.yazi` in Linux, you can run the below command -

```bash
ya pkg add AnirudhG07/archivemount
# OR
git clone https://github.com/AnirudhG07/archivemount.yazi ~/.config/yazi/plugins/archivemount.yazi
```

## Usages

To use the UI extension of `archivemount.yazi`, add the following in your `~/.config/yazi/main.lua` -

```lua
require("archivemount"):setup()
```

Add the following to your `keymaps.toml`.

```toml
[[mgr.prepend_keymap]]
on   = [ "m", "a" ]
run  = "plugin archivemount mount"
desc = "Mount selected archive"

[[mgr.prepend_keymap]]
on   = [ "m", "u" ]
run  = "plugin archivemount unmount"
desc = "Unmount and save changes to original archive"
```

## Which Archive files can you use?

Check out the Man page for `archivemount` for more information. `archivemount.yazi` supports `.tar`, `.tar.gz`, `tgz`, `tar.bz2` and `.zip`(The new file is a `.tar` file instead of `.zip` because `archivemount` command converts it so). If you think more compressions types
can be added, feel free to add it in your `main.lua` and make an issue/PR regarding it as well!:

## Explore Yazi

Yazi is an amazing, blazing fast terminal file mgr, with a variety of plugins, flavors and themes. Check them out at [awesome-yazi](https://github.com/AnirudhG07/awesome-yazi) and the official [yazi webpage](https://yazi-rs.github.io/).

## MacOS

> [!Important]
>
> This is not tested by me. Only an inspiration by people.
> For any users, please test and provide feedback for the same.

You can install `archivemount` on MacOS through `macports`, it is available on Homebrew only on Linux(linuxbrew) -

```
sudo port install archivemount
```

Application on MacOS which uses MacFuse for archivemounting. You would need to enable MacFuse for this. The syntax provided by archivemount is same as that of linux, so the plugin should work.
