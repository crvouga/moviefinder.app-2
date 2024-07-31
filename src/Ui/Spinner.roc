module [view]

import Html.Html as Html

svg =
    """
    <svg xmlns='http://www.w3.org/2000/svg' fill='currentColor' stroke='currentColor' viewBox='0 0 24 24' class='size-12 animate-spin'>
      <path
        fill-rule='evenodd'
        d='M12 19a7 7 0 100-14 7 7 0 000 14zm0 3c5.523 0 10-4.477 10-10S17.523 2 12 2 2 6.477 2 12s4.477 10 10 10z'
        clip-rule='evenodd'
        opacity='0.2'
      />
      <path d='M2 12C2 6.477 6.477 2 12 2v3a7 7 0 00-7 7H2z' />
    </svg>
    """

view : Html.Node
view = Html.dangerouslyIncludeUnescapedHtml svg
