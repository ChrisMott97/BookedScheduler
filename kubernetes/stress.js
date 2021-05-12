import http from 'k6/http';
import { check, group, sleep, fail } from 'k6'

export let options = {
  stages: [
    { duration: '2m', target: 80 },
    { duration: '2m', target: 80 },
    { duration: '2m', target: 160 },
    { duration: '2m', target: 160 },
    { duration: '2m', target: 240 },
    { duration: '2m', target: 240 },
    { duration: '2m', target: 320 },
    { duration: '2m', target: 320 },
    { duration: '2m', target: 400 },
    { duration: '2m', target: 400 },
    { duration: '2m', target: 0 },
  ],
  
};

//The IP and Port needs to be changed once the system has
//been put up. kubectl cluster-info can get the ip, and 
//kubectl get services will show the port of the NodePort
const BASE_URL = 'http://10.49.167.125:32622/Web/';

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
}
