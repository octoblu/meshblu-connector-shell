{EventEmitter}  = require 'events'
debug           = require('debug')('meshblu-connector-shell:index')
ShellManager    = require './shell-manager'

class Connector extends EventEmitter
  constructor: ->
    @shell = new ShellManager

  isOnline: (callback) =>
    callback null, running: true

  close: (callback) =>
    debug 'on close'
    @shell.close callback

  runScript: ({args, script, env, workingDirectory}, callback) =>
    @shell.runScript {args, script, env, workingDirectory}, callback

  runScriptUrl: ({args, url, env, workingDirectory}, callback) =>
    @shell.runScriptUrl {args, url, env, workingDirectory}, callback

  onConfig: (device={}, callback=->) =>
    { @options } = device
    debug 'on config', @options
    {shell, env} = @options ? {}
    @shell.connect {shell, env}, callback

  start: (device, callback) =>
    debug 'started'
    @onConfig device, callback

module.exports = Connector
