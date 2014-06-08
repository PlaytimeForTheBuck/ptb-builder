system = require 'system'

url = system.args[1]

page = require('webpage').create()

page.settings.userAgent = 'PhantomJS'

page.onError = (msg, trace)->
  msgStack = ['PHANTOM ERROR: ' + msg]
  if trace && trace.length
    msgStack.push('TRACE:')
    trace.forEach (t)->
      msgStack.push(' -> ' + (t.file || t.sourceURL) + ': ' + t.line + (t.function ? ' (in function ' + t.function + ')' : ''))
  console.error(msgStack.join('\n'))
  phantom.exit(1)

page.open url, ->
  console.log page.content
  phantom.exit()