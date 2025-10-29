
# パッケージの読み込み ----------------------------------------------------------------
install.packages(c("sf", "NipponMap"))
require(sf)
require(NipponMap)
library(tidyverse)



# ディレクトリ --------------------------------------------------------------------
# 講義で使用するフォルダ「stats1」を参照するように設定を変更する
setwd("/Users/Yuki/Library/CloudStorage/Dropbox/岩手大学/R7/環境統計学Ⅰ/")



# データの読み込み --------------------------------------------------------------------
# データを読み込み，オブジェクト名をdf_kumaと付ける
df_kuma = read.csv("data_kuma.csv", fileEncoding = "CP932") # fileEncodingでエンコーディングの種類をすると，文字化けを防止できる



# tidyデータに ----------------------------------------------------------------
df_kuma2 = df_kuma %>% gather(key = "X_year", value = "numbers", 2:18) %>% 
  mutate(year = as.numeric(str_sub(X_year, 2, 5))) %>% 
  select(-X_year)

# 日本地図を抽出
map = read_sf(system.file("shapes/jpn.shp", package = "NipponMap")[1],
              crs = "+proj=longlat +datum=WGS84")



# 都道府県名について，漢字とローマ字の対応表を作成 ------------------------------------------------
pref = data.frame(name = map$name)
pref$都道府県 = c("北海道", "青森", "岩手", "宮城", "秋田", "山形", "福島", "茨城", "栃木", "群馬", "埼玉", "千葉", "東京", "神奈川", "新潟", "富山", "石川", "福井", "山梨", "長野", "岐阜", "静岡", "愛知", "三重", "滋賀", "京都", "大阪", "兵庫", "奈良", "和歌山", "鳥取", "島根", "岡山", "広島", "山口", "徳島", "香川", "愛媛", "高知", "福岡", "佐賀", "長崎", "熊本", "大分", "宮崎", "鹿児島", "沖縄")
map = left_join(map, pref, by = "name") %>% select(-population)




# 地図情報が入ったmapとクマ情報が入ったdf_kuma2を結合する -------------------------------------------------------------------------
map2 = left_join(map, df_kuma2, by = "都道府県")

temp = map2 %>% filter(region == "Kyushu / Okinawa")

kyushu = NULL
for(i in 2009:2025){
  df = temp
  df$year = as.numeric(paste0(i))
  kyushu = rbind(kyushu, df)
}

map2_2 = map2 %>% filter(region != "Kyushu / Okinawa")
map3 = rbind(map2_2, kyushu)



# 作図 ----------------------------------------------------------------------
g = ggplot(map3, aes(fill = numbers))
s = geom_sf()
f = facet_wrap(~ year, ncol = 6)
c = scale_fill_gradientn(colours = c("black", "blue", "cyan", "green", "yellow", "orange", "red", "darkred"))
g+s+f+c+theme_bw()

