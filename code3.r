
# パッケージの読み込み ----------------------------------------------------------------
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



# 岩手県のデータのみを抽出してiwateに入れる ----------------------------------------------------------------
iwate = df_kuma2 %>% filter(都道府県 == "岩手")



# ヒストグラムを作成 ---------------------------------------------------------------
# 岩手のみ
# ビン幅はgeom_histogram()の引数に「binwidth = 400」を入れて調整する
g = ggplot(data = iwate, aes(x = numbers))
h = geom_histogram()
g+h



# 全都道府県
g = ggplot(data = df_kuma2, aes(x = numbers))
h = geom_histogram(binwidth = 100)
f = facet_wrap(~ 都道府県, ncol = 10)
g+h+f+theme_gray(base_family = "HiraKakuPro-W3")



# 箱ひげ図を作成 -----------------------------------------------------------------
# 岩手のみ
g = ggplot(data = iwate, aes(x = 都道府県, y = numbers))
b = geom_boxplot()
g+b+theme_gray(base_family = "HiraKakuPro-W3")



# 各都道府県におけるクマ出没数の平均値と標準偏差を計算する --------------------------------------------
df_kuma3 = df_kuma2 %>% group_by(都道府県) %>% summarize(mean = mean(numbers), sd = sd(numbers))
df_kuma3 = df_kuma2 %>% group_by(都道府県) %>% summarize(mean = mean(numbers, na.rm = TRUE), sd = sd(numbers, na.rm = TRUE))



# やってみよう！ -----------------------------------------------------------------
# 各年の（全国での）出没数の平均値と標準偏差を計算し，year_meanというオブジェクトに入れてください
year_mean = df_kuma2 %>% group_by(year) %>% summarize(mean = mean(numbers, na.rm = TRUE), sd = sd(numbers, na.rm = TRUE))



# やってみよう！ -----------------------------------------------------------------
# df_kuma3から岩手県のみを抽出してiwate2に入れる
iwate2 = df_kuma3 %>% filter(都道府県 == "岩手")



# 棒グラフ＋エラーバーを作成 --------------------------------------------------------------
g = ggplot(data = iwate2, aes(x = 都道府県, y = mean))
b = geom_bar(stat = "identity", width = 0.6)
e = geom_errorbar(aes(ymin = mean - sd, ymax = mean + sd), width = 0.3)
g+b+e+theme_gray(base_family = "HiraKakuPro-W3")



# やってみよう！ -----------------------------------------------------------------
# 青森・岩手・秋田・宮城・山形・福島のデータを抽出してtohokuに入れて，ヒストグラム，箱ひげ，および棒グラフ＋エラーバーをfacet_wrap()を使用して作成してください
# ヒント：関数7





