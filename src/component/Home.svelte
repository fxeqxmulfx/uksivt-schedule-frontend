<script lang="ts">
    import {backend} from "../store";
    import {push} from "svelte-spa-router";
    import Cookies from 'js-cookie'
    import {afterUpdate} from "svelte";

    export let params: { collegeGroup: string | null, teacher: string | null } = {}

    let fromDate = startWeek()

    function startWeek(): Date {
        const date = new Date()
        if (date.getDay() === 2) {
            return addDays(date, -1)
        } else if (date.getDay() === 3) {
            return addDays(date, -2)
        } else if (date.getDay() === 4) {
            return addDays(date, -3)
        } else if (date.getDay() === 5) {
            return addDays(date, -4)
        } else if (date.getDay() === 6) {
            return addDays(date, -5)
        } else if (date.getDay() === 0) {
            return addDays(date, -6)
        }
        return date
    }

    let nextWeekWorkedOut = false

    if (new Date().getDay() === 0 && !nextWeekWorkedOut) {
        nextWeek()
        nextWeekWorkedOut = true
    }

    let days = {1: [], 2: [], 3: [], 4: [], 5: [], 6: []}

    function fetchData() {
        if (params.collegeGroup != null) {
            fetch(`${backend}/api/v1/college_group/${params.collegeGroup}/from_date/${formatDate(fromDate)}`)
                .then(value => value.json())
                .then(json => days = json)
        } else if (params.teacher != null) {
            fetch(`${backend}/api/v1/teacher/${params.teacher}/from_date/${formatDate(fromDate)}`)
                .then(value => value.json())
                .then(json => days = json)
        }
    }

    fetchData()

    function formatDate(date: Date): string {
        return date.toISOString().split("T")[0]
    }

    function getDayValue(days: any, dayNumber: number): any[] {
        const value = days[dayNumber]
        if (value != null) {
            return value;
        }
        return []
    }

    function getDay(number: number): string {
        if (number === 1) {
            return "Понедельник"
        }
        if (number === 2) {
            return "Вторник"
        }
        if (number === 3) {
            return "Среда"
        }
        if (number === 4) {
            return "Четверг"
        }
        if (number === 5) {
            return "Пятница"
        }
        if (number === 6) {
            return "Суббота"
        }
        return "Воскресенье"
    }

    function addDays(date_: Date, days: number) {
        const date = new Date(date_.valueOf())
        date.setDate(date.getDate() + days)
        return date
    }

    let touchstartX = 0
    let touchendX = 0
    let startTimeSwipe = 0
    const body = document.body
    const allowedTime = 300

    body.addEventListener('touchstart', e => {
        touchstartX = e.changedTouches[0].screenX
        startTimeSwipe = new Date().getTime()
    })

    body.addEventListener('touchend', e => {
        touchendX = e.changedTouches[0].screenX
        if (new Date().getTime() - startTimeSwipe < allowedTime) {
            handleGesture()
        }
    })

    function handleGesture() {
        if (touchendX - touchstartX < -100) {
            nextWeek()
        }
        if (touchendX - touchstartX > 100) {
            previewWeek()
        }
    }

    function nextWeek() {
        fromDate = addDays(fromDate, 7)
        fetchData()
    }

    function previewWeek() {
        fromDate = addDays(fromDate, -7)
        fetchData()
    }

    let countCall = 0

    function moveToDay() {
        ++countCall
        if (countCall === 2) {
            const day = new Date().getDay()
            const elementId = document.getElementById(day.toString())
            if (elementId != null) {
                elementId.scrollIntoView(true)
            }
        }
    }

    afterUpdate(() => moveToDay())

    Cookies.remove("collegeGroup")
    Cookies.remove("teacher")
    if (params.collegeGroup != null) {
        Cookies.set('collegeGroup', params.collegeGroup, {expires: 7})
    } else if (params.teacher != null) {
        Cookies.set('teacher', params.teacher, {expires: 7})
    }
</script>

<main>
    <button class="button" on:click={() => push("/teacher")}>Преподаватели</button>
    <button class="button" on:click={() => push("/college_group")}>Группы</button>
    <button class="button week" on:click={() => previewWeek()}>Предыдущая неделя</button>
    <button class="button week" on:click={() => nextWeek()}>Следующая неделя</button>
    <div class="info">{params.collegeGroup ?? params.teacher}</div>
    {#each [1, 2, 3, 4, 5, 6] as dayNumber}
        <div id={dayNumber} class="day">
            <div class="header">
                <div>{getDay(dayNumber)}</div>
                <div class="date-header">
                    {
                        addDays(fromDate, dayNumber - 1).toLocaleDateString("ru")
                    }
                </div>
            </div>
            {#each getDayValue(days, dayNumber) as day}
                <div class="padding">
                    <hr>
                </div>
                <div class={day["replacement"] ? "day-row day-row-replace" : "day-row"}>
                    <div>{day["time"]}</div>
                    <div>{day["lesson_number"]}</div>
                    <div>{day["lesson"]}</div>
                    <div>{params.collegeGroup != null ? day["teacher"] : day["college_group"]}</div>
                    <div>{day["lesson_hall"]}</div>
                </div>
            {/each}
        </div>
    {/each}
    <div class="info-footer">v0.3.1 Автор: <a href="https://vk.com/f_x_eq_x_mul_f_x">vk</a></div>
    <div class="info-footer">
        Во вторник и пятницу театральный коллектив «Октава» приглашает всех желающих в актовый зал с 13.00 до 17.00 для участия в будущих спектаклях
    </div>
</main>

<style>
    main {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 0.4rem;
        justify-content: stretch;
        justify-items: stretch;
        padding: 0.3rem;
    }

    .week {
        display: none;
    }

    .button {
        border: none;
        border-radius: 0.3rem;
        padding: 0.3rem;
        font-size: 1rem;

        background-color: rgb(244, 244, 244);
        color: rgb(37, 36, 39);
    }

    .button:hover {
        background-color: rgb(244, 244, 244);
        color: rgb(37, 36, 39);
    }

    .info, .info-footer {
        border: none;
        border-radius: 0.3rem;
        padding: 0.3rem;

        font-size: 1rem;
        text-align: center;

        grid-column: 2 span;

        background-color: rgb(37, 36, 39);
        color: rgb(244, 244, 244);
    }

    @media screen and (min-width: 800px) {
        main {
            grid-template-columns: repeat(4, 1fr);
        }

        .info {
            grid-column: 4 span;
        }

        .week {
            display: block;
        }
    }

    @media screen and (min-width: 1200px) {
        main {
            grid-template-columns: repeat(6, 1fr);
        }

        .info {
            grid-column: 2 span;
        }

        .info-footer {
            grid-column: 6 span;
        }
    }

    @media screen and (min-width: 1600px) {
        main {
            grid-template-columns: repeat(8, 1fr);
        }

        .info {
            grid-column: 4 span;
        }

        .info-footer {
            grid-column: 8 span;
        }
    }

    @media screen and (min-width: 2000px) {
        main {
            grid-template-columns: repeat(12, 1fr);
        }

        .info {
            grid-column: 8 span;
        }

        .info-footer {
            grid-column: 12 span;
        }
    }

    .day {
        grid-column: span 2;
        border: none;
        border-radius: 0.4rem;
        padding: 0.3rem;

        background-color: rgb(37, 36, 39);
        color: rgb(244, 244, 244);
    }

    .header {
        display: grid;
        grid-template-columns: 1fr 1fr;
    }

    .date-header {
        text-align: right;
    }

    .day-row {
        border: none;
        border-radius: 0.2rem;
        padding: 0.1rem;

        text-align: center;

        display: grid;
        grid-template-columns: 1fr 1fr 5fr 5fr 1fr;
    }

    .day-row-replace {
        background-color: rgb(245, 124, 0);
        color: rgb(37, 36, 39);
    }

    hr {
        border-style: solid;
        border-radius: 0.3rem;
    }

    .padding {
        padding: 0.2rem;
    }
</style>