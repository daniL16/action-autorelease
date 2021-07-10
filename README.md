# action-autorelease

### Example

```

name: Autorelease

on:
  schedule:
    - cron:  '10 * * * *'
  pull_request:
jobs:
  generate_release:
     runs-on: ubuntu-latest
     name: Generate Release
     steps:
       - uses: actions/checkout@master
       - uses: daniL16/action-autorelease@master
         with:
           GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
           
```
