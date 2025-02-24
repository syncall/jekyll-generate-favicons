# Jekyll Generate Favicons

Want to keep your repository free from unnecessary amounts of assets?
Use this simple Jekyll plugin that generates common favicon formats from SVG files with ImageMagick.

#### 1. To enable, add the plugin into your Gemfile:

```ruby
group :jekyll_plugins do
    gem 'jekyll-generate-favicons'
end
```

Putting the Gem in the `jekyll_plugins` group will directly enable it in Jekyll. If it is not working (e.g., in safe mode), you might have to add it also in your `_config.yml` file:

```yaml
plugins:
  - jekyll-generate-favicons
```
    
#### 2. Define an `icon` and/or `apple_touch_icon` in your `_config.yml` to enable auto generation.

```yaml
icon: favicon.svg
apple_touch_icon: apple-touch-icon.svg
```

The plugin will search directly for the file or look it up under `assets/img`

#### 3. Include the generated files with a `favicons` tag in your html `<head>`:

    {% favicons %}

### Contributors

Feel free to open up a pull request if you want to extend the funcitonality!

### License

The repository is licensed under the [A-GPL 3.0](https://www.gnu.org/licenses/agpl-3.0.html) license.

The names of its contributors may not be used to endorse or promote products derived from this software without specific prior written permission.
