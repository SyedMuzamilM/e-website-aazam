import React from "react";
import { useTokenStore } from "../auth/useTokenStore";

export let isLoggedIn: boolean;
export let isAdmin: boolean;
const Auth: React.FC  = () => {
    const tokenStore = useTokenStore()
    if(tokenStore.access_token !== null && tokenStore.refresh_token !== null) {
        isLoggedIn = true;
    } else {
        isLoggedIn = false;
    }

    if(tokenStore.role === "admin") {
        isAdmin = true;
    } else {
        isAdmin = false;
    }

    return(<h1>This is the componenet</h1>)
}