importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

const firebaseConfig = {
    apiKey: "AIzaSyCYNNyloGMREO0_7qajgvRTdvobmyZnBT8",
      authDomain: "flutter-web-29d92.firebaseapp.com",
      projectId: "flutter-web-29d92",
      storageBucket: "flutter-web-29d92.appspot.com",
      messagingSenderId: "1039297047623",
      appId: "1:1039297047623:web:c2e9205493d33a2f6f1562",
      measurementId: "G-RFYDXHGWCK"
};

firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
    console.log("onBackgroundMessage", message);
});