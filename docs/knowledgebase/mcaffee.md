# McAfee anti malware

## turn off

### method 1
```bash
sudo /usr/local/McAfee/AntiMalware/VSControl stopoas
```

### alternatively
```bash
sudo defaults write /Library/Preferences/com.mcafee.ssm.antimalware.plist OAS_Enable -bool False
sudo /usr/local/McAfee/AntiMalware/VSControl stop
sudo /usr/local/McAfee/AntiMalware/VSControl reload
```

Or completely uninstall:
```bash
sudo -s
cd /usr/local/McAfee/
./uninstall EPM
 ```
