# qmk Firmware

## prerequists

See [setup instructions](https://docs.qmk.fm/#/newbs_getting_started?id=setting-up-your-qmk-environment)

Those packages needs to be installed:

```
  $ sudo apt install -y \
        git \
        python3-pip \
        gcc-arm-none-eabi \
        arduino \
        dfu-programmer \
        dfu-util
```

Install the `qmk` tool for the current user

```
  $ python3 -m pip install --user qmk
```

## setup qmk

Run

```
  $ qmk setup
```

and fix all issues

## build and install firmware

### gmmk pro

```
  $ qmk compile -kb gmmk/pro/rev1/ansi -km andrebrait
``` 

Then, install, and set the keyboard in boot mode (`FN + \`)

```
  $ qmk flash -kb gmmk/pro/rev1/ansi -km andrebrait
```

### gmmk2

```
  $ qmk compile -kb gmmk/gmmk2/p65/ansi -km thekorn
``` 

Then, install, and set the keyboard in boot mode (`FN + <space>`)

```
  $ qmk flash -kb gmmk/gmmk2/p65/ansi -km thekorn
```