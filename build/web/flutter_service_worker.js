'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "app_logo.png": "f13475925f7447fb5d4246dd4cd18894",
"assets/AssetManifest.json": "74efa8ce2ce20f582ec756c8f902288a",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/images/add.png": "d324172dddcc23d096fa87eac6e7b6b6",
"assets/images/apple.png": "cd8b95332a6c06e211d0255231f006fd",
"assets/images/app_logo.png": "f13475925f7447fb5d4246dd4cd18894",
"assets/images/ContactUs.png": "0c518184058ddf6e67e428a3f727194f",
"assets/images/ContactUs1.png": "fdad335151fb4cb8d7e61302f8f728a5",
"assets/images/google.png": "a83f94ce9018b5e1b357b85fd390a9a7",
"assets/images/ic_apple.png": "90dbbf3bc53823ea9b730a6c2faae488",
"assets/images/ic_Back.png": "9291b516a89d9ec12ba36e0a34a9fbb5",
"assets/images/ic_category.png": "9598909766ad8ed01cfd581d49259e97",
"assets/images/ic_delete.png": "438d13a5c12d09f6b3acfb7433934434",
"assets/images/ic_editprofile.png": "9c15cf545d56f3aa7d485c02572be28b",
"assets/images/ic_error.png": "b89543f3a5795da77fc92cf7cef74163",
"assets/images/ic_eyeFill.png": "24d6c6aa224d07b1673bf1448d8d4661",
"assets/images/ic_facebook.png": "ef3d9a8da278de081b7fd7294f8b2ff2",
"assets/images/ic_fb.png": "44d892047acb7ab071038df2c5845cc7",
"assets/images/ic_forum.png": "424ffadfd21f31115638a621a8166dc7",
"assets/images/ic_ForumLikeHeart.png": "cc2cd08ff7188e85dafd94cc9b176147",
"assets/images/ic_ForwordArrow.png": "669619417b25ce0c41607f5753784a6a",
"assets/images/ic_google.png": "c2fdf8af75fa0a93b8446a7393503289",
"assets/images/ic_home.png": "ad36dc34c8c894b97907cf7a09e4a462",
"assets/images/ic_icAdd.png": "db4d6acc680b7fe978dd20e6fd45ef3e",
"assets/images/ic_instgram.png": "c906ee897504f147963baf3063031df1",
"assets/images/ic_logout.png": "33827b5c93bdab652e0f20d66b25e063",
"assets/images/ic_next_arrow.png": "85810df68b9a045a2e1e25b1cb83d2da",
"assets/images/ic_NotFoundLogo.png": "7f8b59998b6c5fa36098922623ba1b10",
"assets/images/ic_notificationIcon.png": "6e6ed5346c9d13ae3e143e1190bc03a6",
"assets/images/ic_passwordHide.png": "d0e591b0a730a17c59870f06c805291a",
"assets/images/ic_privacypolicy.png": "f0192c551a739526151e19b4143f62f3",
"assets/images/ic_profile.png": "14da1ab7fd93add229af651a88367d8f",
"assets/images/ic_SaveIcon.png": "c4e4c8529ec5b235be2069d0fee2f9fa",
"assets/images/ic_search.png": "ac0c141c9ac48ee2fce9669d9e3a7ba8",
"assets/images/ic_select_category.png": "e0c481f88be03cbee4ee1b518c02f72f",
"assets/images/ic_select_forum.png": "a9aeca74ffafc4de053a030ff50266e3",
"assets/images/ic_select_home.png": "360fb76a0b53dad83d33e587ca114926",
"assets/images/ic_select_profile.png": "9491caec51ffbbdd2969fa4dc548c66b",
"assets/images/ic_SendIcon.png": "31792962bcf96dc132e13f54e96450c5",
"assets/images/ic_settings.png": "5c335c17e18ecf2e6e3deb55776e28a7",
"assets/images/ic_ShareIcon.png": "74f6c70e6fb003f755a074260c51267f",
"assets/images/ic_termscondition.png": "0b53b47bfc95177633cdeecdd6cd6d04",
"assets/images/ic_twitter.png": "030156755c55f9011ef2b3651b8a607f",
"assets/images/Indict.gif": "6f56509b57db765ece092ed3176cf9bc",
"assets/images/line.png": "51bacf3a1a75b98c3976e1485a25f2cf",
"assets/images/login.png": "58f9b8fad05943d663d9b701e191fd9b",
"assets/images/LoginPageLogo.png": "5cca93a47c3632e5892b311b9302fbde",
"assets/images/LoginUser.png": "2df1ba475b653a1aa7d538645c49eb87",
"assets/images/next.png": "4099e104f7926bd4c20307b996a03157",
"assets/images/play.png": "f3f6ac8533a2dc8aae34607fcf0a4d25",
"assets/images/Playbtn.png": "4fd0bacda2f6c8e0c06ddfbc7c19ce3e",
"assets/images/prev.png": "7340e29a81968633a7ca33a83b6e7b43",
"assets/images/red_divider.png": "6310086c56e3efe339ee573757285ee9",
"assets/images/search_bar.png": "d0531e68b78f2bf5fa173f0c86ca1567",
"assets/images/share.png": "3e39cf4f6f4cc5601e5118056ce4d923",
"assets/images/signup.png": "601c12a7ac83d80c9177c2e90153f065",
"assets/NOTICES": "7d53bbcba6378b5482c45a16cf11da02",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/fluttertoast/assets/toastify.js": "e7006a0a033d834ef9414d48db3be6fc",
"assets/packages/wakelock_web/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/youtube_player_iframe/assets/player.html": "dc7a0426386dc6fd0e4187079900aea8",
"canvaskit/canvaskit.js": "97937cb4c2c2073c968525a3e08c86a3",
"canvaskit/canvaskit.wasm": "3de12d898ec208a5f31362cc00f09b9e",
"canvaskit/profiling/canvaskit.js": "c21852696bc1cc82e8894d851c01921a",
"canvaskit/profiling/canvaskit.wasm": "371bc4e204443b0d5e774d64a046eb99",
"flutter.js": "1cfe996e845b3a8a33f57607e8b09ee4",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "8ec9b30d31130e1fc4b633314f65ec10",
"/": "8ec9b30d31130e1fc4b633314f65ec10",
"main.dart.js": "c278033226d16565e3cc080855ae5ad2",
"manifest.json": "b436dd2118ca949b29f14923b2527da8",
"version.json": "a62715dd1e51f1a966ce9efa84ad2174"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
