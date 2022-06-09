import {createApp} from 'vue';
import App from './app.vue'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'
import router from "./router"

const app = createApp(App)
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
    app.component(key, component)
  }
app.use(router)
app.mount('#app')
