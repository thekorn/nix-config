## Fixes

- `Unable to boot the simulator` error: delete the xcode cache (Setting -> General -> Storage -> Developer -> Delete Xcode cache)

## install a manually downloaded simulator runtime

Download the simulator runtime from [Apple Developer](https://developer.apple.com/download/more/)

```bash
xcrun simctl runtime add "/tmp/iOS_17.4_Simulator_Runtime.dmg"
```
