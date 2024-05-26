importScripts('https://www.gstatic.com/firebasejs/4.1.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/4.1.1/firebase-messaging.js');
importScripts('https://www.gstatic.com/firebasejs/4.1.1/firebase.js');

var config = {
	apiKey: "AIzaSyB7f4HxsTs7tKm8ttcFeBWGA82qddey6C4",
	authDomain: "mycifornotification.firebaseapp.com",
	databaseURL: "https://mycifornotification.firebaseio.com",
	projectId: "mycifornotification",
	storageBucket: "mycifornotification.appspot.com",
	messagingSenderId: "1071976859296"
};
firebase.initializeApp(config);

const messaging = firebase.messaging();
messaging.setBackgroundMessageHandler(function(payload){
	return self.registration.showNofitication();
});