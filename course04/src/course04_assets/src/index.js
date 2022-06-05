import {createApp} from 'vue';
import App from './app.vue'
import ant from 'ant-design-vue'
import 'ant-design-vue/dist/antd.css'


const app = createApp(App)
app.use(ant)
app.mount('#app')
