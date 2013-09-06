class TempChart
  constructor: (container) ->
    @container = container

    @url       = @container.data('sensor-url')
    @sensors   = @container.data('sensor-ids').toString().split(/, */)
    @offset    = 0

    @margin    = {top: 20, right: 20, bottom: 30, left: 50}
    @width     = @container.width()  - @margin.left - @margin.right
    @height    = @container.height() - @margin.top  - @margin.bottom
    @g_height  = (@height - (@sensors.length - 1) * 15) / @sensors.length

    @increment_hours = 2
    # hours in milliseconds
    @increment = @increment_hours * 3600000

    @to   = new Date()
    # 24 hours before @to
    @from = new Date(@to - 86400000)

    @x = d3.time.scale().range([0, @width])
    @y = d3.scale.linear().range([@g_height, 0])

    @axis = d3.svg.axis().orient("left").ticks(@g_height / 16).tickSize(-@width)

  getStartTime: (time) =>
    st = new Date(time)
    # For better caching, load from an increment hour that is in the future
    st.setHours(st.getHours() + @increment_hours - (st.getHours() % @increment_hours))
    st.setMinutes(0)
    st.setSeconds(0)
    st.setMilliseconds(0)
    st

  processData: (data) =>
    data.forEach (d) ->
      d.created_at = new Date(d.created_at)
      d.temp_f     = parseFloat(d.temp_f)

    data.filter (d) =>
      d.created_at > @from

  draw: =>
    @container.find('.loading').show();

    # Start drawing graph while we wait for a response
    @svg = d3.select(@container[0]).append("svg")
      .attr("width", @width + @margin.left + @margin.right)
      .attr("height", @height + @margin.top + @margin.bottom)
      .append("g")
      .attr("transform", "translate(" + @margin.left + "," + @margin.top + ")")

    # Draw the xAxis
    @x.domain([@from, @to])
    @svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + @height + ")")
      .call(d3.svg.axis().scale(@x).orient("bottom"))

    @color = d3.scale.category10()
    @color.domain(@sensors)

    @setupGraph()

  calculateX: (point)=>
    @x(point.created_at)

  calculateY: (point)=>
    @y(point.temp_f)

  setupGraph: =>
    @startTime = @getStartTime(@to)
    @sensor    = @sensors[@offset]
    @lineData  = []

    # Add bare yAxis
    @svgAxis = @svg.append("g")
      .attr("class", "y axis")
      .attr("transform", "translate(0,#{@offset * @g_height + @offset * 15})")
      .style("fill", @color(@sensor))

    # Add empty line
    @path = @svg.append("path")
      .attr("class", "line")
      .attr("transform", "translate(0,#{@offset * @g_height + @offset * 15})")
      .style("stroke", @color(@sensor))

    @loadLine()

  loadLine: =>
    if @startTime < @from
      if @sensors[++@offset]?
        @setupGraph()
      else
        @container.find('.loading').hide();
    else
      @startTime = new Date(@startTime - @increment)
      d3.json("#{@url}/#{@sensor}/#{@increment / 1000}/#{@startTime.getTime() / 1000}.json", @drawLine)


  drawLine: (error, data) =>
    @lineData = @processData(data).concat(@lineData)

    # Update y axis
    @y.domain(d3.extent(@lineData, (d) -> d.temp_f))
    @axis.scale(@y)
    @svgAxis.transition().duration(250)
      .call(@axis)

    # Update Path
    @path.datum(@lineData)
      .transition().duration(250).ease('easeInOutQuad').each('start', @loadLine)
      .attr("d", d3.svg.line().x(@calculateX).y(@calculateY))

window.TempChart = TempChart

$(->
  $('.temp-chart').each (idx) ->
    new TempChart($(this)).draw()
)
