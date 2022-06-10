<template>
    <div>
        <el-container>
            <el-header style="padding: 0">
                <el-menu
                    :default-active="activeIndex"
                    class="el-menu-demo"
                    mode="horizontal"
                    :ellipsis="false"
                    background-color="#545c64"
                    text-color="#fff"
                    active-text-color="#ffd04b"
                    @select="handleSelect">
                    <el-menu-item index="0">LOGO</el-menu-item>
                    <div class="flex-grow" />
                    <el-menu-item index="1">提案列表</el-menu-item>
                    <el-menu-item index="2">canister列表</el-menu-item>
                    <el-menu-item index="3">小组成员</el-menu-item>
                    <div class="login-grow" />
                    <div class="login-btn">
                        <el-button class="right-menu" type="warning" round v-if="!isLogin" @click="login">
                            <el-icon style="vertical-align: middle">
                                <Wallet />
                            </el-icon>
                            <span style="vertical-align: middle"> Sign In </span>
                        </el-button>
                        <el-button class="right-menu" type="warning" round v-if="isLogin" @click="logout">
                            <el-icon style="vertical-align: middle">
                                <Wallet />
                            </el-icon>
                            <span style="vertical-align: middle" > Sign out </span>
                        </el-button>
                        
                        <div class="principalText" @click="copy" v-if="isLogin">
                            <el-icon style="vertical-align: middle" :size="25">
                                <Wallet />
                            </el-icon>
                            <span class="principalText">{{principalId}}</span>
                        </div>
                    </div>
                </el-menu>
            </el-header>
            <el-main>
                <router-view/>
            </el-main>
        </el-container>
    </div>
</template>

<script>
import { course05, idlFactory, canisterId as main_canister_id } from "../../../declarations/course05";
import { onMounted,reactive,ref,computed  } from "vue";
import { Actor, HttpAgent } from "@dfinity/agent";
import { DelegationIdentity } from "@dfinity/identity";
import { AuthClient } from "@dfinity/auth-client";
import { Principal } from "@dfinity/principal";
import { useRouter } from 'vue-router';
import useClipboard from 'vue-clipboard3';
import { useStore } from 'vuex'
export default {
    
    setup () {
        const activeIndex = ref('1')
        const activeIndex2 = ref('1')
        const store  = useStore()
        const isLogin = computed(() =>{
            console.log(store.state.isLogin)
            return store.state.isLogin
        })
        const router = useRouter()
        const { toClipboard } = useClipboard()
        var authClient = {}
        const principalId = computed(() =>{
            return store.state.principalId
        })
        const handleSelect = (key, keyPath) => {
            switch (key) {
                case '0': router.push('/home');console.log(0); break;
                case '1': router.push('/proposal');console.log(1); break;
                case '2': router.push('/canister');console.log(2); break;
                case '3': router.push('/owner');console.log(3); break;
            }
        }
        onMounted(async () => {
            authClient = await AuthClient.create();
        });
        const updateView = () => {
            const identity = authClient.getIdentity();
            if (identity instanceof DelegationIdentity) {
                const agent = new HttpAgent({ identity });
                // 设置代理
                var webapp = Actor.createActor(idlFactory, {
                    agent,
                    canisterId: main_canister_id,
                });
                console.log(webapp)
                store.dispatch('updateLoginStatus', true)
                store.dispatch('updateWebApp', webapp)
                store.dispatch('updatePrincipalId', identity.getPrincipal().toText())
            } else {
                store.dispatch('updateLoginStatus', false)
                store.dispatch('updateWebApp', {})
                store.dispatch('updatePrincipalId', identity.getPrincipal().toText())
            }
        }
        const copy = async () => {
            try {
                await toClipboard(principalId.value)
                ElMessage({
                    message: 'copyed',
                    type: 'success',
                })
            } catch (e) {
                console.error(e)
            }
        }
        const methods = {
            // 登录
            async login() {
                const days = BigInt(1);
                const hours = BigInt(24);
                const nanoseconds = BigInt(3600000000000);
                authClient.login({
                        onSuccess: async () => {
                            updateView()
                        },
                    // identityProvider:process.env.DFX_NETWORK === "ic" ? "https://identity.ic0.app/#authorize": //线上internet identity canister ID
                    // "http://rrkah-fqaaa-aaaaa-aaaaq-cai.localhost:8000/#authorize",//本地internet identity canister ID
                    identityProvider: "https://identity.ic0.app/#authorize",//本地internet identity canister ID
                    //最大授权有效期为8天
                    maxTimeToLive: days * hours * nanoseconds,
                })
            },
            async logout(){
                await authClient.logout();
                updateView();
            }
        }
        return {...methods, activeIndex,activeIndex2,handleSelect, isLogin, copy, principalId}
    }
}
</script>

<style>
.flex-grow {
  flex-grow: 0.1;
}
.login-grow{
    flex-grow: 1;
}
.login-btn{
    margin-top: 8px
}
.right-menu {
float: right;
display: table-cell;vertical-align: middle;text-align:center;
margin: 5px;
&:focus {
    outline: none;
}
}
.principalText{
    margin: 10px;
    white-space: nowrap;
    width: 200px;
    /* 文字用省略号代替超出的部分 */
    text-overflow: ellipsis;
    /* 匀速溢出内容，隐藏 */
    overflow: hidden;  
    cursor: pointer
} 
.principalText:hover{
    color: #fff
}
</style>