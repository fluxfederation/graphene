require 'spec_helper'

describe Graphene::Views::Area do
  let(:canvas) { double("canvas") }
  let(:data) { [
    [0, 1],
    [1, 1],
    [2, 2],
    [3, 2],
  ] }
  let(:data2) { [
    [0, 4],
    [1, 1],
    [2, 5],
    [3, 2],
  ] }

  it "renders some boxes" do
    expect(canvas).to receive(:group).and_yield
    expect(canvas).to receive(:box).exactly(3).times

    chart = Graphene::Chart.new
    area = chart.area data

    point_mapper = Graphene::PointMapper.new(:bottom, :left)
    point_mapper.charts << chart
    point_mapper.x_axis_offset_in_units = 0

    area.layout(point_mapper).render(canvas, 0, 0, 600, 400)
  end

  it "renders some stacked boxes" do
    chart = Graphene::Chart.new
    area1, area2 = chart.stacked_area [data, data2]

    point_mapper = Graphene::PointMapper.new(:bottom, :left)
    point_mapper.charts << chart
    point_mapper.x_axis_offset_in_units = 0

    expect(canvas).to receive(:group).and_yield
    expect(canvas).to receive(:box).exactly(3).times
    area1.layout(point_mapper).render(canvas, 0, 0, 600, 400)

    expect(canvas).to receive(:group).and_yield
    expect(canvas).to receive(:box).exactly(3).times
    area2.layout(point_mapper).render(canvas, 0, 0, 600, 400)
  end
end
