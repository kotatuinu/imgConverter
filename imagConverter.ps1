param(
	[parameter(mandatory)][string]$path, 
	[parameter(mandatory)][int]$l, 
	[int]$s,
	[string]$mode="jpeg"
)
[void][Reflection.Assembly]::LoadWithPartialName("System.Drawing")

$imgFList=@{
	jpeg=[System.Drawing.Imaging.ImageFormat]::Jpeg;
	bmp=[System.Drawing.Imaging.ImageFormat]::Bmp;
	exif=[System.Drawing.Imaging.ImageFormat]::Exif;
	gif=[System.Drawing.Imaging.ImageFormat]::Gif;
	icon=[System.Drawing.Imaging.ImageFormat]::Icon;
	png=[System.Drawing.Imaging.ImageFormat]::Png;
	tiff=[System.Drawing.Imaging.ImageFormat]::Tiff;
	wmf=[System.Drawing.Imaging.ImageFormat]::Wmf;
}
if (-not (Test-Path $path)) {
	write-error "Invalid argment `"path`"."
	return
}
if ($l -le 0) {
	return
}
if (!$imgFList.ContainsKey($mode)) {
	write-error "Invalid argment `"mode`"."
	return
}
$imageFormat=$imgFList[$mode]

get-childitem $path | ?{!$_.PSIsContainer} | %{
	try {
		$image = New-Object System.Drawing.Bitmap($_.fullname)
		if ($image.Height -lt $image.Width) {
			# èc < â° -> â°Ç™í∑Ç¢
			$w=$l
			if ($s -eq 0) {
				$h=[math]::Truncate(($w/$image.Width)*$image.Height+.5)
			} else {
				$h=$s
			}
		} else {
			$h=$l
			if ($s -eq 0) {
				$w=[math]::Truncate(($h/$image.Height)*$image.Width+.5)
			} else {
				$w=$s
			}
		}
		$canvas = New-Object System.Drawing.Bitmap($w, $h)
		$graphics = [System.Drawing.Graphics]::FromImage($canvas)
		$graphics.DrawImage($image, (New-Object System.Drawing.Rectangle(0, 0, $canvas.Width, $canvas.Height)))
		$outname=("{0}\{1}_.{2}" -F $_.DirectoryName, $_.basename, $mode)
	("{0}:({1},{2})->({3},{4}) " -F $outname, $image.Width, $image.Height, $w, $h)
		$canvas.Save($outname, $imageFormat)
	} catch {
		write-error ("Convert ERROR. {0}" -F $_.fullname)
	} finally {
		if ($graphics -ne $null) { $graphics.Dispose() }
		if ($canvas -ne $null) { $canvas.Dispose() }
		if ($image -ne $null) { $image.Dispose() }
	}
}
