<script lang="ts">
    import Router from 'svelte-spa-router'

    import Home from "./component/Home.svelte";
    import Default from "./component/Default.svelte";
    import Switch from "./component/Switch.svelte";

    const routes = {
        "/college_group/:collegeGroup": Home,
        "/teacher/:teacher": Home,
        "/college_group": Switch,
        "/teacher": Switch,
        "*": Default,
    }
</script>

<Router {routes}/>