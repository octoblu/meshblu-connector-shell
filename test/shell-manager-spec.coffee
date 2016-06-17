ShellManager = require '../src/shell-manager'

describe 'ShellManager', ->
  beforeEach ->
    @sut = new ShellManager

  describe '->runCommand', ->
    beforeEach (done) ->
      @sut._spawn = sinon.stub().yields null
      options =
        command: 'echo'
        args: [1,2,3]
        workingDirectory: 'home'
        shell: false

      @sut.runCommand options, done

    it 'should call spawn', ->
      options =
        command: 'echo'
        args: [1,2,3]
        workingDirectory: 'home'
        shell: false

      expect(@sut._spawn).to.have.been.calledWith options
