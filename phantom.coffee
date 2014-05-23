system = require 'system'

url = system.args[1]
documentQuery = system.args[2]

page = require('webpage').create()
page.open url, ->
  rows = page.evaluate (documentQuery)->
    document.querySelector(documentQuery).innerHTML
  , documentQuery
  console.log rows
  phantom.exit()