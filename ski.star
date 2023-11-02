load("render.star", "render")
load("time.star", "time")

def main(config):
    resorts = ["vail", "breckenridge","keystoneresort","beavercreek","skicb"]
    displays = ["weather", "conditions","trails/lifts"]
    screens = []
    for resort in resorts:
        for display in displays:
            screens.append(
                render.Column(
                    children = [
                        render.Text(
                            content = resort
                        ),
                        render.Text(
                            content = display
                        )
                    ]
                )
                
            )
    return render.Root(
        delay = 2000,
        show_full_animation = True,
        child = render.Box(
            child = render.Animation(
                children = screens
            )
        )
    )