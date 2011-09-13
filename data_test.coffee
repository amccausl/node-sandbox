http = require('http')
fs = require('fs')
async = require('async')
Data = require('data')
_ = require('underscore')

global.config = JSON.parse(fs.readFileSync(__dirname+ '/config.json', 'utf-8'))
global.seed = JSON.parse(fs.readFileSync(__dirname+ '/db/schema.json', 'utf-8'))

graph = new Data.Graph(seed, false)

graph.connect('couch', { 
  url: config.couchdb_url
})

graph.set(
  _id: "/listing/teambuy_28133394",
  type: "/type/listing",
  item_info: "Textbook Rental"
)

graph.merge( seed, { dirty: true } )
graph.sync( (err) ->
    if (!err)
        console.log('Successfully synced')
)

console.log( graph.get( "/listing/teambuy_28133394" ) )
