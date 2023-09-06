importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

const firebaseConfig = {
  apiKey: "AIzaSyBaAbG2eNrQR2e1JmJcLj0N4QoKSv59Sb0",
  authDomain: "tychostreams.firebaseapp.com",
  projectId: "tychostreams",
  storageBucket: "tychostreams.appspot.com",
  messagingSenderId: "746850038788",
  appId: "1:746850038788:web:0e231dc5e9ead255407151",
  measurementId: "G-2Q4LD5W403"
}
firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();
messaging.onBackgroundMessage((message) => {
    console.log("onBackgroundMessage", message);
});
