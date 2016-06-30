Connector = require '../'

describe 'Connector', ->
  beforeEach (done) ->
    @sut = new Connector
    {@shell} = @sut
    @shell.connect = sinon.stub().yields null
    options =
      command: 'foo'
      workingDirectory: 'home'

    @sut.start {options}, done

  afterEach (done) ->
    @sut.close done

  describe '->isOnline', ->
    it 'should yield running true', (done) ->
      @sut.isOnline (error, response) =>
        return done error if error?
        expect(response.running).to.be.true
        done()

  describe '->runScript', ->
    beforeEach (done) ->
      @shell.runScript = sinon.stub().yields null
      options =
        workingDirectory: 'home'
        script: 'foo'
        args: [1,2,3]
        env: []
      @sut.runScript options, done

    it 'should call shell.runScript', ->
      options =
        workingDirectory: 'home'
        script: 'foo'
        args: [1,2,3]
        env: []

      expect(@shell.runScript).to.have.been.calledWith options

  describe '->runScriptUrl', ->
    beforeEach (done) ->
      @shell.runScriptUrl = sinon.stub().yields null
      options =
        workingDirectory: 'home'
        url: 'foo'
        args: [1,2,3]
        env: []
      @sut.runScriptUrl options, done

    it 'should call shell.runScript', ->
      options =
        workingDirectory: 'home'
        url: 'foo'
        args: [1,2,3]
        env: []

      expect(@shell.runScriptUrl).to.have.been.calledWith options

  describe '->onConfig', ->
    beforeEach (done) ->
      options =
        shell: 'hi'
        env: []
        args: []
        fileExtension: '.boo'

      @sut.onConfig {options}, done

    it 'should call @shell.connect', ->
      expect(@shell.connect).to.have.been.calledWith shell: 'hi', env: [], args: [], fileExtension: '.boo'
