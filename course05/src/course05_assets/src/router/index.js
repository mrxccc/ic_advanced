import {createRouter, createWebHashHistory} from 'vue-router'

const routes = [
    { 
        path: "/", 
        redirect: "/home" 
    },
    // /home/shops
    {
        path: "/home", 
        name: "home", 
        component: () => import("../pages/Home.vue"),
        children: [
            {
                path: "/proposal", 
                name: "proposal", 
                component: () => import("../pages/Proposal.vue"),
            },
            {
                path: "/canister", 
                name: "canister", 
                component: () => import("../pages/Canister.vue"),
            },
            {
                path: "/owner", 
                name: "owner", 
                component: () => import("../pages/Owner.vue"),
            },
        ],
    }
]

  const router = createRouter({
    // 4. 内部提供了 history 模式的实现。为了简单起见，我们在这里使用 hash 模式。
    history: createWebHashHistory(),
    routes, // `routes: routes` 的缩写
  })

  export default router