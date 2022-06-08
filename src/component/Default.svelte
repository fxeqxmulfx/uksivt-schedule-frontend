<script lang="ts">
    import {push} from "svelte-spa-router";
    import Cookies from "js-cookie";

    const collegeGroup = Cookies.get("collegeGroup")
    const teacher = Cookies.get("teacher")

    if (collegeGroup != null) {
        push(`/college_group/${collegeGroup}`)
    } else if (teacher != null) {
        push(`/teacher/${teacher}`)
    } else {
        push("/college_group")
    }
</script>