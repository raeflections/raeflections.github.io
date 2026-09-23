# ==========================================
# raeflections - Web Image Converter
# ==========================================

$ImageFolder = ".\images"

# Maximum width of generated WebP images.
# Images smaller than this will NOT be enlarged.
$MaxWidth = 2000

# WebP quality: 0-100
$Quality = 85

$Extensions = @(".jpg", ".jpeg", ".png")

Write-Host ""
Write-Host "raeflections image optimization"
Write-Host "--------------------------------"
Write-Host "Maximum width: $MaxWidth px"
Write-Host "WebP quality:  $Quality"
Write-Host ""

$Files = Get-ChildItem `
    -Path $ImageFolder `
    -Recurse `
    -File |
    Where-Object {
        $Extensions -contains $_.Extension.ToLower()
    }

Write-Host "Found $($Files.Count) images."
Write-Host ""

foreach ($File in $Files) {

    $OutputFile = Join-Path `
        $File.DirectoryName `
        ($File.BaseName + ".webp")

    # Don't overwrite an existing WebP
    if (Test-Path $OutputFile) {
        Write-Host "SKIP: $($File.FullName)"
        Write-Host "      WebP already exists."
        continue
    }

    Write-Host "CONVERTING:"
    Write-Host "  $($File.FullName)"

    # Resize only when wider than MaxWidth.
    # -2 preserves aspect ratio and ensures
    # a codec-friendly even dimension.
    ffmpeg `
        -hide_banner `
        -loglevel error `
        -i "$($File.FullName)" `
        -vf "scale='min($MaxWidth,iw)':-2" `
        -c:v libwebp `
        -quality $Quality `
        "$OutputFile"

    if ($LASTEXITCODE -eq 0) {

        $OriginalSize = $File.Length
        $WebPSize = (Get-Item $OutputFile).Length

        $OriginalMB = [math]::Round(
            $OriginalSize / 1MB,
            2
        )

        $WebPMB = [math]::Round(
            $WebPSize / 1MB,
            2
        )

        if ($OriginalSize -gt 0) {
            $Reduction = [math]::Round(
                (1 - ($WebPSize / $OriginalSize)) * 100,
                1
            )
        }
        else {
            $Reduction = 0
        }

        Write-Host "  Original: $OriginalMB MB"
        Write-Host "  WebP:     $WebPMB MB"
        Write-Host "  Saved:    $Reduction%"
        Write-Host ""
    }
    else {
        Write-Host "  ERROR converting image."
        Write-Host ""
    }
}

Write-Host "--------------------------------"
Write-Host "Finished."
Write-Host "Your original JPG/JPEG/PNG files were NOT deleted."