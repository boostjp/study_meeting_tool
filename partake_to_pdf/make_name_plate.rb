# coding: UTF-8
#

# partakeの参加者リストから、Twitterアイコン入り名札のPDFを作る

require 'csv'
require 'open-uri'
require 'prawn'
require 'prawn/text'

# String -> Array[String]
# PartakeのCSVを読み込んでTwitter IDのリストを取得
def read_partake_csv(csv_filepath)
  ids = []
  CSV.foreach(csv_filepath) {|row|
    ids << row[2]
  }
  return ids
end

# String -> String -> Unit
# Twitter IDに対応するアイコンをfilepathにダウンロード
def download_twitter_icon(twitter_id, filepath)
  # TwitterアイコンのURL取得API
  # http://d.hatena.ne.jp/furyu-tei/20100615/1276542947
  icon_url = 'http://gadgtwit.appspot.com/twicon/' + twitter_id + '/bigger'

  open(icon_url) {|f|
    File::open(filepath, "wb") {|file|
      file.write f.read
    }
  }

  # FIXME!! PRAWNがGIFに対応してない...
  system('i_view32.exe ' + filepath + ' /convert=' + filepath)
end

Prawn::Document.generate('name_plate.pdf',
                         :page_size => 'A4',
                         :left_margin => 30,
                         :top_margin => 50) do

    twitter_ids = read_partake_csv('partake.csv');

    # 1ページ10枚
    page_in_max_count = 10
    page_count = twitter_ids.length / page_in_max_count
    page_count.times { start_new_page }

    count = 0
    twitter_ids.each {|id|
        icon_filename = 'icon.png'
        download_twitter_icon(id, icon_filename)

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
        image icon_filename,    :at => [x_point +   8, y_point -  38], :scale => 0.5

        count = count + 1
    }

end



