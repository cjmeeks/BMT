// pull in desired CSS/SASS files
require( './styles/main.scss' );
//require( './styles/Bmt.css');

// inject bundled Elm app into div#main
var Elm = require( './Main' );
Elm.Main.embed( document.getElementById( 'main' ) );
