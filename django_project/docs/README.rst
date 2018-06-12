LEDET-BIMS documentation
==============================

## Technical documentation for LEDET-BIMS Project.

## Firstly you need to be in the right directory where the documentation
files are stored.

```docs/docs/```

**Then to generated the documentation or append to existing docs content Run
 **
```python manage.py listing_models --app someappmodels --output index.rst
```

Options
--app(-a)
You can pass specific app name. Listing only the specified app.

``` python manage.py listing_models --app fish
```
--output(-o)
It writes the results to the specified file.

```python manage.py listing_models --output index.rst
```
--format(-f)
You can choice output format. rst (reStructuredText) or md (Markdown). Default format is rst.

```python manage.py listing_models --format md
```




