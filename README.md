# PDFNLT-1.0

original code: [https://github.com/KMCS-NII/PDFNLT-1.0](https://github.com/KMCS-NII/PDFNLT-1.0)

## Usage

1. Exec follow commands.

If you want to convert pdf files to xhtml files without images:
```
$docker run -v path/to/dir:/workspace ayasaj/pdfnlt-1.0
```

If you want to convert pdf files to xhtml files with images:
```
$docker run -v path/to/dir:/workspace ayasaj/pdfnlt-1.0 pdf2xhtml --with-image
```

