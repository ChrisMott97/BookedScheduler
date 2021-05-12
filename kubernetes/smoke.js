import http from 'k6/http';
import { check, group, sleep, fail } from 'k6'

export let options = {
  vus: 1,
  duration: '60s',

  thresholds: {
    http_req_duration: ['p(99)<1500'],
  },
};

//The IP and Port needs to be changed once the system has
//been put up. kubectl cluster-info can get the ip, and 
//kubectl get services will show the port of the NodePort
const BASE_URL = 'http://10.49.167.29:32651/Web';

export default function () {
  let data = {
    email: 'admin',
    password: 'password',
    login: 'submit'
  }
    
  let initialRes = http.get(`${BASE_URL}`);
  check(initialRes, {
    'is loaded': (r) => r.status === 200,
  });
  //let loginRes = http.post(`${BASE_URL}/index.php`, data);
  //check(loginRes, {
  //  'is logged in': (r) => r.url.includes("/Web/dashboard.php"),
  //});

  //let loggedInRes = http.get(`${BASE_URL}/dashboard.php`);
  //check(loginRes, {
  //  'still logged in': (r) => r.url.includes("/Web/dashboard.php"),
  //});
}
