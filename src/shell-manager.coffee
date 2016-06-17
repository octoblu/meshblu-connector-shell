class ShellManager
  runCommand: ({command, workingDirectory, args}, callback) =>
    @_spawn {command, workingDirectory, args}, callback

  _spawn: ({command, workingDirectory, args}, callback) =>
    debug "spawn: #{command} #{args.join(' ')}"
    proc = spawn command, args, { cwd: workingDirectory, env: process.env }

    stdout = ''
    stderr = ''

    proc.on 'error', (error) =>
      debug 'error', error
      callback error

    proc.stdout.on 'data', (data) =>
      debug 'stdout', data.toString()
      stdout += data.toString()
      callback null, {type: 'stdout', data: data.toString()}

    proc.stderr.on 'data', (data) =>
      debug 'stderr', data.toString()
      stderr += data.toString()

    proc.on 'close', (exitCode) =>
      debug 'closed', exitCode
      callback null, {exitCode, stdout, stderr}

module.exports = ShellManager
