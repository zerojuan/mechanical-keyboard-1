KeyboardListener = require './keyboard-listener'

module.exports =
  config:
    enabled:
      type: 'boolean'
      default: true
  toggleState: false
  keyboardListeners: null

  activate: (state) ->
    console.log('Activated')
    atom.commands.add 'atom-workspace','mechanical-keyboard:toggle', => @toggle()
    @keyboardListeners = [];
    @toggleState = atom.config.get('mechanical-keyboard-1.enabled')
    
    that = @; #TODO: how does this work in coffeescript?
    atom.config.onDidChange 'mechanical-keyboard-1.enabled', (newValue) ->
      that.onSetFromConfig newValue

    atom.workspace.observeTextEditors (editor) ->
      that.keyboardListeners.push new KeyboardListener editor
      # immediately attach listeners to new editors
      that.setupListener()

  setupListener: ->
    if @toggleState
      @keyboardListeners.forEach (listener) -> listener.subscribe()
    else
      @keyboardListeners.forEach (listener) -> listener.unsubscribe()

  toggle: ->
    @toggleState = !@toggleState
    atom.config.set('mechanical-keyboard-1.enabled', @toggleState)

  onSetFromConfig: (value) ->
    @toggleState = value.newValue
    @setupListener()

  deactivate: ->
    # nothing to do here
