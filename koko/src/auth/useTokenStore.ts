import create from "zustand";
import { combine } from "zustand/middleware";
import { isServer } from "../lib/isServer";

const access_tokenKey = "@toum/token";
const refresh_tokenKey = "@toum/refresh-token";
const roleKey = "@toum/role";

const getDefaultValues = () => {
  if (!isServer) {
    try {
      return {
        access_token: localStorage.getItem(access_tokenKey) || "",
        refresh_token: localStorage.getItem(refresh_tokenKey) || "",
        role: localStorage.getItem(roleKey) || "",
      };
    } catch {}
  }

  return {
    access_token: "",
    refresh_token: "",
    role: "",
  };
};

export const useTokenStore = create(
  combine(getDefaultValues(), (set) => ({
    setTokens: (x: {
      access_token: string;
      refresh_token: string;
      role: string;
    }) => {
      try {
        localStorage.setItem(access_tokenKey, x.access_token);
        localStorage.setItem(refresh_tokenKey, x.refresh_token);
        localStorage.setItem(roleKey, x.role);
      } catch {}

      set(x);
    },
  }))
);
