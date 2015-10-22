require 'graphene'

chart = Graphene::Chart.new
chart.name = "Area Chart"
chart.width = 1024
chart.legend = false

chart.x_axis.name = "Date"
chart.x_axis.ticks = 6
chart.x_axis.value_labels.formatter = lambda {|v| v.strftime("%e %b %Y")}

chart.y_axis.name = "Awesomeness"
chart.y_axis.ticks = 6
chart.y_axis.grid_ticks = 11
chart.y_axis.value_labels.formatter = "%0.1f"

colours = ["#EF5350", "#AB47BC", "#42A5F5"]
prng = Random.new

chart.stacked_area [
  [
    [Time.new(2010, 01, 01), prng.rand(9) + 1],
    [Time.new(2010, 01, 03), prng.rand(9) + 1],
    [Time.new(2010, 01, 04), prng.rand(9) + 1],
    [Time.new(2010, 01, 06), prng.rand(9) + 1],
    [Time.new(2010, 01, 11), prng.rand(9) + 1],
    [Time.new(2010, 01, 20), prng.rand(9) + 1],
    [Time.new(2010, 01, 30), prng.rand(9) + 1],
  ],
  [
    [Time.new(2010, 01, 01), prng.rand(9) + 1],
    [Time.new(2010, 01, 03), prng.rand(9) + 1],
    [Time.new(2010, 01, 04), prng.rand(9) + 1],
    [Time.new(2010, 01, 06), prng.rand(9) + 1],
    [Time.new(2010, 01, 11), prng.rand(9) + 1],
    [Time.new(2010, 01, 20), prng.rand(9) + 1],
    [Time.new(2010, 01, 30), prng.rand(9) + 1],
  ],
  [
    [Time.new(2010, 01, 01), prng.rand(9) + 1],
    [Time.new(2010, 01, 03), prng.rand(9) + 1],
    [Time.new(2010, 01, 04), prng.rand(9) + 1],
    [Time.new(2010, 01, 06), prng.rand(9) + 1],
    [Time.new(2010, 01, 11), prng.rand(9) + 1],
    [Time.new(2010, 01, 20), prng.rand(9) + 1],
    [Time.new(2010, 01, 30), prng.rand(9) + 1],
  ],
] do |area, index|
  area.name = "Cheese demand #{index}"
  area.fill_color = colours[index]
  area.hilight_color = colours[index]
  area.opacity = 0.88
end

svg = chart.to_svg
File.open("test.svg", "w") {|f| f.write svg}
`open test.svg`

