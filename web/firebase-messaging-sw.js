importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

const firebaseConfig = {
apiKey: "AIzaSyCJld8j8yV8TC-PeC1XpqvThaVTYvI6bbw",
  authDomain: "digital-fashion-seller.firebaseapp.com",
  projectId: "digital-fashion-seller",
  storageBucket: "digital-fashion-seller.appspot.com",
  messagingSenderId: "986127637622",
  appId: "1:986127637622:web:0ac78b2a3626755edfd357",
  measurementId: "G-B37TDNX53B"
}
firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();
messaging.onBackgroundMessage((message) => {
    console.log("onBackgroundMessage", message);
});
