# OSX

## google chrome

To start google chrome always in incognito mode, run

```
defaults write com.google.chrome IncognitoModeAvailability -integer 2
```

To make normal mode avaialble again, run

```
defaults write com.google.chrome IncognitoModeAvailability -integer 0
```