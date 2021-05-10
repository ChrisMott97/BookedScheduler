import http from 'k6/http';
import { check, group, sleep, fail } from 'k6'

export let options = {
  stages: [
    { duration: '2m', target: 25 },
    { duration: '5m', target: 25 },
    { duration: '2m', target: 50 },
    { duration: '5m', target: 50 },
    { duration: '2m', target: 75 },
    { duration: '5m', target: 75 },
    { duration: '2m', target: 100 },
    { duration: '5m', target: 100 },
    { duration: '10m', target: 0 },
  ],
  
};

const BASE_URL = 'http://10.49.167.242:32178/Web';

export default function () {
  let data = {
    email: 'admin',
    password: 'password',
    login: 'submit'
  }
    
  let initialRes = http.get(`${BASE_URL}`);
  check(initialRes, {
    'has loaded': (r) => r.status === 200,
  });
  let loginRes = http.post(`${BASE_URL}/index.php`, data);
  check(loginRes, {
    'successful login': (r) => r.url.includes("/Web/dashboard.php"),
  });

  let loggedInRes = http.get(`${BASE_URL}/dashboard.php`);
  check(loginRes, {
    'is still logged in': (r) => r.url.includes("/Web/dashboard.php"),
  });
}
