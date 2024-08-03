module [view]

import Html
import Ui.BottomNavigation
import Ui.Icon
import Route

Selected : [Home, Account]

view : Selected -> Html.Node
view = \selected ->
    Ui.BottomNavigation.view {
        selected,
        target: "#app",
        actions: [
            {
                href: Route.encode (Feed Feed),
                icon: Ui.Icon.home,
                label: "Home",
                value: Home,
            },
            {
                href: Route.encode (Account Account),
                icon: Ui.Icon.userCircle,
                label: "Account",
                value: Account,
            },
        ],
    }
