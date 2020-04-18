# 画像サイズ変更ツール imageConverter（Powershell）

## これは何？
このツールは、指定したフォルダ内にある（複数の）画像ファイルに対して、一括してサイズ変更とフォーマットの変更を行います。みんな大好きPowershellです。  

ブログに乗せる写真を今までは手作業でチマチマgimpを使ってサイズを変換していたのですが、メンドクサイので一括変換しようと作ってみました。  

入力・出力で扱える画像フォーマットは、System.Drawing.Bitmapで読み書きできるモノになります。現状、jpeg,bmp,exif,gif,icon,png,tiff,wmf。

Powershellでの画像の取り扱いについては、Qiita [「PowerShell で画像の回転、リサイズを行う」](https://qiita.com/miyamiya/items/d1a975fb6618d46eda)を参考にしました。@miyamiyaさん、ありがとう！

## 使い方  

```
PS > .\imgConverter.ps1 -path C:\Users\UserName\Pictures -l 800 -s 600 -mode Jpeg
```  

- -path 画像ファイルを格納したフォルダパス  
- -l （long side）長辺のPixel数z  
- -s （short side）短辺のPixel数[省略可] 省略時は0   
- -imgf （image format）変換する画像フォーマット名 jpeg,bmp,exif,gif,ico,png,tiff,wmf [省略可] 省略時はjpeg 

省略可能な引数を省略したとき  

```
PS > .\imgConverter.ps1 -path C:\Users\UserName\Pictures -l 800
```  

## 仕様
- -pathについて  
  指定したフォルダにある画像ファイルを全て変換します。  
 画像として読み込めないファイルがある場合は、"Convert ERROR."とエラー表示して変換しません。  
 存在しないパスを指定した場合は、引数エラーになります。
- -l、-sについて  
  サイズ変換は元画像の縦横の長い方を "-l" で指定したPixel数に、短い方を "-s" で指定したPixel数に設定します。例えば "-l 800 -s 400" としたとき、1200 × 900 の画像は 800 × 400 に、900 × 1200の画像は 400 × 800 に変換されます。つまり長いほうが800Pixel、短いほうが400Pixelになります。  
"-l"に0以下の値を指定した場合、引数エラーになります。
- -sを省略、または0を指定した場合は、元画像のサイズの比率を維持して、長いほうを-lで指定したPixel数に変換します。例えば "-l 800" としたとき、1200 × 900（4:3の比）の画像は 800 × 600 に、900 × 1200（3:4の比）の画像は 600 × 800 に変換されます。
- -imgfについて  
  画像フォーマットを指定します。設定可能な値は、jpeg,bmp,exif,gif,ico,png,tiff,wmfになります。これらの文字列のいずれかを設定してください。  
これら以外の文字列を指定した場合、引数エラーになります。  
- 出力ファイル名は、-pathで指定されたフォルダに、ファイル名<拡張子無し>_.<-imgfで指定した文字列> となります。
 C:\Users\UserName\Pictures\xxx.jpg を bitmapに変換した場合、C:\Users\UserName\Pictures\xxx\_.bmp になります。  

### 実行結果例
 ```
 PS > .\imagConverter.ps1 -path C:\Users\UserName\Pictures -l 800
C:\Users\UserName\Pictures\xxx_.jpeg:(3264,2448)->(800,600)
C:\Users\UserName\Pictures\yyy_.jpeg:(5184,3888)->(800,600)```  