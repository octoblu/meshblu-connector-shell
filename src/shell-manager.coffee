_     = require 'lodash'
debug = require('debug')('meshblu-connector-shell:shell-manager')
spawn = require 'cross-spawn'

class ShellManager
  runCommand: ({command, workingDirectory, args, shell}, callback) =>
    @_spawn {command, workingDirectory, args, shell}, callback

  _spawn: ({command, workingDirectory, args, shell}, callback) =>
    callback = _.once callback
    debug "spawn: #{command} #{args.join(' ')}"
    options =
      cwd: workingDirectory
      env: process.env
      shell: shell
    proc = spawn command, args, options

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

module.exports = ShellManager
