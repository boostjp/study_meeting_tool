# coding: UTF-8
#

# アイコンなし名札のPDFを作る

require 'prawn'

Prawn::Document.generate('empty_name_plate.pdf',
                         :page_size => 'A4',
                         :left_margin => 30,
                         :top_margin => 50) do

    person_count = 10       # 枚数
    page_in_max_count = 10  # 1ページ内の枚数

    page_count = person_count / page_in_max_count
    page_count.times { start_new_page }

    person_count.times {|count|
        go_to_page((count / page_in_max_count) + 1)

        x = (count % page_in_max_count) % 2
        y = (count % page_in_max_count) / 2

        x_point = x * 264
        y_point = 790 - y * 160 # 上方向に行くと+

        bounding_box [x_point, y_point], :width => 264, :height => 160 do
            stroke_rectangle bounds.top_left, bounds.width, bounds.height
        end

        image 'title.png',      :at => [x_point +   4, y_point -   8], :scale => 1.0
        image 'boost_logo.png', :at => [x_point + 116, y_point - 110], :scale => 0.5
    }

end



