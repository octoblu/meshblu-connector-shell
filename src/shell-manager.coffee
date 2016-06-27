_     = require 'lodash'
fs    = require 'fs'
temp  = require 'temp'
request = require 'request'
debug = require('debug')('meshblu-connector-shell:shell-manager')
spawn = require 'cross-spawn'

class ShellManager
  constructor: ->
    # hook for testing
    @spawn = spawn
    @request = request
    temp.track()

  close: (callback) =>
    temp.cleanup => callback()

  connect: ({@shell, @env}, callback) =>
    callback()

  _writeTempfile: (script, callback) =>
    temp.open prefix: 'meshblu-shell', (error, info) =>
      return callback error if error?
      fs.write info.fd, script, (error) =>
        return callback error if error?
        fs.close info.fd, (error) =>
          return callback error if error?
          callback null, path: info.path

  runScript: ({script, workingDirectory, args, env, shell}, callback) =>
    @_writeRunScript {script, workingDirectory, args, env, shell}, callback

  runScriptUrl: ({url, workingDirectory, args, env, shell}, callback) =>
    @request.get url, (error, response, script) =>
      return callback error if error?
      return callback new Error "Invalid Response Code: #{response.statusCode}" if response.statusCode > 399
      @_writeRunScript {script, workingDirectory, args, env, shell}, callback

  _writeRunScript: ({script, workingDirectory, args, env, shell}, callback) =>
    args ?= []
    callback = _.once callback
    @_writeTempfile script, (error, {path}) =>
      return callback error if error?
      localenv = @_handleEnv env
      args.unshift path
      options =
        cwd: workingDirectory
        env: localenv
      debug "Calling #{@shell} with: ", {args, options}

      proc = @spawn @shell, args, options

      @_handleProc proc, callback

  _handleProc: (proc, callback) =>
    stdout = ''
    stderr = ''

    proc.on 'error', (error) =>
      debug 'error', error
      callback error

    proc.stdout.on 'data', (data) =>
      debug 'stdout', data.toString()
      stdout += data.toString()

    proc.stderr.on 'data', (data) =>
      debug 'stderr', data.toString()
      stderr += data.toString()

    proc.on 'close', (exitCode) =>
      debug 'closed', exitCode
      callback null, {exitCode, stdout, stderr}

  _handleEnv: (env) =>
    localenv = _.clone process.env
    _.each @env, ({name, value}) =>
      localenv[name] = value
    _.each env, ({name, value}) =>
      localenv[name] = value
    return localenv

module.exports = ShellManager
