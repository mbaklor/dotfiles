gc buckets.txt |% {scoop bucket add $_}
gc apps.txt |% {scoop install $_}
