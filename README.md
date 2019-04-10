# xml-cv

CV and resume generating tools

## Supported formats

- [OpenDocument](https://en.wikipedia.org/wiki/OpenDocument) (`.fodt` files for use with [LibreOffice](https://www.libreoffice.org/) and other compatible applications)
- Plain HTML
- [Markdown](https://en.wikipedia.org/wiki/Markdown)

### Additional tools

- LinkedIn helper (HTML)
- Basic term extractor (Plain text)

## Requirements

Any [XSLT 1.0](https://www.w3.org/TR/xslt-10/) processor that supports the `date` and `math` [EXSLT](http://exslt.org/) extensions.

The provided `Makefile` uses `xsltproc` and `xmllint` from [Libxml2](http://xmlsoft.org/).  Other Linux utitities include `mkdir`, `sort` and `uniq`.

## Basic usage

Using the provided `Makefile`:

1. Place an XML-CV `.xml` file in the `in` folder.
2. Use `make` to generate output files in the `out` folder.

The rendered files will be located in `out/final/`

An example XML-CV file is provided in the `in` folder.

### Examples

Make all possible formats

```console
$ make all
```

Make only OpenDocument files

```console
$ make fodt
```
