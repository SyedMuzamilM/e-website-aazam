import { useCallback, useEffect } from "react";
import { BrowserRouter, Link, useHistory } from "react-router-dom";
import { useSaveTokensFromQueryParams } from "../auth/useSaveTokensFromQueryParams";
import { useTokenStore } from "../auth/useTokenStore";
import { useQuery } from "../hooks/useQuery";
import { WEB_API_URL } from "../lib/constants";

interface LoginButtonProps {
  children: React.ReactNode;
  onClick?: () => void;
  oauthUrl?: string;
}

export const LoginButton: React.FC<LoginButtonProps> = ({
  children,
  onClick,
  oauthUrl,
  ...props
}) => {
  const query = useQuery();
  const clickHandler = useCallback(() => {
    if (typeof query.get("next") === "string" && query.get("next")) {
      try {
        localStorage.setItem("next", query.get("next") || "");
      } catch {}
    }

    window.location.href = oauthUrl as string;
  }, [query, oauthUrl]);

  return (
    <button
      className={`flex outline-none focus:ring-4 focus:ring-gray-900 px-6 rounded-lg  bg-gray-700 hover:bg-gray-600 text-white font-bold items-center text-base py-3 mt-2`}
      onClick={oauthUrl ? clickHandler : onClick}
      {...props}
    >
      {children}
    </button>
  );
};

export const LoginPage = () => {
  useSaveTokensFromQueryParams();
  const hasTokens = useTokenStore((s) => !!(s.access_token && s.refresh_token));
  const getLocalItems = useTokenStore();

  const history = useHistory();
  useEffect(() => {
    if (hasTokens && getLocalItems.role === "admin") {
      history.push("/dashboard");
    } else if (hasTokens) {
      history.push("/")
    }
  }, [hasTokens, history, getLocalItems.role]);
  return (
    <BrowserRouter>
      <div className={`flex justify-center lg:my-24 my-12`}>
        <div className={`bg-white shadow-lg lg:w-4/12 xl:w-3/12 h-96 py-20 px-12`}>
          <div className={`flex gap-3 flex-col justify-start`}>
            <span className={`text-3xl font-bold`}>Welcome</span>
            <div className={`text-gray-700 flex-wrap`}>
              By loggin in you accept our{" "}
              <Link className={`text-red-600 hover:underline`} to="/">
                Privacy Policy
              </Link>{" "}
              and
              <Link className={`text-red-600 hover:underline`} to="/">
                Terms of Service
              </Link>
            </div>
          </div>
          <div className={`flex flex-col gap-4 mt-10`}>
            <LoginButton
                oauthUrl={`${WEB_API_URL}/auth/google/web`}
            >
              <span className={`flex items-center`}>
                <div
                  className="grid gap-4"
                  style={{ gridTemplateColumns: "1fr auto 1fr" }}
                >
                  <svg
                    fill="#fff"
                    xmlns="http://www.w3.org/2000/svg"
                    viewBox="0 0 24 24"
                    width="24px"
                    height="24px"
                  >
                    {" "}
                    <path d="M12.545,10.239v3.821h5.445c-0.712,2.315-2.647,3.972-5.445,3.972c-3.332,0-6.033-2.701-6.033-6.032 s2.701-6.032,6.033-6.032c1.498,0,2.866,0.549,3.921,1.453l2.814-2.814C17.503,2.988,15.139,2,12.545,2 C7.021,2,2.543,6.477,2.543,12s4.478,10,10.002,10c8.396,0,10.249-7.85,9.426-11.748L12.545,10.239z" />
                  </svg>
                  Login with Google
                  <div></div>
                </div>
              </span>
            </LoginButton>
          </div>
        </div>
      </div>
    </BrowserRouter>
  );
};


