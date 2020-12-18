import React, { Component } from "react";
import axios from "axios";

let endpoint = "http://localhost:30007";
class ToDoList extends Component {
  constructor(props) {
    super(props);

    this.state = {
      task: "",
      description: "",
      items: [],
    };
  }
  componentDidMount() {
    this.getTask()
  }


  onChange = (event) => {
    this.setState({
      [event.target.name]: event.target.value
    });
  };

  onChangeTodo = (event, _id) => {
    let items = [...this.state.items]
    const index = this.state.items.findIndex(emp => emp._id === _id)
    let item = {...items[index]}
    item.edit = event.target.value
    items[index] = item;

    this.setState({items});
  };

  handleClick(id) {
    console.log(id);
    this.deleteTask(id);
  }


  editTodo (event, _id){
    if(event.key === 'Enter'){
      let items = [...this.state.items]
      const index = this.state.items.findIndex(emp => emp._id === _id)
      let item = {...items[index]}
      item.title = item.edit
      item.edit = ""

      this.updateTask(item)
      
      items[index] = item

      this.setState({items})
    }
  }

  updateTask = (item) => {
    var title = item.title
    var description = item.description
    var id = item._id

    axios
      .put(endpoint + "/api/task/" + id + "/" + title, 
      {
        title,
        description
      },
      {
        headers: {
          "Content-Type": "application/x-www-form-urlencoded"
        }
      })
      .then(res => {
        console.log(res);
      });
  };

  onSubmit = (event) => {
    if(event.key === 'Enter'){
      event.preventDefault();
      let {task}  = this.state;
      let description = this.state;
      var d = new Date()
      var month = d.getMonth() + 1
      var year = d.getFullYear()
      var date = d.getDate()
      description = month + ' ' + date + ' ' + year
      var title = task
      var edit = ""
  
      if (task) {
        axios.post(
            endpoint + "/api/task",
            {
              title,
              description,
              edit
            },
            {
              headers: {
                "Content-Type": "application/x-www-form-urlencoded"
              }
            }
          )
          .then((res) => {
            console.log(res);

            this.setState({
              items: []
            })
            this.getTask()


            this.setState({
              task: "",
              edit: null,
              description:""
            });
          });
          console.log(this.state.items)
      }
    }
  };

  getTask = () => {
    axios.get(endpoint + "/api/task").then(res => {
      if (res.data) {
        res.data.map(item => {
          return(
            this.setState(prevState => ({
              items: [...prevState.items, item]
            }))
          )

        })
        console.log(this.state.items)
      }
    });
  };

  deleteTask = (id) => {
    axios.delete(endpoint + "/api/deleteTask/" + id, {
        headers: {
          "Content-Type": "application/x-www-form-urlencoded"
        }
      })
      .then((res) => {
        this.setState(prevState => ({
          items: prevState.items.filter(el => el._id !== id )
        }));
        console.log(res)
        console.log(this.state.items)
      });
      
  };

  render() {
    let {items} = this.state
    let {task} = this.state

    return (
      
      <div>
          <title>Todo</title>
          <link
          rel="stylesheet"
          type="text/css"
          href="https://unpkg.com/todomvc-app-css@2.2.0/index.css"
          />
        <section className="todoapp">
        <header className="header">
          <h1>todos</h1>
          <input
            className="new-todo"
            autoFocus
            autoComplete="off"
            placeholder="What needs to be done?"
            type="text"
            name="task"
            value={task}
            onKeyPress={this.onSubmit}
            onChange={this.onChange}
          />
        </header>
        <section className="main">
        <ul className="todo-list">
          <div>
            {items.map(item => {
              return(

              <li 
              className="todo" 
              key={item._id} 
              >
              
              <div className = "view">
              <label>
              {item.title}
                <input
                  type="text"
                  name="edit"
                  onChange={(e) => {
                    this.onChangeTodo(e, item._id)}}
                  value={item.edit}
                  onKeyPress={(e) => {
                    this.editTodo(e, item._id)}}

                />
              
              </label>
              <button className="destroy" onClick={this.handleClick.bind(this, item._id)}></button>
              </div>
              </li> 
              )
            })}
          </div>
        </ul>
        </section>
        </section>

        
      </div>
    );
  }
}

export default ToDoList;

