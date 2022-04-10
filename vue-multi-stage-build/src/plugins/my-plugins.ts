import { Plugin } from 'vue';

const plugin: Plugin = {
	install(app) {
		app.config.globalProperties['$helloWorld'] = (name: string) => {
			return `Hello, ${name}`;
		};

	}
};

export default plugin;
