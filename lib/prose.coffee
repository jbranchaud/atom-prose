ProseView = require './prose-view'

module.exports =
  proseView: null

  activate: (state) ->
    atom.workspaceView.command "prose:toggle", => @toggle()
    @proseView = new ProseView()

  toggle: ->
    workspace = atom.workspaceView
    tabs = atom.packages.activatePackages.tabs

    if workspace.is '.prose'
      tabs?.activate()
    else
      tabs?.deactivate()

    workspace.toggleClass 'prose'

  deactivate: ->
    @proseView.destroy()

  serialize: ->
    proseViewState: @proseView.serialize()
