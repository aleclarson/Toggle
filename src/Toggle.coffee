
{Type, Style, Children} = require "modx"
{Responder} = require "gesture"
{View} = require "modx/views"

objectify = require "objectify"
Tappable = require "Tappable"
Event = require "Event"

type = Type "Toggle"

type.defineOptions
  value: Number.withDefault 0
  maxValue: Number.withDefault 1
  modes: Array.or Object

type.defineValues (options) ->

  tapConfig = objectify {keys: Responder.optionTypes, values: options}

  value: options.value

  maxValue: options.maxValue

  modes: options.modes

  _tap: Tappable tapConfig

type.addMixin Event.Mixin,

  didToggle: null

type.defineGetters

  didResponderGrant: -> @_tap.didResponderGrant

  didResponderReject: -> @_tap.didResponderReject

  didResponderEnd: -> @_tap.didResponderEnd

type.initInstance ->

  return if not modes = @modes

  if not Array.isArray modes
    @modes = modes = Object.keys(modes).map (key) ->
      mode = modes[key]
      mode.key = key
      return mode

  @maxValue = modes.length - 1
  return

type.defineBoundMethods

  _onToggle: ->

    if @value is @maxValue
    then @value = 0
    else @value += 1

    if @modes
    then @__events.didToggle @mode, @value
    else @__events.didToggle @value

type.defineListeners ->

  @_tap.didTap @_onToggle

  if fn = @props.onResponderGrant
    @_tap.didGrant fn

  if fn = @props.onResponderEnd
    @_tap.didEnd fn

type.defineGetters

  mode: -> @modes[@value]

#
# Rendering
#

type.defineProps
  style: Style
  children: Children

type.render ->
  return View
    style: @props.style
    children: @props.children
    mixins: [@_tap.touchHandlers]

module.exports = type.build()
