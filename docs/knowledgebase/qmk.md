# qmk Firmware

## prerequists

In order to install the qmk tool and build dependencies, make sure to add the `./home/shared/qmk.nix` file to your home-manager configuration.

```nix
  imports = [
    ./home/shared/qmk.nix
  ];
```

## setup qmk

Run

```
  $ qmk setup -H ~/devel/github.com/qmk/qmk_firmware -y
```

in order to verify the setup, run

```
  $ qmk doctor
```

## build and install firmware

### gmmk pro

```
  $ qmk compile keyboards/gmmk_pro_rev1_ansi_thekorn.json
```

Then, install, and set the keyboard in boot mode (`FN + \`)

```
$ qmk flash ~/devel/github.com/qmk/qmk_firmware/gmmk_pro_rev1_ansi_gmmk_pro_rev1_ansi_thekorn.bin
```

### gmmk2

```
  $ qmk compile keyboards/gmmk_gmmk2_p65_ansi_thekorn-qmmk2.json
```

Then, install, and set the keyboard in boot mode (`FN + <space>`)

```
  $ qmk flash ~/devel/github.com/qmk/qmk_firmware/gmmk_gmmk2_p65_ansi_gmmk_gmmk2_p65_ansi_thekorn-qmmk2.bin
```
