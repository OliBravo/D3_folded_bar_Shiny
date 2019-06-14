// !preview r2d3 data=c(0.3, 0.6, 0.8, 0.95, 0.40, 0.20)

var barHeight = Math.floor(height / data.length);

var bars = r2d3.svg.selectAll('rect')
  .data(data);

bars.enter()
  .append('rect')
    .attr('width', function(d) { return d.value * width; })
    .attr('height', barHeight)
    .attr('y', function(d, i) { return i * barHeight; })
    .attr('fill', 'steelblue')
    .attr('dx', function(d) { return d.month })
    .attr("fill", "orange")
    .on("click", function(){
      Shiny.setInputValue(
        "bar_clicked", 
        d3.select(this).attr("dx"),
        {priority: "event"}
      );
    });
  //.on("mouseover", function() { console.log(d3.select(this).attr('width')) });


bars.exit().remove();

  
// A function that create / update the plot for a given variable:
function update(data) {

  // Update the X axis
  x.domain(data.map(function(d) { return d.month; }))
  xAxis.call(d3.axisBottom(x))

  // Update the Y axis
  y.domain([0, d3.max(data, function(d) { return d.value }) ]);
  yAxis.transition().duration(1000).call(d3.axisLeft(y));

  // Create the u variable
  var u = svg.selectAll("rect")
    .data(data)

  u
    .enter()
    .append("rect") // Add a new rect for each new elements
    .merge(u) // get the already existing elements as well
    .transition() // and apply changes to all of them
    .duration(1000)
      .attr("x", function(d) { return x(d.month); })
      .attr("y", function(d) { return y(d.value); })
      .attr("width", x.bandwidth())
      .attr("height", function(d) { return height - y(d.value); })
      .attr("fill", "#69b3a2")

  // If less group in the new dataset, I delete the ones not in use anymore
  u
    .exit()
    .remove()
}