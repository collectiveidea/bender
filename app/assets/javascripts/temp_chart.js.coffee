class TempChart
  constructor: (container) ->
    @container = container
    @graphContainer = @container.find(".graph-wrapper")

    @url = @container.data('sensor-url')
    @sensor = @container.data('sensor-id')

    @duration = @container.data('duration') || 21600

    if @container.data('graph-end')?
      @graphEnd = parseFloat(@container.data('graph-end'))
    else
      @graphEnd = moment().valueOf() / 1e3

    @graphStart = @graphEnd - @duration

    @frozen = false

    if fayeClient?
      fayeClient.subscribe "/temperature/#{@sensor}", (message) =>
        if !@frozen
          message = $.parseJSON(message)
          @data.push(message)
          @graphEnd = message[1]
          @graphStart = @graphEnd - @duration
          data = _.reject(@data, (obj) => obj[1] < @graphStart )
          @prepData(data, 200)

    @container.find(".next").on "click", (e) =>
      e.preventDefault()
      el = $(e.currentTarget)
      el.blur()

      if !el.hasClass("inactive")
        @graphEnd = @graphEnd + @duration
        @now = moment().valueOf() / 1e3
        if @now < @graphEnd
          @graphEnd = @now
          @deactivateNext()
        @graphStart = @graphEnd - @duration

        @draw()

    @container.find(".prev").on "click", (e) =>
      e.preventDefault()
      $(e.currentTarget).blur()

      @graphEnd = @graphStart
      @graphStart = @graphEnd - @duration

      @activateNext()

      @draw()

    @container.find(".current").on "click", (e) =>
      e.preventDefault()
      el = $(e.currentTarget)
      el.blur()

      if !el.hasClass("inactive")
        @graphEnd = moment().valueOf() / 1e3
        @graphStart = @graphEnd - @duration

        @deactivateNext()

        @draw()

  activateNext: =>
    @container.find(".current").removeClass("inactive")
    @container.find(".next").removeClass("inactive")
    @frozen = true

  deactivateNext: =>
    @container.find(".current").addClass("inactive")
    @container.find(".next").addClass("inactive")
    @frozen = false

  draw: =>
    @container.find('.loading').show();
    @loadData()

  loadData: =>
    $.ajax url: "/temperature_sensors/#{@sensor}/#{@duration}/#{Math.round(@graphStart)}.json", dataType: 'json', success: @prepData

  prepData: (data, status)=>
    @data = data
    @data.forEach (d) ->
      d.x = d[1] + moment(d[1] * 1e3).utcOffset() * 60
      d.y = parseFloat(d[0])

    if @rickshaw?
      @updateGraph()
    else
      @renderGraph()

  updateGraph: =>
    @rickshaw.end = @graphEnd + moment(@graphEnd * 1e3).utcOffset() * 60
    @rickshaw.start = @graphStart + moment(@graphStart * 1e3).utcOffset() * 60
    @rickshaw.series[0].data = @data
    @rickshaw.update()
    @container.find('.loading').hide()

    if @data.length > 1
      @container.find('.no-data').hide()
    else
      @container.find('.no-data').show()

  renderGraph: =>
    if @data.length > 1
      @rickshaw = new Rickshaw.Graph({
        element: @graphContainer[0],
        width: @graphContainer.width(),
        height: @graphContainer.height(),
        renderer: "line",
        start: @graphStart + moment(@graphStart * 1e3).utcOffset() * 60,
        end: @graphEnd + moment(@graphEnd * 1e3).utcOffset() * 60,
        min: "auto",
        interpolation: "linear",
        series: [{
          color: 'steelblue',
          data: @data,
          name: "F"
        }],
        padding: {
          top: .01,
          bottom: .1,
          left: .03,
          right: .01
        }
      })
      @hoverDetail = new Rickshaw.Graph.HoverDetail({
        graph: @rickshaw,
        yFormatter: (e) -> e,
        xFormatter: (e) -> moment(e * 1e3).utc().format("MMMM Do YYYY HH:mm"),
        formatter: (e, t, n, r, i, s) -> i + "&nbsp;" + e.name
      })
      @xAxis = new Rickshaw.Graph.Axis.Time({
        graph: @rickshaw,
        ticksTreatment: "glow"
      })
      @yAxis = new Rickshaw.Graph.Axis.Y({
        graph: @rickshaw,
        tickFormat: Rickshaw.Fixtures.Number.formatKMBT,
        ticksTreatment: "glow",
        pixelsPerTick: @graphContainer.height() / 2
      })
      @container.find('.loading').hide()
      @container.find('.no-data').hide()
      @rickshaw.render()
    else
      @container.find('.loading').hide()
      @container.find('.no-data').show()

$(->
  $('.temp-chart').each (idx) -> new TempChart($(this)).draw()
)
