SCRIPT_DIRNAME=$(shell cd "$(shell dirname "${BASH_SOURCE[0]}" )" && pwd )
DATE=$(shell date +%I:%M%p)
CHECK=\033[32m✔\033[39m
HR=\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#

#
# SETUP IOS-BROWSER
#

setup:
	rm -rf cordova-ios && git clone git://github.com/apache/cordova-ios.git && cd cordova-ios && git checkout tags/2.5.0 && cd ..
	rm -rf ios-sim && git clone git://github.com/phonegap/ios-sim.git && cd ios-sim && git checkout tags/1.6 && rake build && cd ..

#
# BUILD IOS-BROWSER
#

build:
	@echo "\n${HR}"
	@echo "Building Browser..."
	@echo "${HR}\n"
	rm -rf browser
	cordova-ios/bin/create --shared browser org.apache.cordova.Browser Browser
	cp -rf src/* browser/Browser
	browser/cordova/build > /dev/null
	@echo "Successfully built at ${DATE}...       ${CHECK} Done"

#
# RUN DEMO TESTS IN IOS-BROWSER
#

test:
	@killall "iPhone Simulator" > /dev/null 2>&1; echo;
	"ios-sim/build/Release/ios-sim" launch "browser/build/Browser.app" --args spec.html

#
# CLEANS THE ROOT DIRECTORY OF PRIOR BUILDS
#

clean:
	rm -rf browser
