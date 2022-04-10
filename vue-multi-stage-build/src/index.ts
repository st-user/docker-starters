import { createApp } from 'vue';
import App from './App.vue';

import  plugin from './plugins/my-plugins';

declare module '@vue/runtime-core' {
	interface ComponentCustomProperties {
		$helloWorld: (key: string) => string
	}
}

createApp(App).use(plugin).mount('#app');