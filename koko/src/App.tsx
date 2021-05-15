import { AppRouter } from "./AppRouter"
import { Header } from "./ui/header/header";

const App: React.FC = () => {
  return(
    <div>
      <Header />
      <AppRouter />
    </div>
  )
}

export default App;