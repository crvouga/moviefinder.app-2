module [view]

import Html

styles : Str
styles =
    """
    html {
        font-family: \"Inter\", sans-serif;
    }

    /* Hide scrollbar for WebKit browsers */
    ::-webkit-scrollbar {
        width: 0px;
        height: 0px;
    }

    ::-webkit-scrollbar-track {
        background: transparent;
    }

    ::-webkit-scrollbar-thumb {
        background-color: transparent;
    }

    /* Hide scrollbar for other browsers */
    * {
        scrollbar-width: none;
        scrollbar-color: transparent transparent;
    }
    """

view : Html.Node
view =
    Html.style [] [Html.text styles]
