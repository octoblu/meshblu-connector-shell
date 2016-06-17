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
    callback()

  runCommand: ({args}, callback) =>
    {command, workingDirectory, shell} = @options
    @shell.runCommand {command, workingDirectory, args, shell}, callback

  onConfig: (device={}, callback=->) =>
    { @options } = device
    debug 'on config', @options
    callback()

  start: (device, callback) =>
    debug 'started'
    @onConfig device, callback

module.exports = Connector
