<template>
    <h1>Hello, Vue</h1>
	<div class="greeting">{{ !message ? $helloWorld('everyone') : message }}</div>
	<p>name: <input type="text" v-model="name"/></p>
	<p><button type="button" @click="run">run</button></p>
</template>

<script lang="ts">
import { defineComponent } from 'vue';

interface DataType {
	name: string,
    message: string
}

const App = defineComponent({
	data(): DataType {
		return {
			name: '',
			message: '',
		};
	},
	methods: {
		run(): void {
			this.message = this.$helloWorld(this.name);
		}
	}
});
export default App;
</script>

<style scoped>
.greeting {
    color: red;
    font-weight: bold;
}
</style>