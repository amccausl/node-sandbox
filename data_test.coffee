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

graph.sync( (err) ->
    if (!err)
        console.log('Successfully synced')
    else
        console.log('error')
        console.log( err )
)

console.log( 'types:' )
console.log( graph.types().data )

console.log( 'objects:' )
console.log( graph.objects() )

graph.bind('dirty', ->
  graph.sync( (err, invalidNodes) ->
    if( !err )
        console.log('Successfully synced:')
    else
        console.log('error:')
        console.log( err )
        console.log( invalidNodes )
    console.log( 'new graph:' )
    console.log( graph.objects().data )
  )
)

console.log( 'adding /card/teambuy' )
graph.set(
  _id: "/card/teambuy"
  type: "/type/card"
  fn: "TeamBuy"
)

console.log( 'adding /listing/teambuy_28133394' )
graph.set(
  _id: "/listing/teambuy_28133394"
  type: "/type/listing"
  item_info: "Textbook Rental"
  lister: "/card/teambuy"
)

console.log( 'dirty:' )
console.log( graph.dirtyNodes().data )

console.log( 'invalid:' )
console.log( graph.invalidNodes() )

console.log( 'conflicted:' )
console.log( graph.conflictedNodes() )

console.log( 'rejected:' )
console.log( graph.rejectedNodes() )

#graph.merge( seed, { dirty: true } )
###
graph.sync( (err) ->
    if (!err)
        console.log('Successfully synced')
    else
        console.log('error')
        console.log( err )

    graph.set(
      _id: "/card/wagjag"
      type: "/type/card"
      fn: "wagjag"
    )

    old_value = graph.get( '/listing/teambuy_28133394' )
    console.log( old_value.get( 'lister' ).get( 'item_info' ) )
    graph.get( '/listing/teambuy_28133394' ).set(
      lister: "/card/wagjag"
    )

    console.log( graph.get( "/card/teambuy" ) )

    #graph.merge( seed, { dirty: true } )
    graph.sync( (err) ->
        if (!err)
            console.log('Successfully synced')
        else
            console.log('error')
            console.log( err )

        new_value = graph.get( "/listing/teambuy_28133394" )
        #console.log( new_value.get( 'lister' ).get( 'fn' ) )
    )
)
###
