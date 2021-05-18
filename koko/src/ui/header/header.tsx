import { Link, BrowserRouter } from "react-router-dom";
import { isLoggedIn } from "../../lib/isAuth";

export const Header: React.FC = () => {
  return (
    <BrowserRouter>
    
      <header className={`bg-green-600 flex flex-row justify-between py-4`}>
        <nav className={`flex mx-auto items-center justify-between lg:w-8/12 `}>
          <div className={`text-white font-extrabold text-2xl`}>
            <Link to="/">Aazam Family Wadrobe</Link>
          </div>
          <ul className={`flex-row items-center lg:inline-flex hidden`}>
            <li className={`pr-5`}>
              <Link to="#"> Services </Link>
            </li>
            <li className={`pr-5`}>
              <Link to="#">Porfolio</Link>
            </li>
            <li className={`pr-5`}>
              <Link to="/about">About</Link>
            </li>
            {!isLoggedIn && (
              <li>
                <Link to="/login">
                  <button
                    className="w-24 h-9 font-semibold flex items-center justify-center bg-black text-white"
                    type="submit"
                  >
                    Login
                  </button>
                </Link>
              </li>
            )}
          </ul>
        </nav>
      </header>
    </BrowserRouter>
  );
};
