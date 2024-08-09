module [view]

import Html

styles : Str
styles =
    """
    @import url('https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap');
    * {
        font-family: \"Inter\", sans-serif;
        font-optical-sizing: auto;
        font-weight: 700;
        font-style: normal;
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
    Html.style [] [Html.dangerouslyIncludeUnescapedHtml styles]
