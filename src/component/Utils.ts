import Cookies from "js-cookie";

export function pullTheme(): string {
    const theme = Cookies.get("theme") ?? "white"
    if (theme === "dark") {
        document.body.classList.add("body-dark")
    } else {
        document.body.classList.remove("body-dark")
    }
    Cookies.set("theme", theme, {expires: 7})
    return theme
}
