class TempChart
  constructor: (container) ->
    @container = container

    @url       = @container.data('sensor-url')
    @sensor    = @container.data('sensor-id')

    @duration  = @container.data('duration') || 21600

    @graph_end = moment().valueOf() / 1e3
    @graph_start = @graph_end - @duration

  draw: =>
    @container.find('.loading').show();
    @loadData()

  loadData: =>
    $.ajax url: "#{@url}/#{@sensor}/#{@duration}/#{Math.round(@graph_start)}.json", dataType: 'json', success: @prepData

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
    @rickshaw.series[0].data = @data
    @rickshaw.render()

  renderGraph: =>
    @rickshaw = new Rickshaw.Graph({
      element: @container[0],
      width: @container.width(),
      height: @container.height(),
      renderer: "line",
      start: @graph_start,
      end: @graph_end,
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
      pixelsPerTick: @container.height() / 2
    })
    @container.find('.loading').hide();
    @rickshaw.render()

$(->
  $('.temp-chart').each (idx) -> new TempChart($(this)).draw()
)
