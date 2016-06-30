_              = require 'lodash'
temp           = require 'temp'
{EventEmitter} = require 'events'
ShellManager   = require '../src/shell-manager'

describe 'ShellManager', ->
  beforeEach (done) ->
    @sut = new ShellManager
    @spawn = new EventEmitter
    @spawn.stdout = new EventEmitter
    @spawn.stderr = new EventEmitter
    @sut.spawn = sinon.stub().returns @spawn
    {@request} = @sut
    @request.get = sinon.stub().yields null, {}, 'foo'
    options =
      shell: 'flish'
      env: [
        name: 'GLU'
        value: 'STICK'
      ]
      args: [
        '-File'
      ]
      fileExtension: '.sh'
    @sut.connect options, done

  describe '->runScript', ->
    beforeEach (done) ->
      options =
        script: 'echo'
        args: [1,2,3]
        env: [{name: "HI", value: 'VL'}]
        workingDirectory: 'home'

      @sut._writeTempfile = (script, callback) =>
        callback null, path: '/tmp/not-really-executed.sh'

      @sut.runScript options, (error, @response) =>
        done error
      @spawn.stdout.emit 'data', 'STDOUT'
      @spawn.stderr.emit 'data', 'STDERR'
      @spawn.emit 'close', 0

    it 'should call spawn', ->
      env = _.clone process.env
      env['HI'] = 'VL'
      env['GLU'] = 'STICK'
      options =
        cwd: 'home'
        env: env

      expect(@sut.spawn).to.have.been.calledWith 'flish', ['-File', '/tmp/not-really-executed.sh', 1, 2, 3], options

    it 'should yield response', ->
      data =
        exitCode: 0
        stderr: 'STDERR'
        stdout: 'STDOUT'
      expect(@response).to.deep.equal data

  describe '->runScriptUrl', ->
    beforeEach (done) ->
      options =
        url: 'http://some/file'
        args: [1,2,3]
        env: [{name: "HI", value: 'VL'}]
        workingDirectory: 'home'

      @sut._writeTempfile = (script, callback) =>
        callback null, path: '/tmp/not-really-executed.sh'

      @sut.runScriptUrl options, (error, @response) =>
        done error
      @spawn.stdout.emit 'data', 'STDOUT'
      @spawn.stderr.emit 'data', 'STDERR'
      @spawn.emit 'close', 0

    it 'should call spawn', ->
      env = _.clone process.env
      env['HI'] = 'VL'
      env['GLU'] = 'STICK'
      options =
        cwd: 'home'
        env: env

      expect(@sut.spawn).to.have.been.calledWith 'flish', ['-File', '/tmp/not-really-executed.sh', 1, 2, 3], options

    it 'should yield response', ->
      data =
        exitCode: 0
        stderr: 'STDERR'
        stdout: 'STDOUT'
      expect(@response).to.deep.equal data
