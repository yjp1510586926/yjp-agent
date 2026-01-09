import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './App.css';

interface User {
  id: number;
  name: string;
  email: string;
}

function App() {
  const [message, setMessage] = useState<string>('');
  const [users, setUsers] = useState<User[]>([]);
  const [newUser, setNewUser] = useState({ name: '', email: '' });

  useEffect(() => {
    fetchMessage();
    fetchUsers();
  }, []);

  const fetchMessage = async () => {
    try {
      const response = await axios.get('http://localhost:3001/api/hello');
      setMessage(response.data.message);
    } catch (error) {
      console.error('Error fetching message:', error);
    }
  };

  const fetchUsers = async () => {
    try {
      const response = await axios.get('http://localhost:3001/api/users');
      setUsers(response.data);
    } catch (error) {
      console.error('Error fetching users:', error);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const response = await axios.post('http://localhost:3001/api/users', newUser);
      setUsers([...users, response.data]);
      setNewUser({ name: '', email: '' });
    } catch (error) {
      console.error('Error creating user:', error);
    }
  };

  return (
    <div className="App">
      <header className="App-header">
        <h1>NestJS + React 全栈应用</h1>
        <p className="message">{message}</p>
      </header>

      <main className="App-main">
        <section className="users-section">
          <h2>用户列表</h2>
          <ul className="users-list">
            {users.map((user) => (
              <li key={user.id}>
                <strong>{user.name}</strong> - {user.email}
              </li>
            ))}
          </ul>
        </section>

        <section className="form-section">
          <h2>添加新用户</h2>
          <form onSubmit={handleSubmit}>
            <div className="form-group">
              <input
                type="text"
                placeholder="姓名"
                value={newUser.name}
                onChange={(e) => setNewUser({ ...newUser, name: e.target.value })}
                required
              />
            </div>
            <div className="form-group">
              <input
                type="email"
                placeholder="邮箱"
                value={newUser.email}
                onChange={(e) => setNewUser({ ...newUser, email: e.target.value })}
                required
              />
            </div>
            <button type="submit">添加用户</button>
          </form>
        </section>
      </main>
    </div>
  );
}

export default App;
