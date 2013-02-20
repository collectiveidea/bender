class TempChart
  constructor: (url) ->
    @url = url

    container = $('#temp-chart')

    @margin = {top: 20, right: 50, bottom: 30, left: 50}
    @width = container.width() - @margin.left - @margin.right
    @height = container.height() - @margin.top - @margin.bottom

    @x = d3.time.scale().range([0, @width])
    @y = d3.scale.linear().range([@height, 0])

  draw: =>
    $('#temp-chart .loading').show();

    d3.json(@url, @callback)

    # Start drawing graph while we wait for a response
    @svg = d3.select("#temp-chart").append("svg")
      .attr("width", @width + @margin.left + @margin.right)
      .attr("height", @height + @margin.top + @margin.bottom)
      .append("g")
      .attr("transform", "translate(" + @margin.left + "," + @margin.top + ")")

    to = new Date()
    from = new Date(to - 86400000)
    @x.domain([from, to])

    # Draw the xAxis
    xAxis = d3.svg.axis().scale(@x).orient("bottom")

    @svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + @height + ")")
      .call(xAxis)

  calculateX: (point)=>
    @x(new Date(point.created_at))

  calculateY: (point)=>
    @y(parseFloat(point.temp_f))


  callback: (error, data) =>
    color = d3.scale.category10()
    color.domain(d3.map(data, (d) -> d.name))

    line = d3.svg.line()
      .x(@calculateX)
      .y(@calculateY)

    # First line
    leftData = data[0]
    leftColor = color(leftData.name)

    @y.domain(d3.extent(leftData.data, (d) -> parseFloat(d.temp_f)))

    yAxis = d3.svg.axis().scale(@y).orient("left").ticks(7).tickSize(-@width)

    @svg.append("g")
      .attr("class", "y axis")
      .attr("transform", "translate(0,0)")
      .attr("style", "fill: " + leftColor)
      .call(yAxis)

    @svg.append("path")
      .datum(leftData.data)
      .attr("class", "line")
      .attr("d", line)
      .style("stroke", leftColor)

    # Second line
    rightData = data[1]
    rightColor = color(rightData.name)

    @y.domain(d3.extent(rightData.data, (d) -> parseFloat(d.temp_f)))

    yAxis = d3.svg.axis().scale(@y).orient("right").ticks(7).tickSize(0)

    @svg.append("g")
      .attr("class", "y axis")
      .attr("transform", "translate(" + @width + ",0)")
      .attr("style", "fill: " + rightColor)
      .call(yAxis)

    @svg.append("path")
      .datum(rightData.data)
      .attr("class", "line")
      .attr("d", line)
      .style("stroke", rightColor)

    $('#temp-chart .loading').hide();

window.TempChart = TempChart