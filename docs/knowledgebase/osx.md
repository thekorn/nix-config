# OSX

## google chrome

To start google chrome always in incognito mode, run

```
defaults write com.google.chrome IncognitoModeAvailability -integer 2
```

To make normal mode available again, run

```
defaults write com.google.chrome IncognitoModeAvailability -integer 0
```
