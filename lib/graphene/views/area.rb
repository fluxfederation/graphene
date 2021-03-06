module Graphene
  module Views
    class Area < Base
      attr_reader :offsets
      attr_accessor :fill_colour, :fill_opacity, :hilight_color

      alias :fill_color  :fill_colour
      alias :fill_color= :fill_colour=

      def initialize(dataset, start, step, offsets=Hash.new{|h,k| 0})
        super()

        @offsets = offsets

        if x_value = start
          step = step || 1
          @dataset = new_dataset = []
          dataset.each do |y_value|
            new_dataset << [x_value, y_value] if y_value
            x_value += step
          end
        else
          @dataset = dataset
        end
      end

      def push_watermark(watermark, type, comparitor)
        dataset.each do |x, y|
          value = type == :x ? x : y + offsets[x]
          watermark = value if value && (watermark.nil? || value.send(comparitor, watermark))
        end
        watermark
      end

      def opacity=(value)
        @stroke_opacity = @fill_opacity = value
      end

      def layout(point_mapper)
        Renderer.new(self, point_mapper)
      end

      class Renderer
        def initialize(area, point_mapper)
          @area = area
          @point_mapper = point_mapper
        end

        def renderable_object
          @area
        end

        def preferred_width;  nil; end
        def preferred_height; nil; end

        def render(canvas, left, top, width, height)
          index_for_sorting = 0
          sorted = @area.dataset.to_a.sort_by {|k, v| [k, index_for_sorting += 1]} # see http://bugs.ruby-lang.org/issues/1089#note-10

          rects = []
          sorted.each_with_index do |(x_value, y_value), index|
            x1, y1 = @point_mapper.values_to_coordinates(@area.axis, x_value, y_value + @area.offsets[x_value], width, height)
            x2, y2 = @point_mapper.values_to_coordinates(@area.axis, sorted[index+1] && sorted[index+1].first, @area.offsets[x_value], width, height)
            x1 = 0 if x1 < 0

            next if x2.nil? || x2 == x1 || x2 < 0 || x1 > width

            w = x2 - x1
            w = width - x1 if w + x1 > width

            h = y2 - y1
            if h > height
              y1 += h - height
              h = y2 - y1
            end

            rects << {:x => x1+left, :y => y1+top, :width => w, :height => h,
                      :x_value => x_value, :x2_value => sorted[index+1] && sorted[index+1].first, :y_value => y_value}
          end

          canvas.group({:'data-name' => @area.name, :'data-type' => 'area', :'data-left' => left, :'data-top' => top, :'data-width' => width, :'data-height' => height, :'data-data' => rects.to_json}) do
            rects.each_with_index do |rect, i|
              canvas.box(rect[:x], rect[:y], rect[:width], rect[:height],
                'stroke' => 'none',
                'fill' => (i < rects.length - 1) ? @area.fill_color : @area.hilight_color,
                'fill-opacity' => @area.fill_opacity
              )
            end

          end
        end
      end
    end
  end
end
