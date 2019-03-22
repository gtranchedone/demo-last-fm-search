# LastFM

This is an project developed by [Gianluca Tranchedone](https://twitter.com/gtranchedone) for an coding interview test.

## Notes on the development of the project

Although most of the project is tested using `@testable import`s, the project tries to respects the principle of only testing public interfaces as much as possible. Therefore, classes like `AlbumsViewModel` is not tested by itself, as it's an implementation detail of the `AlbumsViewController`.

To keep the development of the project within a reasonable timeframe I had to make some tread-offs. The most noticeable are:

- The app only searches for albums, and only displays albums. It doesn't offer distinct results for albums/songs/artists.
- The navigation flow of the app is very basic and has been implemented using Storyboards.
- The UI implementation is very basic, and `AlbumCell` contains most of the layout logic itself.
- Tapping on an Album's track opens the lastfm.com URL for the track instead of playing it.
- Images loaded via URLs are not decoded before being presented in the UI, which impacts performance.
- `AlbumTracksViewModel` and `AlbumDetailsViewController` are implemented and tested with the assumption of the views being set up using Storyboards.
- Some names of classes, methods, and protocols, are not "great".
- The app has no app or other imagery, besides what's required by the specs.
- There's only one UI Test, and it's very basic. Most importantly, it uses the default Services of the app which means using an Internet connection to load data and images. This can be easily fixed using launch arguments, but that would require more time and it's not critical, in my opinion, for a demo project like this.

## Set up

The project has no external dependencies. You can just open the project and run it.

*__If you cloned this project from a Git repository like GitHub, pay attention to the notes below!__*

### Environment

Before you can compile the project, you have to create an `Environment.json` file in the root folder of the project that follows the example set in the provided `Environment.example.json`. In fact, you're better-off copying the example json file and replacing the values in there with the correct values for your environment.

NOTE: `Environment.example.json` is used to run UnitTests, so don't delete it! 
