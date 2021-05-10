import http from 'k6/http';
import { check, group, sleep, fail } from 'k6'

export let options = {
  stages: [
    { duration: '5m', target: 10 },
    { duration: '10m', target: 10 },
    { duration: '5m', target: 0 },
  ],
  
  thresholds: {
    http_req_duration: ['p(99)<1500'],
    //'successful login': ['p(99)<1500'],
  },
};

const BASE_URL = 'http://10.49.167.43:30412/Web/';

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
  //let loginRes = http.post(`${BASE_URL}/index.php`, data);
  //check(loginRes, {
  //  'successful login': (r) => r.url.includes("/Web/dashboard.php"),
  //});

  //let loggedInRes = http.get(`${BASE_URL}/dashboard.php`);
  //check(loginRes, {
  //  'is still logged in': (r) => r.url.includes("/Web/dashboard.php"),
  //});
}
