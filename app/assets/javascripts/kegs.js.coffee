class TempChart
  constructor: (url) ->
    @url = url

    @margin = {top: 20, right: 50, bottom: 30, left: 50}
    @width = 700 - @margin.left - @margin.right
    @height = 170 - @margin.top - @margin.bottom

  draw: =>
    d3.json(@url, @callback)

  callback: (error, data) =>
    x = d3.time.scale().range([0, @width])
    y = d3.scale.linear().range([@height, 0])

    xAxis = d3.svg.axis().scale(x).orient("bottom")

    line = d3.svg.line()
      .x((d) -> x(new Date(d.created_at)))
      .y((d) -> y(parseFloat(d.temp_f)))

    color = d3.scale.category10()

    svg = d3.select("#temp-chart").append("svg")
      .attr("width", @width + @margin.left + @margin.right)
      .attr("height", @height + @margin.top + @margin.bottom)
      .append("g")
      .attr("transform", "translate(" + @margin.left + "," + @margin.top + ")")

    color.domain(d3.map(data, (d) -> d.name))

    x.domain([
      d3.min(data, (d) -> d3.min(d.data, (e) -> new Date(e.created_at))),
      d3.max(data, (d) -> d3.max(d.data, (e) -> new Date(e.created_at)))
    ])

    svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + @height + ")")
      .call(xAxis)

    sides = ["right", "left"]
    offsets = [@width, 0]
    tickSizes = [0, @width]

    data.forEach (datum) ->
      y.domain(d3.extent(datum.data, (d) -> parseFloat(d.temp_f)))

      side = sides.pop()

      yAxis = d3.svg.axis().scale(y).orient(side).ticks(7).tickSize(-tickSizes.pop())

      svg.append("g")
        .attr("class", "y axis axis-" + side)
        .attr("transform", "translate(" + offsets.pop() + ",0)")
        .attr("style", "fill: " + color(datum.name))
        .call(yAxis)

      svg.append("path")
        .datum(datum.data)
        .attr("class", "line line-" + side)
        .attr("d", line)
        .style("stroke", color(datum.name))

window.TempChart = TempChart