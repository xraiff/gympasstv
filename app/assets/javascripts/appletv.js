//# sourceURL=application.js

/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information

 Abstract:
 This is the entry point to the application and handles the initial loading of required JavaScript files.
 */

var resourceLoader;

/**
 * @description The onLaunch callback is invoked after the application JavaScript
 * has been parsed into a JavaScript context. The handler is passed an object
 * that contains options passed in for launch. These options are defined in the
 * swift or objective-c client code. Options can be used to communicate to
 * your JavaScript code that data and as well as state information, like if the
 * the app is being launched in the background.
 *
 * The location attribute is automatically added to the object and represents
 * the URL that was used to retrieve the application JavaScript.
 */
App.onLaunch = function(options) {
  resourceLoader = new ResourceLoader(options.BASEURL);

  var index = resourceLoader.loadResource(`${options.BASEURL}api/templates.js`,
  function(resource) {
    var doc = Presenter.makeDocument(resource);
    doc.addEventListener("select", Presenter.load.bind(Presenter));
    navigationDocument.pushDocument(doc);
  });
}


/**
 * This convenience funnction returns an alert template, which can be used to present errors to the user.
 */
var createAlert = function(title, description) {

  var alertString = `<?xml version="1.0" encoding="UTF-8" ?>
  <document>
  <alertTemplate>
  <title>${title}</title>
  <description>${description}</description>
  </alertTemplate>
  </document>`

    var parser = new DOMParser();

  var alertDoc = parser.parseFromString(alertString, "application/xml");

  return alertDoc
}