# Jekyll Generate Favicons

Want to keep your repository free from unnecessary amounts of assets?
USe this simple Jekyll plugin that generates common favicon formats from SVG files with ImageMagick.

Define an `icon` and/or `apple_touch_icon` in your `_config.yml` to enable auto generation.

    icon: favicon.svg
    apple_touch_icon: apple-touch-icon.svg

Will search directly for the file or look it up in `assets/img`

Include the generated files with a `favicons` tag in your html `{% raw %}<head>{% endraw %}`:

    {% favicons %}

### License

The repository is licensed under the [A-GPL 3.0](https://www.gnu.org/licenses/agpl-3.0.html) license.

The names of its contributors may not be used to endorse or promote products derived from this software without specific prior written permission.
