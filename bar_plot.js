// !preview r2d3 data=c(0.3, 0.6, 0.8, 0.95, 0.40, 0.20)

var barHeight = Math.floor(height / data.length);

var bars = svg.selectAll('rect').data(data);

bars.enter().append('rect')
  .attr('width', function(d) { return d * width; })
  .attr('height', barHeight)
  .attr('y', function(d, i) { return i * barHeight; })
  .attr('fill', 'steelblue')
  .attr('dx', function(d, i) { return i })
  .on("click", function(){
    Shiny.setInputValue(
      "bar_clicked", 
      d3.select(this).attr("dx"),
      {priority: "event"}
    );
  })
  .on("mouseover", function() { console.log(d3.select(this).attr('width')) });
  
  
bars.transition()
  .duration(500)
    .attr('width', function(d) { return d.y; })
    .attr('height',col_heigth() * 0.9)
    .attr('y', function(d, i) { return i; });