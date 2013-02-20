class TempChart
  constructor: (url, sensor1, sensor2) ->
    @url = url
    @sensor1 = sensor1
    @sensor2 = sensor2

    @increment = 2 * 60 * 60 * 1000
    @to = new Date()
    @from = new Date(@to - 86400000)

    @endTime = new Date(@to - 0 + @increment)

    container = $('#temp-chart')

    @margin = {top: 20, right: 50, bottom: 30, left: 50}
    @width = container.width() - @margin.left - @margin.right
    @height = container.height() - @margin.top - @margin.bottom

    @x = d3.time.scale().range([0, @width])
    @y = d3.scale.linear().range([@height, 0])

    @color = d3.scale.category10()
    @color.domain(['line1', 'line2'])

    @lineData1 = []
    @lineData2 = []

  draw: =>
    $('#temp-chart .loading').show();

    # Start drawing graph while we wait for a response
    @svg = d3.select("#temp-chart").append("svg")
      .attr("width", @width + @margin.left + @margin.right)
      .attr("height", @height + @margin.top + @margin.bottom)
      .append("g")
      .attr("transform", "translate(" + @margin.left + "," + @margin.top + ")")


    @x.domain([@from, @to])

    # Draw the xAxis
    xAxis = d3.svg.axis().scale(@x).orient("bottom")

    @svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + @height + ")")
      .call(xAxis)

    @loadLine1()

    d3.json(@url, @callback)

  calculateX: (point)=>
    @x(new Date(point.created_at))

  calculateY: (point)=>
    @y(parseFloat(point.temp_f))

  loadLine1: =>
    @endTime = new Date(@endTime - @increment)
    @startTime = new Date(@endTime - @increment)

    if @startTime < @from
      @endTime = new Date(@to - 0 + @increment)
      @loadLine2()
    else
      d3.json(@url + "/" + @sensor1 + "?start_time=" + @startTime.toJSON() + "&end_time=" + @endTime.toJSON(), @drawLine1)

  loadLine2: =>
    @endTime = new Date(@endTime - @increment)
    @startTime = new Date(@endTime - @increment)

    if @startTime < @from
      $('#temp-chart .loading').hide();
    else
      d3.json(@url + "/" + @sensor2 + "?start_time=" + @startTime.toJSON() + "&end_time=" + @endTime.toJSON(), @drawLine2)


  drawLine1: (error, data) =>
    line = d3.svg.line()
      .x(@calculateX)
      .y(@calculateY)

    # First line
    @lineData1 = data.concat(@lineData1)
    leftColor = @color('line1')

    @y.domain(d3.extent(@lineData1, (d) -> parseFloat(d.temp_f)))

    yAxis = d3.svg.axis().scale(@y).orient("left").ticks(7).tickSize(-@width)

    @svg.selectAll('.y.axis.left').remove()

    @svg.append("g")
      .attr("class", "y axis left")
      .attr("transform", "translate(0,0)")
      .attr("style", "fill: " + leftColor)
      .call(yAxis)

    @svg.selectAll('.line.line1').remove()

    @svg.append("path")
      .datum(@lineData1)
      .attr("class", "line line1")
      .attr("d", line)
      .style("stroke", leftColor)

    @loadLine1()

  drawLine2: (error, data) =>
    line = d3.svg.line()
      .x(@calculateX)
      .y(@calculateY)

    # Second line
    @lineData2 = data.concat(@lineData2)
    rightColor = @color('line2')

    @y.domain(d3.extent(@lineData2, (d) -> parseFloat(d.temp_f)))

    yAxis = d3.svg.axis().scale(@y).orient("right").ticks(7).tickSize(0)

    @svg.selectAll('.y.axis.right').remove()

    @svg.append("g")
      .attr("class", "y axis right")
      .attr("transform", "translate(" + @width + ",0)")
      .attr("style", "fill: " + rightColor)
      .call(yAxis)

    @svg.selectAll('.line.line2').remove()

    @svg.append("path")
      .datum(@lineData2)
      .attr("class", "line line2")
      .attr("d", line)
      .style("stroke", rightColor)

    @loadLine2()

window.TempChart = TempChart