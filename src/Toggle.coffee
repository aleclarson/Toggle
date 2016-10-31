
{Type, Style, Children} = require "modx"
{View} = require "modx/views"

Tappable = require "Tappable"

type = Type "Toggle"

type.defineOptions
  value: Number.isRequired
  maxValue: Number.isRequired

type.defineValues (options) ->

  value: options.value

  maxValue: options.maxValue

  _tap: Tappable()

type.defineBoundMethods

  _onToggle: ->
    if @value is @maxValue
    then @value = 0
    else @value += 1
    @props.onToggle @value

type.defineListeners ->

  @_tap.didTap @_onToggle

  if fn = @props.onResponderGrant
    @_tap.didGrant fn

  if fn = @props.onResponderEnd
    @_tap.didEnd fn

#
# Rendering
#

type.defineProps
  style: Style
  children: Children
  onToggle: Function.isRequired
  onResponderGrant: Function
  onResponderEnd: Function

type.render ->
  return View
    style: @props.style
    children: @props.children
    mixins: [@_tap.touchHandlers]

module.exports = type.build()
