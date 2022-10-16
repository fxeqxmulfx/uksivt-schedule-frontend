<script lang="ts">
    import {location, push} from 'svelte-spa-router'
    import {backend} from "../store";
    import {pullTheme} from "./Utils";

    let buttons = []

    if ($location.endsWith("college_group")) {
        fetch(`${backend}/api/v1/college_group`).then(value => value.json()).then(json => buttons = json)
    } else if ($location.endsWith("teacher")) {
        fetch(`${backend}/api/v1/teacher`).then(value => value.json()).then(json => buttons = json)
    }

    function navigate(path: string) {
        if ($location.endsWith("college_group")) {
            push(`/college_group/${path}`)
        } else if ($location.endsWith("teacher")) {
            push(`/teacher/${path}`)
        }
    }

    const theme = pullTheme()
</script>

<main>
    {#each buttons as button}
        <button class="{theme !== 'dark' ? 'button' : 'button button-dark'}"
                on:click={() => navigate(button)}>{button}</button>
    {/each}
</main>

<style>
    main {
        display: grid;
        grid-template-columns: 1fr;
        grid-gap: 0.4rem;
        padding: 0.3rem;
    }

    @media screen and (min-width: 400px) {
        main {
            grid-template-columns: repeat(2, 1fr);
        }
    }

    @media screen and (min-width: 600px) {
        main {
            grid-template-columns: repeat(3, 1fr);
        }
    }

    @media screen and (min-width: 800px) {
        main {
            grid-template-columns: repeat(4, 1fr);
        }
    }

    @media screen and (min-width: 1000px) {
        main {
            grid-template-columns: repeat(5, 1fr);
        }
    }

    @media screen and (min-width: 1200px) {
        main {
            grid-template-columns: repeat(6, 1fr);
        }
    }
</style>
