# wixl (msitools) docker image (debian)
```bash
docker pull darktool/wixl
```

# usage
Create .msi from .wxs:
```bash
docker run --rm -v .:/wix darktool/wixl input.wxs -o output.msi
```

Generate random UUID:
```bash
docker run --rm --entrypoint /usr/bin/uuid darktool/wixl
```

# notes
Other tools from GNOME `msitools` package are also available:
- `msibuild`
- `msiextract`
- `msiinfo`
- `wixl-heat`
