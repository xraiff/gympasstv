//# sourceURL=application.js

/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information

 Abstract:
 This is the entry point to the application and handles the initial loading of required JavaScript files.
 */

var resourceLoader;

/**
 * An object to store videos and playlists for ease of access
 */
var Videos = {
  video: [{
    title: "AV BipBop",
    subtitle: "Sample HLS Stream",
    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    artworkImageURL: "",
    contentRatingDomain: "movie",
    contentRatingRanking: 400,
    url: "https://devimages.apple.com.edgekey.net/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8"
  }],

  track: [{
    title: "Track & Field",
    subtitle: "Track & Field",
    description: "Track & Field 2015",
    artworkImageURL: "",
    contentRatingDomain: "movie",
    contentRatingRanking: 400,
    url: "https://s3.amazonaws.com/gympasstv/umc/640/prog.m3u8"
  }],

  playlist: [{
    title: "Apple Special Events",
    subtitle: "September 9, 2015",
    description: "Check out iPhone 6s and iPhone 6s Plus, learn about the powerful iPad Pro, take a look at the new features and bands for Apple Watch, and see the premiere of the all-new Apple TV.",
    artworkImageURL: "http://images.apple.com/apple-events/static/apple-events/apple-events-index/hero/september2015/hero_image_large.jpg",
    contentRatingDomain: "tvshow",
    contentRatingRanking: 200,
    url: "http://p.events-delivery.apple.com.edgesuite.net/1509pijnedfvopihbefvpijlkjb/m3u8/hls_vod_mvp.m3u8"
  }, {
    title: "Apple WWDC 2015 Keynote Address",
    subtitle: "June 8, 2015",
    description: "See the announcement of Apple Music, get a preview of OS X El Capitan and iOS 9, and learn what's next for Apple Watch and developers.",
    artworkImageURL: "http://images.apple.com/apple-events/static/apple-events/apple-events-index/pastevents/june2015/hero_image_large.jpg",
    contentRatingDomain: "tvshow",
    contentRatingRanking: 500,
    resumeTime: 330,
    url: "http://p.events-delivery.apple.com.edgesuite.net/15pijbnaefvpoijbaefvpihb06/m3u8/hls_vod_mvp.m3u8"
  }, {
    title: "Apple Special Event",
    subtitle: "March 2015",
    description: "Get an in-depth look at Apple Watch, witness the unveiling of the new MacBook, and learn about the innovations in ResearchKit.",
    artworkImageURL: "http://images.apple.com/apple-events/static/apple-events/apple-events-index/pastevents/march2015/hero_image_large.jpg",
    contentRatingDomain: "tvshow",
    contentRatingRanking: 200,
    url: "http://p.events-delivery.apple.com.edgesuite.net/1503ohibasdvoihbasfdv/vod/1503poihbsdfvpihb_cc_vod.m3u8"
  }]
};

var GPTV = {
  zipcode: null,
  options: {}
};

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
  GPTV.options = options;

  var index = resourceLoader.loadResource(`${options.BASEURL}templates/home.js`,
  function(resource) {
    console.log("1st loadResource callback");
    var doc = Presenter.makeDocument(resource);
    //doc.addEventListener("select", Presenter.load.bind(Presenter));
    doc.addEventListener("select", handleSelectEvent);
    var keyboard = doc.getElementById("zipcode").getFeature("Keyboard");
    keyboard.onTextChange = function(event) { handleTextChange(keyboard.text); }

    navigationDocument.pushDocument(doc);
  });
}

function handleSelectEvent(event) {
  console.log("handle select event");
  var klass = event.target.getAttribute("class");

  switch (klass) {
    case 'link':
      try {
        var url = event.target.getAttribute('data');
        objectwrapper.openURL(url);
      } catch(err) {
        console.log(err.message);
      }

      break;
    case 'play':
      handlePlayEvent(event);
      break;
    case 'search':
      search(GPTV.zipcode);
      break;
    case 'reload':
      App.reload();
      break;
  }
}

function handleTextChange(newText) {
  console.log("handleTextChange : " + newText);
  GPTV.zipcode = newText;
}

function handleFormEvent(event) {
  console.log("handle form event");
  var id = event.target.getAttribute("id");
  console.log("value = " + event.target.value);
}

function handlePlayEvent(event) {
  console.log("handle Play Event");
  var video = JSON.parse(event.target.getAttribute('data'));
  startPlayback([video]);
}

function search(zipcode) {
  var index = resourceLoader.loadResource(`${GPTV.options.BASEURL}templates/search.js?zipcode=${zipcode}`,
  function(resource) {
    console.log("2nd loadResource callback");
    var doc = Presenter.makeDocument(resource);
    //doc.addEventListener("select", Presenter.load.bind(Presenter));
    doc.addEventListener("select", handleSelectEvent);
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