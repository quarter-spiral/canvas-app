# Canvas::App

An app to deliver the games within our canvas.

## API

All requests respond with fully flexed HTML pages.

### Retrieve a game

#### Request

**GET** ``/games/:UUID:``


##### Parameters

- **UUID** [REQUIRED]: The UUID of the game to display

##### Body

Empty.

#### Response

##### Body

An HTML page with the canvas that embeds the game.
