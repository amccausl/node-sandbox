http = require('http')
fs = require('fs')
async = require('async')
Data = require('data')
_ = require('underscore')

global.config = JSON.parse(fs.readFileSync(__dirname+ '/config.json', 'utf-8'))
global.seed = JSON.parse(fs.readFileSync(__dirname+ '/db/schema.json', 'utf-8'))

graph = new Data.Graph(seed, true)

graph.connect('couch', { 
  url: config.couchdb_url
})

graph.fetch( { 'type': '/type/card' }, (err, nodes) ->
  console.log( "nodes:" )
  console.log( nodes.data )

  console.log( "objects:" )
  console.log( graph.objects().data )

  console.log( "teambuy:" )
  console.log( graph.get( "/card/teambuy" ).get("fn") )
)

