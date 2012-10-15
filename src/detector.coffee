capitalizeString = (str) ->
	str.replace( /\b[a-z]/g, (match) -> match.toUpperCase() )

mergeObjects = (def, object) ->

	if typeof object is 'undefined'
		return def
	else if typeof def is 'undefined'
		return object;

	for key, value of object
		if value isnt null and value.constructor == Object
			def[ key ] = mergeObjects def[ key ], value
		else
			def[ key ] = value;

	return def

class Detector

	constructor: (options) ->
		@options = Detector.options;
		mergeObjects(@options, options);

		if @options.identify.browser then @identify 'browser', Detector.browsersList
			
		if @options.identify.engine then @identify 'engine', Detector.engineList
			
		if @options.identify.os then @identify 'os', Detector.osList

	identify: (internalVar, list) ->
		this[ internalVar ] = {}
		alreadyGotMatch = no

		for key, item of list
			property 		= item.property
			propertyLookup	= item.propertyLookup
			htmlClass 		= if item.htmlClass? then item.htmlClass else key
			versionLookup 	= item.versionLookup

			matched = no

			if not alreadyGotMatch

				try
					if typeof propertyLookup is 'function'
						matched = propertyLookup.call item
					else
						matched = property.indexOf(propertyLookup) > -1

					if matched and !!versionLookup
						@identifyVersion internalVar, versionLookup

				catch ex # happen using ie9
					matched = no

			this[ internalVar ][ 'is' + capitalizeString(key) ] = matched

			if matched
				alreadyGotMatch = yes

				if @options.addClass then @addClassToHtml htmlClass

	identifyVersion: (internalVar, versionLookup) ->
		searcheable = if navigator.userAgent.indexOf(versionLookup) > -1 then navigator.userAgent else navigator.appVersion
		index = searcheable.indexOf versionLookup
		
		if index > -1
			this[ internalVar ][ 'version' ] = parseInt( (searcheable.substring(index + versionLookup.length + 1)) )

			if @options.addClass
				@addClassToHtml "#{internalVar}-v#{this[internalVar]["version"]}"
		else
			this[ internalVar ][ 'version' ] = null

	addClassToHtml: (classname) ->
		if !!classname
			document.documentElement.className += " #{classname}";

Detector.options =
	addClass: yes
	identify: 
		browser: yes
		engine: yes
		os: yes

Detector.browsersList =

	chrome:
		property: navigator.userAgent
		propertyLookup: 'Chrome'
		versionLookup: 'Chrome'

	safari:
		property: navigator.vendor
		propertyLookup: 'Apple'
		versionLookup: 'Version'
	
	opera:
		property: window.opera
		propertyLookup: () -> !!@property
		versionLookup: 'Opera'
	
	konqueror:
		property: navigator.vendor
		propertyLookup: 'KDE'
		versionLookup: 'Konqueror'
	
	firefox:
		property: navigator.userAgent
		propertyLookup: 'Firefox'
		versionLookup: 'Firefox'
	
	ie:
		property: navigator.userAgent
		propertyLookup: 'MSIE'
		versionLookup: 'MSIE'
	
	mozilla:
		property: navigator.userAgent
		propertyLookup: 'Gecko'
		versionLookup: 'rv'
	
	netscape:
		property: navigator.userAgent
		propertyLookup: 'Mozilla'
		versionLookup: 'Mozilla'

Detector.osList =
	# mobile
	winCE:
		property: navigator.appVersion,
		propertyLookup: 'Windows CE',
		htmlClass: 'mobile winCE'
	
	iphone:
		property: navigator.userAgent
		propertyLookup: 'iPhone'
		htmlClass: 'mobile iphone ios'
	
	ipod:
		property: navigator.userAgent
		propertyLookup: 'iPod'
		htmlClass: 'mobile ipod ios'
	
	ipad:
		property: navigator.userAgent
		propertyLookup: 'iPad'
		htmlClass: 'mobile ipad ios'
	
	android:
		property: navigator.userAgent
		propertyLookup: 'Android'
		htmlClass: 'mobile android'
	
	winMobile:
		property: navigator.userAgent
		propertyLookup: 'IEMobile'
		htmlClass: 'mobile wp'
	
	blackberry:
		property: navigator.userAgent
		propertyLookup: 'Blackberry'
		htmlClass: 'mobile blackberry'
	
	# system
	win:
		property: navigator.platform
		propertyLookup: () -> @property.indexOf('Win') is 0;

	mac:
		property: navigator.platform
		propertyLookup: () -> @property.indexOf('Mac') is 0;
	
	linux:
		property: navigator.platform
		propertyLookup: () -> (@property == 'X11') or (@property.indexOf('Linux') is 0);
		
	# video games
	wii:
		property: navigator.userAgent
		propertyLookup: 'Wii'
		htmlClass: 'vg wii'
	
	playstation:
		property: navigator.userAgent
		propertyLookup: () -> /playstation/i.test(@property)
		htmlClass: 'vg playstation'

Detector.engineList =
	
	webkit:
		property: navigator.userAgent
		propertyLookup: 'AppleWebKit'
	
	trident:
		property: navigator.userAgent
		propertyLookup: 'Trident'
	
	khtml:
		property: navigator.userAgent
		propertyLookup: () -> (@property.indexOf('KHTML') > -1 or @property.indexOf('Konqueror') > -1)
	
	gecko:
		property: navigator.userAgent
		propertyLookup: 'Gecko'

	opera:
		property: window.opera
		propertyLookup: () -> !!@property

this.Detector = Detector