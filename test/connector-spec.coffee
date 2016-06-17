Connector = require '../'

describe 'Connector', ->
  beforeEach (done) ->
    @sut = new Connector
    {@shell} = @sut
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

  describe '->runCommand', ->
    beforeEach (done) ->
      @shell.runCommand = sinon.stub().yields null
      args = [1,2,3]
      @sut.runCommand {args}, done

    it 'should call shell.runCommand', ->
      options =
        workingDirectory: 'home'
        command: 'foo'
        args: [1,2,3]
        shell: undefined

      expect(@shell.runCommand).to.have.been.calledWith options

  describe '->onConfig', ->
    describe 'when called with a config', ->
      it 'should not throw an error', ->
        expect(=> @sut.onConfig { type: 'hello' }).to.not.throw(Error)
