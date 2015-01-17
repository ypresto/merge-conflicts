{CompositeDisposable} = require 'atom'
{CoveringView} = require './covering-view'

module.exports =
class NavigationView extends CoveringView

  @content: (navigator, editorView) ->
    @div class: 'controls navigation', =>
      @text ' '
      @span class: 'pull-right', =>
        @button class: 'btn btn-xs', click: 'up', outlet: 'prevBtn', 'prev'
        @button class: 'btn btn-xs', click: 'down', outlet: 'nextBtn', 'next'

  initialize: (@navigator, editorView) ->
    super editorView
    @subs = new CompositeDisposable

    @prependKeystroke 'merge-conflicts:previous-unresolved', @prevBtn
    @prependKeystroke 'merge-conflicts:next-unresolved', @nextBtn

    @subs.add @navigator.conflict.onDidResolveConflict =>
      @deleteMarker @cover()
      @hide()

  detached: -> @subs.dispose()

  cover: -> @navigator.separatorMarker

  up: -> @scrollTo @navigator.previousUnresolved()?.scrollTarget()

  down: -> @scrollTo @navigator.nextUnresolved()?.scrollTarget()

  conflict: -> @navigator.conflict

  toString: -> "{NavView of: #{@conflict()}}"
