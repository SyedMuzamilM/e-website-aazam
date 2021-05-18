import { AppRouter } from "./AppRouter"
import { Header } from "./ui/header/header";

const App: React.FC = () => {
  return(
    <div className={`flex flex-col h-screen`}>
      <Header />
      <main className={`flex-1 overflow-y-auto`}>

      <AppRouter />
      </main>
    </div>
  )
}

export default App;