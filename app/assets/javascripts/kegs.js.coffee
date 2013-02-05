$.temp_chart = (data) ->
  margin = {top: 20, right: 20, bottom: 30, left: 50}
  width = 700 - margin.left - margin.right
  height = 170 - margin.top - margin.bottom

  x = d3.time.scale().range([0, width])

  y = d3.scale.linear().range([height, 0])

  xAxis = d3.svg.axis().scale(x).orient("bottom")

  yAxis = d3.svg.axis().scale(y).orient("left").tickSize(-width).ticks(7)

  line = d3.svg.line()
    .x((d) -> x(new Date(d.created_at)))
    .y((d) -> y(d.temp_f))

  svg = d3.select("#temp-chart").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")")

  x.domain(d3.extent(data, (d) -> new Date(d.created_at) ))
  y.domain(d3.extent(data, (d) -> d.temp_f ))

  svg.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxis)

  svg.append("g")
    .attr("class", "y axis")
    .call(yAxis)
    .append("text")
    .attr("transform", "rotate(-90)")
    .attr("y", 0)
    .attr("dy", "-2em")
    .style("text-anchor", "end")
    .text("Temp F")

  svg.append("path")
    .datum(data)
    .attr("class", "line")
    .attr("d", line)
