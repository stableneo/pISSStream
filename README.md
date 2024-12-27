# pISSStream

pISSStream is a macOS menu bar app that shows how full the International Space Station's urine tank is in real time:

![](https://panthercap.us-east.host.bsky.network/xrpc/com.atproto.sync.getBlob?did=did%3Aplc%3Acl3kuq4sxg3jpfjtom4gnamx&cid=bafkreidthbrhc7pjez4g445dpontwyefusimny45kja57twy2obshwtsn4)

[Download](https://github.com/Jaennaet/pISSStream/releases/download/v0.2/pISSStream.0.2.dmg) yours while supplies last!

Uses NASA's official public ISS telemetry stream, provided by [Lightstreamer](https://lightstreamer.com/).

## Usage

When pISSStream can connect to Lightstreamer and the ISS telemetry signal is being received by the ground station, the menu bar item shows 🧑🏽‍🚀🚽 alongside  the fill percentage, and the menu simply reads "Connected"

![](https://panthercap.us-east.host.bsky.network/xrpc/com.atproto.sync.getBlob?did=did%3Aplc%3Acl3kuq4sxg3jpfjtom4gnamx&cid=bafkreiaykjgxzlvaf5jjp66uobqlapqcsb2zg7vobs2b47bwf54xnisgma)

If either the connection to Lightstreamer or the ISS telemetry signal itself is lost, the menu bar item shows 🧑🏽‍🚀❗and the last received value if any, and the menu reads either "Connection Lost" or "Signal Lost (LOS)":

![](https://panthercap.us-east.host.bsky.network/xrpc/com.atproto.sync.getBlob?did=did%3Aplc%3Acl3kuq4sxg3jpfjtom4gnamx&cid=bafkreighfm74uy74zcz4pxk2rw4p5b2ts4tezebtkbyyocngqmyiyvenam)

## But why?

For some inexplicable reason people keep asking me why I ([@Jaennaet](https://github.com/Jaennaet)) did this.

My motivation was entirely that I thought this was both a hilariously stupid use of a space station's telemetry stream, but also kind of amazing at the same time. It's remarkable that we live in a world where it takes an afternoon to bang out a joke application that reads actual realtime telemetry data from a space station's toilets. 

Also a great excuse to learn Swift, but the sheer ridiculousness was what drove me.

## Bugs

Yeah, probably?

At the very least:

- shrugs at stale data
- not overly bothered with error handling

## Errata

[@Jaennaet](https://github.com/Jaennaet) found out about the data stream from https://iss-mimic.github.io/Mimic/, which has considerably more and more interesting stats than just how full the piss tank is. 

We will not be adding any of them.

## Contributors

- [@Jaennaet](https://github.com/Jaennaet): initial idea and first version
- [@durul](https://github.com/durul): code quality, LOS handling, iOS & visionOS versions