import {createStore} from 'vuex'
//创建状态
const state = {
    isLogin: false,
    webapp: {},
    principalId: "",
}

//创建mutataions
const mutations = {
    updateLoginStatus(state, login){
        state.isLogin = login
    },
    updatePrincipalId(state, principalId){
        state.principalId = principalId
    },
    updateWebApp(state, webApp){
        state.webapp = webApp
    }
}

//创建actions
const actions = {
    updateLoginStatus(store, login){
        console.log("login", login)
        store.commit('updateLoginStatus', login)
    },
    updatePrincipalId(store, principalId){
        store.commit('updatePrincipalId', principalId)
    },
    updateWebApp(store, webApp){
        console.log("loging")
        store.commit('updateWebApp', webApp)
    }
}

//创建store
const store = createStore({
state,
actions,
mutations
})
//暴露出去
export default store