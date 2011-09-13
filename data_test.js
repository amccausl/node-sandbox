var http = require('http');
var fs = require('fs');
var async = require('async');
var Data = require('data');
var _ = require('underscore');

// App Config
global.config = JSON.parse(fs.readFileSync(__dirname+ '/config.json', 'utf-8'));
global.seed = JSON.parse(fs.readFileSync(__dirname+ '/db/schema.json', 'utf-8'));

var graph = new Data.Graph(seed, false);

// Showcasing middleware functionality
var Filters = {};
Filters.makeCrazy = function() {
  return {
    read: function(node, next, ctx) {
      node.crazy = true;
      next(node); // passes through the filtered node
    },

    write: function(node, next,ctx) {
      next(node); // no-op
    }
  };
};

// Connect to a data-store
graph.connect('couch', { 
  url: config.couchdb_url,
  filters: [
    Filters.makeCrazy()
  ]
});

graph.set({
  _id: "/listing/teambuy_28133394",
  type: "/type/listing",
  item_info: "Textbook Rental"
});

graph.merge( seed, { dirty: true } );
graph.sync(function(err) { if (!err) console.log('Successfully synced'); });

console.log( graph.get( "/listing/teambuy_28133394" ) );
