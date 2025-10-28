'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "974ffa0ed758c437dd58747e443a712c",
"version.json": "4d15e716bee407d8b0551813ed7743d6",
"index.html": "50f75016f488eaaf9debf2822987e2a8",
"/": "50f75016f488eaaf9debf2822987e2a8",
"main.dart.js": "65d62fce1d96531f4f98d5b262b92b43",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "4d71367a1ca1791a81c156a7c9297e12",
".git/config": "caabe0ae9d3467a9bba15c3f9ffb0ed3",
".git/objects/50/240942c7c59363ac301a4fed261622dad3b7eb": "5eda1e51842e3a1f759030b643b1d508",
".git/objects/9b/3ef5f169177a64f91eafe11e52b58c60db3df2": "91d370e4f73d42e0a622f3e44af9e7b1",
".git/objects/9e/3b4630b3b8461ff43c272714e00bb47942263e": "accf36d08c0545fa02199021e5902d52",
".git/objects/04/c4efd9116483cfe0670c910eb45e50f9f54e83": "91699783b9d6b020d99a85a5b8f06327",
".git/objects/6a/7d3f5aa88cb5dac2159045dd689dd6d903a586": "c6ceb47edac4b90effec58981d47c107",
".git/objects/3c/d72d3e0f67c29ebef417b2952a5b1682df203d": "ec0144b14f2cfb482dad897f077e95e5",
".git/objects/33/98c679f8a922454f4003dcf198349bd1884b0b": "de8116ea0d058aec61dd291fbbc64de6",
".git/objects/02/3148ba3fe2a2cb9ccaa4a147a0eca38a35f5e0": "9462cc225a21ba50435f3c50b587e801",
".git/objects/b5/2d2972fbda58ae55b34e7a20a1e281ae4a2772": "0464d3e58c56f1987103169eb18a163f",
".git/objects/df/d947d7cb239b6fddecac7d0f52347a375ec814": "b86c3e80018168206d66e474cc0fb3fa",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/d8/8128adaad90d2fd7cdabe7b36eaaaed0d3a25b": "3d15963af0d77c1cd40702fb7c18fa93",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/ca/3bba02c77c467ef18cffe2d4c857e003ad6d5d": "316e3d817e75cf7b1fd9b0226c088a43",
".git/objects/fe/3b987e61ed346808d9aa023ce3073530ad7426": "dc7db10bf25046b27091222383ede515",
".git/objects/fe/a57e95f420f070e89ad7d9b16529d5dcfc009d": "6d98c51220178e503524a094e02429d6",
".git/objects/ed/b55d4deb8363b6afa65df71d1f9fd8c7787f22": "886ebb77561ff26a755e09883903891d",
".git/objects/20/3a3ff5cc524ede7e585dff54454bd63a1b0f36": "4b23a88a964550066839c18c1b5c461e",
".git/objects/27/a894970ac8dee9e9c5850be40736d742897b85": "6297679bc38e6ce818acd453be0a5c42",
".git/objects/4b/05f97f8982a4900467a44a3da9fdee1c7d7769": "f7b5f0ede20dfcb3b3ac19f973173716",
".git/objects/29/f22f56f0c9903bf90b2a78ef505b36d89a9725": "e85914d97d264694217ae7558d414e81",
".git/objects/16/d9f492a00f9e2fe0f6b046df0432f8df358b6b": "796640e94823931b0c098e3e21a31d69",
".git/objects/74/6d11237e4664985dd78dc05e29d2f6732cee6d": "6547e09dff17af84ec1e9f26c9927911",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/26/bf348923bfecf349bb954bb25e436a408962a9": "e46fefa57514bece62f99027254202db",
".git/objects/4d/bf9da7bcce5387354fe394985b98ebae39df43": "534c022f4a0845274cbd61ff6c9c9c33",
".git/objects/4d/90cf43798822905213c2ca420ce38ae5536372": "b820d6a9dd1781457abaaedc509e14d0",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/6b/6818103168e02b954b99fb3bd0010f97e7456b": "a73472851b39293562498f4bf73f2fbe",
".git/objects/3a/bf18c41c58c933308c244a875bf383856e103e": "30790d31a35e3622fd7b3849c9bf1894",
".git/objects/98/0d49437042d93ffa850a60d02cef584a35a85c": "8e18e4c1b6c83800103ff097cc222444",
".git/objects/0a/93c5b3b0601ab7b7014a17fb00162d12bb48b9": "931648716d76346c95c96e0bfa5d81dc",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/b8/875e72baa32ae86a75a5457f916834a947c94f": "2edd7d6a779103fa08661bf939f2ee65",
".git/objects/b1/5ad935a6a00c2433c7fadad53602c1d0324365": "8f96f41fe1f2721c9e97d75caa004410",
".git/objects/dc/8dbab2f8e5a56408aa6165874c85d73176f0a8": "1b29b46509660bf283410644d26a5706",
".git/objects/b6/b8806f5f9d33389d53c2868e6ea1aca7445229": "b14016efdbcda10804235f3a45562bbf",
".git/objects/a9/990695a3598a9d182bbbacdb47c6ed6a37c4dd": "77509ff55336a38b91fc7e296bd19947",
".git/objects/a9/c0095e13415b70717e02a3ced2bae6d3154fe7": "c0aec661b5c75079a8ff455c99157e80",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/a8/d0030e6b808f9a246780cfe122dbc3e22e7f18": "b843742581d140068ee1917b0557c7d2",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/ef/5197649ec020ec9714dc04bbae6da98fffabad": "19b39edc147e161b4a6ec4f83268dda7",
".git/objects/c4/016f7d68c0d70816a0c784867168ffa8f419e1": "fdf8b8a8484741e7a3a558ed9d22f21d",
".git/objects/c5/624869f02ed6cfdb3c8eaf3c6e6d31e486a33b": "2a3e7231641d247d20cf8b72cd4c1767",
".git/objects/f8/647d85a29a4f173c906e31d01d01811ae37c0d": "ee61854e8d31af39698dde6e06afa0b0",
".git/objects/ce/09bebffdbfa119bfd8ce40559665b0304442f0": "5e31a100594e5cf3a16c15146aae9405",
".git/objects/1e/f82c1f98c355271d998262b0c38b2ffbf266b3": "c1d4ede6713d4cded52a474d660680b7",
".git/objects/24/336577067b8d8ade8a7b1fd859e7e3a2ee17bd": "fd1f0b7dd1a4fcbc199532e16ed03872",
".git/objects/4f/fbe6ec4693664cb4ff395edf3d949bd4607391": "2beb9ca6c799e0ff64e0ad79f9e55e69",
".git/objects/12/adf4b2cc433725a54ca74b74560496137bf992": "1b2d7f738a8f25feea1ca9571f968e58",
".git/objects/7f/368c018a29987e6414fa5660ddee8cf3aa2800": "5d982ed04d2d53a1df48df5b983067a5",
".git/objects/7a/6c1911dddaea52e2dbffc15e45e428ec9a9915": "f1dee6885dc6f71f357a8e825bda0286",
".git/objects/8e/3a1cdd8819b3c7563d4c1a79fb9b2b9bf760c0": "da0c51ac117fb9121d19ebf38bc6ad23",
".git/HEAD": "5ab7a4355e4c959b0c5c008f202f51ec",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "86e46a5d0be284950bf81c5f1fa621f3",
".git/logs/refs/heads/gh-pages": "86e46a5d0be284950bf81c5f1fa621f3",
".git/logs/refs/remotes/origin/gh-pages": "6c9d3a9a4cfa1174a69d3226f9f5c361",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/pre-rebase.sample": "dc9319712df96e4b8b7d80aaf6a89a3a",
".git/hooks/sendemail-validate.sample": "4d67df3a8d5c98cb8565c07e42be0b04",
".git/hooks/pre-commit.sample": "5029bfab85b1c39281aa9697379ea444",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "bff22a56cae99e478ac195d3729ac799",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/refs/heads/gh-pages": "5fbfa3597bb242e0ec0b096e2dc61037",
".git/refs/remotes/origin/gh-pages": "5fbfa3597bb242e0ec0b096e2dc61037",
".git/index": "f2497d58ac6d064632dfd387e7817870",
".git/COMMIT_EDITMSG": "7d99632be79a67ded261aa7b7add0edf",
"assets/AssetManifest.json": "15c23f4e16494c021b38b32a04d02a53",
"assets/NOTICES": "e81901cf23be59e457b6e90b1373a01d",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/AssetManifest.bin.json": "4d941e5511abf01e8e08000a50f83c96",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "96815f8c612a6897a9779397ed5f6c09",
"assets/fonts/MaterialIcons-Regular.otf": "85ce85cd7f51dbe3405b09c1d50a6297",
"assets/assets/images/mul_hu.png": "951dcac3b984438f3580ab378f4c84fb",
"assets/assets/images/map.png": "81f8a1b6b4ff2eede20f82a6fcbc613e",
"assets/assets/images/img2.jpeg": "126cadd56f0787c14d527cc0ee7d50b7",
"assets/assets/images/img.jpg": "18814e9d3edf2f79fe82f14ecfa94f3f",
"assets/assets/images/mul.png": "61ab41ed9b5512e229afafc019ece60d",
"assets/assets/images/img2.jpg": "d8bbd308a543f79d5e768a9bc85c11db",
"assets/assets/images/mul_tem.png": "b3050b83e64ebb3e28991f686db91d65",
"assets/assets/images/map1.png": "aa4fe1971b51cd79936a502c11820405",
"assets/assets/images/map2.png": "4212c6d7705f510e117a9ea432239f38",
"assets/assets/data/data.json": "a29816deeacc498d66aa0aebe00eb954",
"assets/assets/data/mul.json": "86420b9d67829469de132daefa39f104",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
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
        // Claim client to enable caching on first launch
        self.clients.claim();
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
      // Claim client to enable caching on first launch
      self.clients.claim();
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
