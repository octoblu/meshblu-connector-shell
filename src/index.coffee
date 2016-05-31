{EventEmitter}  = require 'events'
spawn           = require 'cross-spawn'
debug           = require('debug')('meshblu-connector-shell:index')

class Shell extends EventEmitter
  onMessage: (message) =>
    return console.error 'missing shell command' unless @shellCommand?
    { options } = message.payload || {};
    options ?= []
    debug "spawn: #{@shellCommand} #{options.join(' ')}"
    proc = spawn @shellCommand, options, { @cwd, env: process.env }

    proc.on 'error', (error) =>
      debug 'error', error
      @emit 'error', error

    proc.stdout.on 'data', (data) =>
      debug 'stdout', data.toString()
      message =
        devices: ['*']
        topic: 'stdout'
        payload:
          stdout: data.toString()
      @emit 'message', message

    proc.stderr.on 'data', (data) =>
      debug 'stderr', data.toString()
      message =
        devices: ['*']
        topic: 'stderr'
        payload:
          stderr: data.toString()
      @emit 'message', message

    proc.on 'close', (code) =>
      debug 'closed', code
      message =
        devices: ['*']
        topic: 'exit'
        payload:
          code: code
      @emit 'message', message

  onConfig: (device={}) =>
    { options } = device
    debug 'on config', options
    { @shellCommand, @cwd } = options

  start: (device) =>
    { @uuid } = device
    debug 'started', @uuid
    @onConfig device

module.exports = Shell
