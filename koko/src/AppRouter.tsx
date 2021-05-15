import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
import { AboutPage } from "./pages/AboutPage";
import { AddProductPage } from "./pages/AddProductPage";
import { DashboardPage } from "./pages/DashboardPage";
import { HomePage } from "./pages/HomePage";
import { LoginPage } from "./pages/LoginPage";
import { ProductPage } from "./pages/ProductPage";

export const AppRouter = () => {
  return (
    <Router>
      <Switch>
        <Route exact path="/login">
          <LoginPage />
        </Route>
        <Route exact path="/">
          <HomePage />
        </Route>
        <Route exact path="/about">
          <AboutPage />
        </Route>
        <Route exact path="/dashboard">
          <DashboardPage />
        </Route>
        <Route exact path="/products/add">
          <AddProductPage />
        </Route>
        <Route exact path="/product/:id">
          <ProductPage />
        </Route>
      </Switch>
    </Router>
  );
};
