# Ontario COVID-19 Result Checking Script

A more automated way of checking your COVID-19 results at https://covid19results.ehealthontario.ca:4443/

Tired of filling out the results form every time you want to check? Now you can "refresh" to your
heart's content.

## Dependencies

- Ruby
- selenium-webdriver Ruby gem
- Google Chrome
- chromedriver package

## Usage

Fill out your health card information in `example.json` and run the script:

```
./check.rb example.json
```

A Chrome browser window will open, have your information filled out and
submitted to view results.


