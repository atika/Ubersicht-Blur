# Blur Widget
# Display blurred blocs on background
# Dominique Da Silva
# https://github.com/atika
# Version 0.1

# Default Filters Values (Required)
# Blur (in pixels), brightness, saturation and contrast (in percentage)
# You can also set specific values directly for each bloc
filters =
  blur: 10
  brightness: 110
  saturate: 105
  contrast: 105

# Definition of each blurred bloc :
# left, top, width and height are required.
# Optionally you can set additional styles and image blur, brightness, saturate or contrast.
#
# You can set to auto (left or width) or (top or height)
# Examples:
#   left: "auto" and width: 200 (200 pixel width bloc positioned on the right)
#   left: 200 and width: "auto" (A bloc starting at 200px from the left to the end of the screen)
#   top: "auto" and height: 300 (300 pixel high bloc positioned on bottom)
#
# You can set to center (left or top)
# Examples:
#   left: "center" and width: 400 (400 pixel width bloc horizontally centered on the screen)
#   top: "center" and height: 500 (500 pixel high bloc vertically centered on the screen)
blocs = [
  {
    "left": 330
    "top": 98
    "width": 780
    "height": 44
    "style": {"border-radius":5, "border": "solid 1px rgba(255,255,255,0.1)"}
  }
  {
    "left": 0
    "top": "auto"
    "width": "auto"
    "height": 190
    "blur": 8
    "style": {"border-top": "solid 1px rgba(255,255,255,0.1)"}
  }
]

command: ""

refreshFrequency: 3000000000000

blocs: blocs
filters: filters


render: -> """
"""

style: """
  width: 100%
  height: 100%
  z-index: -100000
  overflow: hidden

  .bloc
    position:absolute
    overflow:hidden
  .flou
    -webkit-backdrop-filter: blur(#{filters.blur}px) brightness(#{filters.brightness}%) contrast(#{filters.contrast}%) saturate(#{filters.saturate}%)
"""

afterRender: (domEl)->
  i = 0
  for bloc in @blocs
    blocname = "bloc#{i}"

    # Filters
    blur = if typeof(bloc.blur) == "number" then bloc.blur else @filters.blur
    brightness = if typeof(bloc.brightness) == "number" then bloc.brightness else @filters.brightness
    contrast = if typeof(bloc.contrast) == "number" then bloc.contrast else @filters.contrast
    saturate = if typeof(bloc.saturate) == "number" then bloc.saturate else @filters.saturate

    # Size and position
    if bloc.left == "auto"
      bloc.left = $(window).width() - bloc.width
    else if bloc.left == "center"
      bloc.left = ($(window).width() - bloc.width) / 2
    if bloc.top == "auto"
      bloc.top = $(window).height() - bloc.height
    else if bloc.top == "center"
      bloc.top = ($(window).height() - bloc.height) / 2
    if bloc.width == "auto"
      bloc.width = $(window).width() - bloc.left
    if bloc.height == "auto"
      bloc.width = $(window).height() - bloc.top

    $(domEl).append "<div class=\"bloc #{blocname} flou\"></div>"
    $(".#{blocname}",domEl).css({"left":bloc.left,"top":bloc.top,"width":bloc.width,"height":bloc.height})

    # Set custom style
    if typeof(bloc.style) == "object"
      $(".#{blocname}",domEl).css(bloc.style)

    # Apply custom filters
    $(".#{blocname}",domEl).css({"-webkit-backdrop-filter":"blur(#{blur}px) brightness(#{brightness}%) contrast(#{contrast}%) saturate(#{saturate}%)"})
    i++
