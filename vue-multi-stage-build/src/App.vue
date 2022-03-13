<template>
    <h1>Hello</h1>
    <div class="greeting">{{ message }}</div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';

type DataType = {
    message: string
}

const App = defineComponent({
	data(): DataType {
		return {
			message: '',
		};
	},
	created() {
		this.initMessage();
	},
	methods: {
		initMessage(): void {
			this.message = 'World !!';
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