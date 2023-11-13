load("render.star", "render")
load("time.star", "time")
load("http.star", "http")
load("html.star", "html")
load("hmac.star", "hmac")
load("encoding/base64.star", "base64")

TITLE = "title"
WEATHER = "weather"
CONDITIONS = "conditions"
TRAILS = "trails"

BRECKENRIDGE = "breckenridge"
VAIL = "vail"
KEYSTONE = "keystone"
BEAVER_CREEK = "beaver-creek"
CRESTED_BUTTE = "crested-butte-mountain-resort"
WINTER_PARK = "winter-park-resort"
ARAPAHOE_BASIN = "arapahoe-basin-ski-area"
COPPER_MOUNTAIN = "copper-mountain-resort"
ELDORA = "eldora-mountain-resort"
ASPEN = "aspen-snowmass"
STEAMBOAT = "steamboat"

RESORTS = [BRECKENRIDGE, VAIL, KEYSTONE, BEAVER_CREEK, CRESTED_BUTTE, WINTER_PARK, ARAPAHOE_BASIN, COPPER_MOUNTAIN, ELDORA, ASPEN, STEAMBOAT] 
# RESORTS = [ ASPEN, STEAMBOAT] 

def main(config):
    displays = [TITLE,WEATHER,CONDITIONS,TRAILS]
    screens = []
    for resort in RESORTS:
        for display in displays:
            screens.append(build_screen(resort,display))

    return render.Root(
        delay = 5000,
        show_full_animation = True,
        child = render.Box(
            child = render.Animation(
                children = screens
            )
        )
    )

def build_screen(resort, display):
    data = get_data(resort)
    isOpen = is_open(data)
    logoBox = build_logo_box(resort)
    
    if display == WEATHER:
       return render.Row(
            expanded = True,
            main_align = "start",
            children = [
                logoBox,
                build_weather_screen(data,isOpen)
                ]
       )
    elif display == CONDITIONS:
        return render.Row(
            expanded = True,
            main_align = "start",
            children = [
                logoBox,
                build_conditions_screen(data ,isOpen)
                ]
       )
    elif display == TRAILS:
        return render.Row(
            expanded = True,
            main_align = "start",
            children = [
                logoBox,
                build_trails_screen(data, isOpen)
            ]
        )
    elif display == TITLE:
        return render.Column(
            expanded = True,
            main_align = "center",
            cross_align = "center",
            children = [
                logoBox,
                build_title_screen(resort),
            ]
        )

def build_logo_box(resort):
    # print(resort)
    logo = VAIL_LOGO
    if resort == VAIL:
        logo = VAIL_LOGO
    elif resort == BRECKENRIDGE:
        logo = BRECKENRIDGE_LOGO
    elif resort == KEYSTONE:
        logo = KEYSTONE_LOGO
    elif resort == BEAVER_CREEK:
        logo = BEAVER_CREEK_LOGO
    elif resort == CRESTED_BUTTE:
        logo = CRESTED_BUTTE_LOGO
    elif resort == WINTER_PARK:
        logo = WINTER_PARK_LOGO
    elif resort == ARAPAHOE_BASIN:
        logo = A_BASIN_LOGO
    elif resort == COPPER_MOUNTAIN:
        logo = COPPER_MOUNTAIN_LOGO
    elif resort == ELDORA:
        logo = ELDORA_LOGO
    elif resort == ASPEN:
        logo = ASPEN_LOGO
    elif resort == STEAMBOAT:
        logo = STEAMBOAT_LOGO

    return render.Image(
        src = logo,
        height = 16,
        width = 16,
    )

def build_title_screen(resort):
    title = "SKI RESORT"
    if resort == VAIL:
        title = "Vail"
    elif resort == BRECKENRIDGE:
        title = "Breckenridge"
    elif resort == KEYSTONE:
        title = "Keystone"
    elif resort == BEAVER_CREEK:
        title = "Beaver Creek"
    elif resort == CRESTED_BUTTE:
        title = "Crested Butte"
    elif resort == WINTER_PARK:
        title = "Winter Park"
    elif resort == ARAPAHOE_BASIN:
        title = "Arapahoe Basin"
    elif resort == COPPER_MOUNTAIN:
        title = "Copper Mountain"
    elif resort == ELDORA:
        title = "Eldora"
    elif resort == ASPEN:
        title = "Aspen Snowmass"
    elif resort == STEAMBOAT:
        title = "Steamboat"

    return render.WrappedText(
        content = title,
        font = "tom-thumb",
    )

def build_weather_screen(data, isOpen):
    temperature = data.find(".styles_h4__2Uc5w").eq(1).text()
    # print(temperature)
    temperatureSplit =temperature.split(" ")

    weatherIcon = render.WrappedText(
        content = data.find('.styles_iconWeather__R1V9M').children().eq(0).attr("title"),
        font = "tom-thumb",
    )

    highData = render.Text(
        content = "H:" + temperatureSplit[0] + "°",
        font = "tom-thumb",
    )

    lowData = render.Text(
        content = "L:" + temperatureSplit[2] + "°",
        font = "tom-thumb",
    )

    data = render.Column(
        expanded = True,
        main_align = "space_evenly",
        cross_align = "center",
        children = [
            weatherIcon,
            render.Row(
                expanded = True,
                main_align = "space_evenly",
                children = [
                    highData,
                    lowData,
                ],
            ),
        ],
    )

    return data

def build_conditions_screen(data, isOpen):
    summit = "-"
    base = "-"
    if isOpen:
        summit = data.find("[title='Summit']").parent().find("figcaption").text()
        base = data.find("[title='Base']").parent().find("figcaption").text()


    baseData = render.Text(
        content = " Summit " + summit,
        font = "tom-thumb",
    )

    forecastData = render.Text(
        content = " Base " + base,
        font = "tom-thumb",
    )

    return render.Column(
        expanded = True,
        main_align = "space_around",
        cross_align = "start",
        children = [baseData,forecastData],
    )

def build_trails_screen(data, isOpen):
    trails = "-/-"
    lifts = "-/-"
    if isOpen:
        trailsSplit = data.find("[title='Runs Open']").parent().find("figcaption").text().split(" ")
        trails = trailsSplit[0] + "/" + trailsSplit[2]

        liftsSplit = data.find("[title='Lifts Open']").parent().find("figcaption").text().split(" ")
        lifts = liftsSplit[0] + "/" + liftsSplit[2]
    # print(trails)

    trailsData = render.Row(
        expanded = True,
        main_align = "space_around",
        cross_align = "center",
        children = [
            render.Image(
                src = SIGN_POST,
                width = 10,
                height = 10
            ),
            render.Text(
                content = trails,
                font = "tom-thumb",
            )
        ]
    )

    forecastData = render.Row(
        expanded = True,
        main_align = "space_around",
        cross_align = "center",
        children = [
            render.Image(
                src = CABLE_CAR,
                width = 10,
                height = 10,
            ),
            render.Text(
                content = lifts,
                font = "tom-thumb"
            )
        ]
    )

    return render.Column(
        expanded = True,
        main_align = "space_around",
        cross_align = "center",
        children = [trailsData,forecastData],
    )

def is_open(data):
    open = data.find(".styles_open__3MfH6")
    if open.len() == 1:
        return True
    else:
        return False


def get_data(resort):
    url = "https://www.onthesnow.com/colorado/" + resort + "/skireport"
    
    response = http.get(url)
    if response.status_code != 200:
        fail("Webpage down")

    return html(response.body())

VAIL_LOGO = base64.decode("""iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAA0lBMVEUAAAAAcM8AbNEAbNAAa9IAYN8AbNEAbNEAbNEAa9EAbNEAbNAAZswAbNEAbdEAbNEAbNEAbNEAbNEAbc8AbdsAa9EAbNEAbNEAbNIAbNAAZswAbNAAgL8AccYAbdAAbNEAbNIAatUAbNEAbNEAcdUAgNUAbNEAbs8AbNEAcMwAbdEAVaoAbNEAbNEAZswAbdEAbdEAdtgAbNAAbNAAbdEAbNEAbNEAbdAAbdEAbNIAbNEAbNEAbNEAbNEAa9EAbNEAbdEAa9AAbNEAa9EAatMAbNFj5tILAAAARXRSTlMAIK3bmAhC7KZw/HgFoNFjp/79SweyrHvxRwq6BAlzu4IMts4SBsElIRm8A9LGFHqPDVeOt07wYqJJasKa+mnpPZ/gqx2QyAZ5AAAAAW9yTlQBz6J3mgAAAKNJREFUGNN1j2sTgVAQhl+VUEJJqFwrIeR+v3P+/19yzhkz9YH9tM8zu7P7Ar8rI4hSNsVyjhCST7igEFbqF4taqVzRqTCqnM2aZQJ1NtJoUrYdyZVbgMaM3gY63V6feD6CARViOEQ48mg3juBPyHQWO4DKL8yBxdJcrekyNltmdoC7FwJ+52BQoRzl0zn6fhLzrcs1edWifLunstiP5+v9J/cHd7cXyRaEPDoAAAAASUVORK5CYII=""")
BRECKENRIDGE_LOGO = base64.decode("""iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAA6lBMVEUAAADdESLWGiD/AAAAVYAATIFEQzlFQzlFQzlERDrXGSHXGSHXGCAAToIATIAATYBERDxEQjlFQznXGiLXGSH/AAAASoAATIAATIAAgIAAAABFQzpFQzjYGSDWGSEATIAATICAgABFQzlFRDnTGiMATIAATIBFQzpFQzlJSUnJHChGQzpFQzlFQzlFQzozMzNGRDhFQzlCQjpFQzlFQjlFQzlFQzlERDdFQzlFQzlVVVVFQzpFQzlVVStFQzpERDhEQjhEQzlNTTNFRDpGQTdFRDlFQjlDQzdFQjpFQzhEQjlFQznXGSEATIBM+BirAAAAS3RSTlMAD3YCDEOZ4ONPocQgMeSFHmzPWsoBPvTjAgHr0Eg+q7wC9pNu8bhzyweAVPnUXAVx/h+BwPu2POn1A4X4BsNEf9gKzDOi0y5dkXDG6dGLAAAAAW9yTlQBz6J3mgAAAJdJREFUGNNVztUOwlAQRdGDF3fX4l68SIHiMrf//zuUJg3DPE1WcpINh9MF89wer0/yfz8EgiEgHInG4pSwIClS6Uw2l0ehWLKgLESlatQAud6wodky2kCn27Ohb5gwGI7GCoPJlIik2Q/mi6UpKzaBuibabBlgR6TtOahEBz7BkUj/A51OZw7KRbvyMPl2f/DS5+ttlX8AkOskmhkxkkEAAAAASUVORK5CYII=""")
KEYSTONE_LOGO = base64.decode("""iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAABYlBMVEUAAAD/AADmJgXmJgTkJQTmJgDmJQPkJQTlJgTmIwTmJQTlJQTlJQTmJQTkJgTmJgblJQTlJAPlJATlJQTlJQPlJQTlJQTlJgTlJgTlJQTlJATnJgPmJQTlJQTnJADpIQDkJQXlJQTlJAPlJQTkJAPlJQTmJQPmJQTlJATMMwDmJgXlJgXlJQTmJQTkJQTmJQXmJQTlJQTkJQXkJATmJAXmJQblJQTlJQTlJQXnKAjbJADlJQPlJQTlJQTkJADlJQTmJQPlJgPlJgPlJAXoIwb/AADlJgXlJQTlJgTlJQTjJgPoJgPkJgPlJQTmJgTnJATnJAbkJQXlJgTlJQPlJgTlJQTlJQTjJgDkJQXoIwDlJAPlJQXlIwXlJQTmJATmJQPiJwDlJQPlJQTlJAXlJQXmIgTlJAPjIgflJgPkJQTlJQXmJAP/AADkJQPlJQTjHADmJQPkJQTqIADiJAfmIwXlJQRqQG3KAAAAdXRSTlMAA2Z6wBRTkLdIhLLyyHMoik1//Z/++4eI5MRK8MEVF2D3k5FU15b6vQVkqYmQrJe/72iFMinpxqQgB57t1Bz2WpWbaiwF4Ot/+ZRXX/E8Pyowxd7u9cIbZxab4m1Fhdwa29Wp4TxOJVjTpV0BmbgJmI8YIzOCraSDAAAAAW9yTlQBz6J3mgAAAMdJREFUGNNjYIAARiYGVMDMgmCzAuXZ2JEEODgZuLjZeXh5+fgFBEECQsIiomLiEpJS0jKyciABeQVFJWUxFVU1dQ1NsBYtbR1dPX0DQyNjRROwgGmpmbmFpZW1kJmNLStIwM7ewZiXgcFR2MnZxRWowa3U3cPTS1xLyduntNTXj4HBPyAwKFiwlD2kNDQsnC0CqCUyyjM6JkQiNi5eB+a0hMSkZNHSlNQ0mEC6cEZmFqdidg5MIDcvP5yBoaAQ7psiMFlcAiIBwtkg21yfDUAAAAAASUVORK5CYII=""")
CRESTED_BUTTE_LOGO = base64.decode("""iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAAaVBMVEUAAAClGi6mGS6mGS6mGS6mGC6qAFWlGS2oFiymGS6mGS6mGS+nGC2ZADOAAACmGC6mGS6lGS6zGjOqHDmmGi6lGS2qKyujHCumGS6mGS6nGDCmGS6mGi6lGi2nGiymGi6lGi2nGS+mGS6MxGZYAAAAInRSTlMAgOjJ6rEDWyP7+LprBQJq/qIKCcjKBiT57iDC8EQd0mxodrO4dwAAAAFvck5UAc+id5oAAABSSURBVBjTY2AgHTCiAQYlNIAQYGJmQRFgZWPn4IQLcHHz8DLw8QvABASFwOYLi0AFRMWgNopLgAUkpeBukAYJyMgiHCUnr8SgIIXsTGFFMvwGAGaQCzK47kmFAAAAAElFTkSuQmCC""")
BEAVER_CREEK_LOGO = base64.decode("""iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAABC1BMVEUAAABeb4Bcb31ccHxccHxabnxdcHtcb3xbcHxcb31dcXxdb3xccXtcb3xecH1bcHxccHtccHxccHxdcHxccHxccHxccHtccHxccHxdcXxccHxbbXlccHtdb31ccHxccXtccHxdcXxdcX1bcXtccHxdb3tbcHxbcHtcb3tbcHxccHxcb3xdcHtdb3tccHtccXxccHxccHxdcH1ccXxccXxccH1ccXxccHxccHxcb3xZb3pbcHtccHxccXxccHxcb3xZc3lccHxbcHxccHxdbntccHxbcHtccHxccHxccXxbcXtccHxccnxcb3xccHxccHxbcHxdcX1bcX1cb3xYcnteb3qAgIBVcXFccHxK9NDoAAAAWHRSTlMAHl6CpiWdtYaFjIy8njm7dNH14un82/PKccQquofAk6nMWFFpfmu4U6Kxzna+m4iYoGCj3o3Fwpa3F99QishnKPnG/mblcICvb3jWd3XYv4SBgccdLgIJfyUEwgAAAAFvck5UAc+id5oAAAC8SURBVBjTY2AgCjAyMbOwMDMxQrmsbOwcnFzcnJw8vKwgPh+/gKCQsIiomLiEpBQfA4O0jKycvIKikrIAi4qcqpw0g7xahKx6hIamlkaEtk6EijyDrl6EPruBiqGRcUSESYSpGYO5RYS+pbkVr7VNBBDY2jHI20cIWEZoWAo5ODo6ObvIM0jLqbq6uXtIa3hqeXn7OEkDrTXzNXP2ExESFNb1VeQDO4zXPyCQgyMoIJiXNSQUzelh4YQ9CgCNkRqnTJVi7gAAAABJRU5ErkJggg==""")
CABLE_CAR = base64.decode("""iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAA7xJREFUWEflVkkspGEQfW2Pfd+XiH0NLjSxXDhJOJIQF5wlEtyQOHCQcOYiJBxJnMTBEsEFsa+h7YJYInZ68mrSPW38pDF6JplKOv33/339vVf1Vb0qFQAtvmClpaVoamqSE6qrq9He3v6h01TGEvDx8UFeXp4c3tfXh4ODA7i7u2NgYACJiYnyfnp6Gjk5OTg5OTGahFEErK2t0dbWhuLiYjm4s7MT9NzBwQGDg4NISEiQ9zMzM8jOzv7zBHx9fTE0NISwsDABWltbQ1ZWFvb391FQUICamhp539jYiJ6eHkXvLSws4OzsjICAAERFRcHPzw9jY2P4dATKyspwd3cHlUoFV1dXaLVanJ2dybeZmRmcnJwEJDw8HHFxcfLhs7+/PxwdHWFubo7t7W3jCNAl5kB+fr4A9Pb24vDwUDwlATs7O1knQGxsLOLj4xEZGSneuri4gN4r2YcI6A5gPhAsNDQUMTExAhYdHY2goCC4ubnByspKEez5+RlXV1eSvLzC2dlZ9Pf3vx8BGxsbeHh4IDg4WEB0YPzt6ekJrisZo3R9fY2joyNsbGxgfn5eAJeWliTsp6enuL+//xlBXRmSOe+SnjBJCMZwhoSEwMvLC7a2thJuJWMuEGxzcxOLi4sCtrCwgK2tLRwfH+P29vbNslSp1Wptbm6uADLLGV57e3tJJCUjc9Y575VRoFF8GhoaBOzm5kbyxFhTaTQabWBgoOL+x8dHyeydnR0sLy9jbm5OPnwuLy9HVVWV/K+urg719fXGYr7Ypyfw9PSEy8tL7O7uYnV1VQ/G5729PVnjHp0RtLa29usEUlNTtWlpaQJCz5gk9NoQTMm1P0bg915gaWkp5cRye8tIrrKyEhUVFbKlpaUFzc3NIi5vGXPHMPt1+14oYXJyshyalJT0LgH+mbJKtaOdn5/j4uLi3RxgpUxNTaG1tRUTExP6vXoCKSkp6OrqkrL7TqMuFBUV6UkIAYa9o6MDhYWF34mtP7u7uxslJSV4eHj4KUTe3t7S7SIiImQTw8mwGpphyL+6vrKyIt2U/UQIUAdGRkZEBVlu7HTj4+N6MaKOq9Vq/bTDWeAz65wp2Ak1Gg0yMjJ+dUMCDw8PCwEuZmZmyrehcW10dFRepaenf2qdTtJZQwyJgKkIKDn5fxEw6gpMlYS6PHt1BaYow3eT0BRK9O8RMBQiU0XghRD9LsXfTeKVFP/1ZkSPOQuwHXPe/05bX1+Xdjw5OSkwLwYS1ibnPDaet2b+z5LjaM4GxuGVkqyzH+8Ypb5i1G8xAAAAAElFTkSuQmCC""")
SIGN_POST = base64.decode("""iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAAhxJREFUWEftVzmKKlEUPeUAFkaiYCDqDgQ3oJlLECNBcAfOgZGB4xIEwUhcgpluQHAHKgaKYiQKDtWc96lqbdqh6ndr0/RNXgX3nnveHV9JABQYkGQyiWq1KixzuRyazaYBFEBSCUiSBKfTCbvdfhNIURQ4HA60220EAgGhOxqNEI/HsV6vQZxrcjgcsFgssN/vNRWNQCwWQz6fF+B0ckssFgvcbjd4Ugg8n8/FeUuOxyNarRYajQZ2u51QFQRcLhd6vR6CwaChMOoxomOmrlKpCBKCgM/nw2AwgN/v14NlWJeOSaBWq/0jQMf9fv9pBMh8u92iWCz+EAKvSEG5XEa9Xv8hRcic6GlDo9V3tQ1FPz44iFTnp9PpgofJZLrLiwQ4Lz4dRHetzxTMZrMYRDwpKjBPvaJNQj2GHo8H3W4XXq9XmE2nU0SjUcxmMz0w75NQtbJarRc3+wyNoadjEiARCh2TAIncS8Vms8FqtdLGvRYBm82GdDqNRCKhhfbadYzuAtYZFxanYKfTeY8AnXMRca3y+7tlOBwiEolguVxCkmVZyWazgsAznPNy4/EYoVAIk8kEUiqVUkqlEmRZ/u6La/gkEA6HBZHXE2AKMpkMCoXCa1LAdczcswCfVQcXRai+CfW0odFiudqGegbR/+wC2l4dRHpu9Xt3waNR+PiGPO/rRzFUPUPb8I/AXwQ+/sqdT7anFCGdfNXv+Rsoznj4X4UMDgAAAABJRU5ErkJggg==""")
ELDORA_LOGO = base64.decode("""iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAABtlBMVEVHcEznUwDnVADnUwDmUwDnUwDnUwDVVQDjVQDnUwDnUwDoUQDkUgDnVADnUwDjVQDnUwDnUgDnUwDnUwDnVADnUwDnUwDnUgDnUwDmUQD/VQDnUwDoUwDnUwDnUwDnUgDnUwDoVAD/gAD/QADnUwDpVADoUgDpUQDoUwDnUwDmVADoXQDoUQDnUwD/AADnUgDmUwDmUwDmUwDnVADkUQDnVQDmUgDnUwDqVQDnUwDnUwDnUwDnVADnUwDmUwDnUwDnUwDnVADoUwDnUwDoUwDnUwD/ZgDnUwDnVADnUwDnUgDoVQDoUgDnUwDoVADoUwDnUwDnUwDnUgDmUwDqUwDnUwDoUwDnUwDfUADnVADnUwDmVADmUwDnUwDmUwDoUwDnUwDnUwDnUwDmUwDmUwDmUQDnUwDpUwDoUwDnUwDoUwDmUwDnUwDoUgDoVADmUgDmVQDmTQDlVQDoUwDnUgDkUQDnUwDmWQDmVADoVADnUwDtWwDnUwDnUwDnUwDoUwDnUwDnVADmUwDnVADnUgDpVQDnUwDuVQDmUgDnUwDnUwDnUwDhWgDlTwDmUwDoUgDrTgDnUwDtZFa+AAAAkXRSTlMA47HIUN/gBgni/RYcQPQSacDNVnTb/snnKQP1N62TS51kAgSiOmMvYuxbCyyNAZVcpZHlExVd1hhr9vuJ+bvU3uiv05qpBbhqx2AhWupPbtWXVMUlys+WELRsUnGfZW/6vMume0jXIo6y77C/V66FPAono54m6RS6Q6AO8vfmhPCS0EmhOfMPPqr80hEd2m0ayJ2+fgAAAaNJREFUOMttk/VDQjEQx09Q5IGICIoYWJQgoGB3d3d3d3d36/5j9+QtEO6n731u28U2AGoD3WnymtiUKKPMkAshFh2XgDgTDMrgeIcC/TO/gwtnuVEYa8gm8eQ6Cou1hVHUqYqWFlSwXX0ARcwzB+KRjCSOAMRwWcb/6o9gwCuCfK6ZJuxnUvdo+y+pciWHojbsk/437KwtzZwEewBMZLGVn8sioe3QQqQNIHtHjYtMTeby2qCRyEuL7AIVACyjtbRVWoQFjPzwzsTj13miAzY49OTdFRecH6QwVg2xRMofPfRu0pcITYIyIl/4Luh0I4DOMQ/zXFxkyR4WDkLjYYjIm9uHK4TbPERCxr6K0GaQ8TW/isef8GQYJpjzlv8sLjjeUjGmBzuRd/f0GbqcArl/NXjIazwN10U/1mOS3sQ65gOgsAQLpwTTxevvDOica18x0oib393mGdKkaHlc0ZqgF1iZGkiYwVARwDfzSqWKlDqKvn4+/dTxsX83GebflMfxbU0l/Y/LrcGf07UgcFFVa1fo/wbT9Pxsfa1icLRXr2X0F1R8WZU8Pm0VAAAAAElFTkSuQmCC""")
A_BASIN_LOGO = base64.decode("""iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAkNJREFUOE+Vk11Ik2EUx39vTJORMSWl6APCC+0ip4IlUTAzApFCicRW5IUzamvWRYWzLiaJUIZgqaUtPyIjIawgi6GCERlWIm1iaCg1y8zlR5ut5cfe2CtsDl3Qc/ecc57fec7/nCMQ7CjzRURx0WsxCcHCgjqI14gRa+XIZDLsneX/AYjXSGnDQkMwag/y4t0Azzst0F+3ImSZMXLPGdEx85uT2SpK9Vnorzyg7XU/TpcbZ9eNZfF+w/Y8MXbrBo5lpGD5+IVKg5royHDsk04Gbd85VdKEdXAErHcCIL6LN7PJmEvSti3ML3iI2RQl6eZyz3K2rJn6x68IDZEhCAKzc/PM9dyS3i4ClPliiS4TgyadVYI/gccjUtZgpuh6CwdUCZzL3c+ofRpDRQvDI3awmhajw5K1Ymulnr074gK69bCthxPFd5mankGrTpPKKms0U3G/g7EfP/H01gYHvOn7hLrwNhujFQzaxslMTaC6SM1X+zTVzZ1crTez0FuzMmBkbBJ1oYm31mGOZKTQ+tLKoX1J3Lx4lI7uDxy/VMdo+zW/BktLcP5yoytt4lFHL+ujFJKgn79NoM1WoctRkXOhFsuAvxs+DZ5VFZCaHEtxzVPKG81cPp1FVloi4xMODp+vITFuM+sUa7jX2o2ru8qndADAPuVEY2zEO4q7lDHSNLpn5+h6P4S3I+Hy1Thdf5YD5Dt1oiEvnYYnXQzZxsErjccDEkqAvsDhWdoq31cidheIUw7XPzdvpY0Mvo1B9zzQ8ReLQPIRRnGFwQAAAABJRU5ErkJggg==""")
WINTER_PARK_LOGO = base64.decode("""iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAAIGNIUk0AAHomAACAhAAA+gAAAIDoAAB1MAAA6mAAADqYAAAXcJy6UTwAAAD5UExURQAAAAAAAAYBARACBBgEBhwEBxcEBQ8CAwUBAQQBATwKDm8SGpAXIqQaJ7AcKrQcKq8cKqMaJ40WImwRGjcJDQIAAQkBApgYJNAhMc0hMcwgMMseLs0oN80mNosWIW0RGs0gMckeLsoiMtdXY+65vu2yuNZQXcogMMoeLl4PFjoJDsQeLtJBT+mgp/zv8P////rr7eeYoNI9S78dLC8HCxIDBLdsc/3k5u/x8Pn5+fzf4qtjaQsBAnN0dKaoqFBQUNbW1snJyfLy8v39/dra2szOzmZmZgsLCwgICA8PD0VFRTAwMMTExH9/fx8fHwkJCQoKCiEhIQICAgRRmdwAAAABdFJOUwBA5thmAAAAAWJLR0QvI9QgEQAAAAd0SU1FB+cLDRIhL3rDN/IAAACTSURBVBjTY2DABIxIAMplYmZhZWVj5wALMXJycfPw8vHzCwgKCYuIAgXExCUkpaRlZKWlJCXkOIECjPIKikrKKqpq6hpSmiBTGLW0dXT19PUNDI2MTcCmmpqZW1jqA4GVtQ3EGls7ewdHJ2cXVzewvQyM7h6eXt4+vn6e/owIhwUEBkEdhuJUBhwCDOh8mAgDVgAA1iAPbTv569UAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjMtMTEtMTNUMTg6MzM6NDYrMDA6MDB7TNvEAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDIzLTExLTEzVDE4OjMzOjQ2KzAwOjAwChFjeAAAACh0RVh0ZGF0ZTp0aW1lc3RhbXAAMjAyMy0xMS0xM1QxODozMzo0NyswMDowMPtzSRMAAAAASUVORK5CYII=""")
COPPER_MOUNTAIN_LOGO = base64.decode("""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""")
ASPEN_LOGO = base64.decode("""iVBORw0KGgoAAAANSUhEUgAAAB4AAAAgCAYAAAAFQMh/AAAAAXNSR0IArs4c6QAAAkxJREFUWEe1VkmqMjEQTjssdKM4oYhLd+IdBM/gMfQI4hH0GJ5B8AyKO8GNgmOLbhSc8qg80q/SL91J1/v/Bm0llfpq/KocRnz2+z13HIeVSiWHooJ0CYBc1+XwzufzJB2kS6fTicdiMeEo55wETgIGbyHMCBh+RtIVSViGWILi3OZyuUi6IgnjEPsL6vP5sEKhYK3PSnA6nfJms8mwp9frVWBnMhnFhtlsxlqtllGvUWC32/FkMqmA4oI6Ho88Ho8r4I/Hg5XL5VDdoYegFKoXF9J2u2WNRkO5t1gseKVSUeQg9MViMVB/4IE/nzY59N8Ja7VfwLp8vt/vUOtxnA+HA08kEsa8K8C6fIKGqK0iWQ2n6Pl8Knn3gHWeDodDNhgMjAWo4+p+v897vZ53BGGfz+dexXtK/wUN6gzQsJzAFF9Bh5SpYwKXqfsF/Hq9yKMuyFAYocAFeKgowNRJYxMZHFUoVgczj02v2oDoZPw9rgBH6deoBvgddMbjMW+3238a6jZG4FCvVqvvqj6fz2KNgWcymbBOp0Pq3SADoKe73a7H5SLHfuD/kWfsmNQvPeOu6yqjD/7X6/U/ea6bWqPRSLChp1hH7tBe8ICVl8vFaMhyueTZbJbJRVAw1A8Ew8WreLTZbHg6nQ6sFWyInLVgsFwEdLuYVHa/31m1WvXwtKG0UQZGwAd7hy3WGYnPjTlcr9c8lUqJkJmApMztdmO1Wo2++tgQvpSJOrONHpvoj9p+JGA8bag0SwLGNGu7R/sjRwKWy4NphQ3j8C/NjG8fupgvLAAAAABJRU5ErkJggg==""")
STEAMBOAT_LOGO = base64.decode("""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""")