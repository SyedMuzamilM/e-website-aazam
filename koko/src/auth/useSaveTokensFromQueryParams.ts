import { useEffect } from "react";
import { useTokenStore } from "./useTokenStore";
import { loginNextPathKey } from "../lib/constants";
import { showErrorToast } from "../lib/showErrorToast";
import { useQuery } from "../hooks/useQuery";

export const useSaveTokensFromQueryParams = () => {
  const params = useQuery();

  useEffect(() => {
    if (typeof params.get("error") === "string" && params.get("error")) {
      showErrorToast(params.get("error"));
    }
    if (
      typeof params.get("access_token") === "string" &&
      typeof params.get("refresh_token") === "string" &&
      typeof params.get("role") === "string" &&
      params.get("role") &&
      params.get("access_token") &&
      params.get("refresh_token")
    ) {
      useTokenStore.getState().setTokens({
        access_token: params.get("access_token") || "",
        refresh_token: params.get("refresh_token") || "",
        role: params.get("role") || "",
      });
      let nextPath = "/";
      try {
        const possibleNextPath = localStorage.getItem(loginNextPathKey);
        if (possibleNextPath && possibleNextPath.startsWith("/")) {
          nextPath = possibleNextPath;
          localStorage.setItem(loginNextPathKey, "");
        }
      } catch {}
      // Push to next path after auto redirect to /dash (100 msecs is unoticeable)
      if (params.get("role") === "admin") {
        setTimeout(() => (window.location.href = "/dashboard"), 100);
      } else {
        setTimeout(() => (window.location.href = nextPath), 100);
      }
    }
  }, [params]);
};
