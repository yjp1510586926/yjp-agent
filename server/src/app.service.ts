import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  private users = [
    { id: 1, name: 'Alice', email: 'alice@example.com' },
    { id: 2, name: 'Bob', email: 'bob@example.com' },
  ];

  getHello(): { message: string } {
    return { message: 'Hello from NestJS!' };
  }

  getUsers() {
    return this.users;
  }

  createUser(userData: { name: string; email: string }) {
    const newUser = {
      id: this.users.length + 1,
      ...userData,
    };
    this.users.push(newUser);
    return newUser;
  }
}
