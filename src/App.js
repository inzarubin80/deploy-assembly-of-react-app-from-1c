
import './App.css';
import Header from './components/Header'
import Tasks from './components/Tasks'
function App() {
  
  
  
  return (
    <div className="App">
        
          <Header title={'Задачи'}/>
         
         <div className='content'>
            <Tasks/>
          </div>
          
    </div>
  );
}

export default App;
