Browser Detector
================

Doens't have any dependencies, really simple to use.
Just include the script in your page and create a Detector instance

### Examples
	detector = new Detector();

	detector.browser.isFirefox
	detector.browser.isChrome
	// and so on
	detector.browser.version

Options
=======

	{
		addClass: true, // will add classes to html
		identify: {
			browser: true, // will identify the browser
			engine: true, // will identify the browser engine
			os: true // will identify the os
		}
	}

How can I know the classes?
===========================

You can look at the code it's really simple to understand.
if no key htmlClass is found inside the item object, then it will use the object key.
Of course you can set or extend to use your own classes.
Isn't nice?


Do you have tested this entire list?
====================================
Nope! I've tested just the following:

Systems: windows / linux
Browsers: chrome, firefox, ie7+ (win), safari (win)

So how you know this will work? Well, I have researched on internet how to detect browsers and others and tested with user agents I found.
But again, if I not tested, I can't guarantee. But you can help this testing and saying it works or submiting a pull request with bugfix :)