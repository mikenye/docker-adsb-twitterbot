# mikenye/adsb-twitterbot

An implementation of [shbisson/OverPutney](https://github.com/shbisson/OverPutney) running in Docker.

OverPutney is an ADS-B Twitter Bot. It tracks airplanes and then tweets whenever an airplane flies overhead. It is a fork of the original AboveTustin bot, adding support for Josh Douch's free ICAO lookup APIs. It also uses chromedriver for browser interactions rather than the deprecated PhantomJS webdriver.

## Environment Variables

An airplane is only tracked and tweeted when it enters the "alarm area". The alarm area is defined by the `ABOVETUSTIN_DISTANCE_ALARM` in miles, and the `ABOVETUSTIN_ELEVATION_ALARM` in degrees from the horizon. If any airplane travels closer than `ABOVETUSTIN_DISTANCE_ALARM` or higher than the `ABOVETUSTIN_ELEVATION_ALARM`, it will be tracked until it leaves the alarm area.  After `ABOVETUSTIN_WAIT_X_UPDATES` updates it will then make the tweet. It waits `ABOVETUSTIN_SLEEP_TIME` between each update.

| Environment Variable | Description | Default |
|-----|-----|-----|
| `TZ` | The timezone of the container (mainly for logging). Optional. | `UTC` |
| `TAR1090_URL` | The base URL to an instance of `tar1090`. Required. | - |
| `RECEIVER_LAT` | The latitude of the receiver. Required. | - |
| `RECEIVER_LONG` | The longitude of the receiver. Required. | - |
| `TAR1090_REQUEST_TIMEOUT` | tar1090 request timeout in seconds. Optional. | `60` |
| `ABOVETUSTIN_DISTANCE_ALARM` | See above. Optional. | `3` |
| `ABOVETUSTIN_ELEVATION_ALARM` | See above. Optional. | `60` |
| `ABOVETUSTIN_WAIT_X_UPDATES` | See above. Optional. | `3` |
| `ABOVETUSTIN_SLEEP_TIME` | See above. Optional. | `0.5` |
| `ABOVETUSTIN_IMAGE_WIDTH` | Width of image attached to tweet. Optional. | `1280` |
| `ABOVETUSTIN_IMAGE_HEIGHT` | Heiight of image attached to tweet. Optional. | `720` |
| `TWEET_TEMPLATE` | See below. Optional. | `#${flight} ${regis} ${plane} ${oper}: ${dist_mi} mi away @ ${alt_ft} ft and ${el}° frm hrzn, heading ${heading} @ ${speed_mph}mi/h ${time}.` |
| `FA_TWEET_TEMPLATE` | See below. Optional. | `#${flight} : #${orig_alt} (${orig_city}) to #${dest_alt} (${dest_city}). ${dist_mi} mi away @ ${alt_ft} ft and ${el}° frm hrzn, heading ${heading} @ ${speed_mph}mi/h ${time}.` |
| `TWEET_HASHTAGS` | Static hashtags attached to the tweet. Optional. | `#OverPutney #Putney #SW15 #ADSB #dump1090` |
| `TWITTER_CONSUMER_KEY` | Twitter API Consumer Key. Required. | - |
| `TWITTER_CONSUMER_SECRET` | Twitter API Consumer Secret. Required. | - |
| `TWITTER_ACCESS_TOKEN` | Twitter API Access Token. Required. | - |
| `TWITTER_ACCESS_TOKEN_SECRET` | Twitter API Access Token Secret. Required. | - |
| `FA_ENABLE` | Set to any value to enable FlightAware API. Optional. | - |
| `FA_USERNAME` | Set to your FlightAware username. Optional. | - |
| `FA_API_KEY` | Set to your FlightAware API key. Optional. | - |
| `CROP_DISABLE` | Set to any value to disable cropping. Optional. | - |
| `CROP_X` | Cropping X value. Optional. | - |
| `CROP_Y` | Cropping Y value. Optional. | - |
| `CROP_WIDTH` | Crop width. Optional. | - |
| `CROP_HEIGHT` | Crop height. Optional. | - |

`TWEET_TEMPLATE` is a template for the tweet.  Insert variables into the tweet by adding `${VAR_NAME}`. You may use the following variables:
| VAR NAME | DESCRIPTION |
|-----|-----|
| `flight`         | Flight name and number if available, otherwise it will be the ICAO code |
| `icao`           | ICAO code |
| `dist_mi`        | Minimum Distance in miles |
| `dist_km`        | Minimum Distance in kilometers |
| `dist_nm`        | Minimum Distance in nautical miles |
| `alt_ft`         | Altitude at the minimum distance in feet |
| `alt_m`          | Altitude at the minimum distance in meters |
| `el`             | Elevation angle at the minimum distance |
| `az`             | Azimuth angle at the minimum distance |
| `heading`        | Heading of aircraft at the minimum distance displayed as N, NW, W, SW, S, SE, E, or NE |
| `speed_mph`      | Speed of the aircraft at the minimum distance in mi/h |
| `speed_kmph`     | Speed of the aircraft at the minimum distance in km/h |
| `speed_kts`      | Speed of the aircraft at the minimum distance in knots |
| `time`           | Time when the aircraft is at the minimum distance |
| `rssi`           | Signal strength in dB at the minimum distance |
| `vert_rate_ftpm` | The vertical speed at the minimum distance in feet/minute |
| `vert_rate_mpm`  | The vertical speed at the minimum distance in meters/minute |
| `squawk`         | The squawk code of the aircraft |
| `orig_name`      | FlightAware API - name of origin airport |
| `orig_city`      | FlightAware API - name of origin city |
| `orig_alt`       | FlightAware API - origin airport IATA code (ICAO code if IATA not specified) |
| `orig_code`      | FlightAware API - origin airport ICAO code |
| `dest_name`      | FlightAware API - name of destination airport |
| `dest_city`      | FlightAware API - name of destination city |
| `dest_alt`       | FlightAware API - destination airport IATA code (ICAO code if IATA not specified) |
| `dest_code`      | FlightAware API - destination airport ICAO code |
| `plane`          | JoshDouch API - aircraft type |
| `regis`          | JoshDouch API - aircraft registration |
| `oper`           | JoshDouch API - aircraft operator |

`TWEET_TEMPLATE` will be used when Flightaware API is not enabled or no sufficent data has been received.
