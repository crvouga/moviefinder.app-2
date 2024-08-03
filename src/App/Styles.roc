module [view]

import Html

scrollbarStyles : Str
scrollbarStyles =
    """
    ::-webkit-scrollbar {
        width: 0px;
        height: 0px;
    }

    ::-webkit-scrollbar-track {
        background: #000;
    }

    ::-webkit-scrollbar-thumb {
        background-color: #fff;
        border-radius: 0px;
        border: none;
    }

    ::-webkit-scrollbar-thumb:hover {
        background-color: #fff;
    }

    * {
        scrollbar-width: thin;
        scrollbar-color: #fff #000;
    }
    """

view : Html.Node
view =
    Html.style [] [Html.text scrollbarStyles]
