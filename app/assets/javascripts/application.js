// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require popper
//= require bootstrap-sprockets

//= require rails-ujs
//= require activestorage
// require turbolinks
//= require_tree .


var map;
var marker = [];
var infoWindow = [];
var markerData = gon.shrines;

function initMap() {
  // geocoderを初期化
  geocoder = new google.maps.Geocoder()
  // 詳細ページで見ている場所をマップの中心に表示
  map = new google.maps.Map(document.getElementById('map'), {
    center: {
      lat: gon.shrine.latitude,
      lng: gon.shrine.longitude
    },
    zoom: 14,
  });
  // 詳細ページで見ている場所にマーカーを立てる
  marker = new google.maps.Marker({
    position: {
      lat: gon.shrine.latitude,
      lng: gon.shrine.longitude
    },
    map: map
  });

  // 半径1km以内の登録された場所のデータを繰り返し処理で取得
  for (var i = 0; i < markerData.length; i++) {
    markerLatLng = new google.maps.LatLng({
      lat: markerData[i]['latitude'],
      lng: markerData[i]['longitude']
    });
    // 付近の登録された場所にマーカーを立てる
    marker[i] = new google.maps.Marker({
      position: markerLatLng,
      map: map,
      icon: {
        url: 'https://maps.google.com/mapfiles/ms/icons/blue-dot.png',
        scaledSize: new google.maps.Size(40, 40)
      }
    });
    // マーカーをクリックしたときに出る吹き出しを設定
    let id = markerData[i]['id']
    infoWindow[i] = new google.maps.InfoWindow({
      // 吹き出しの内容、クリックするとその場所のページに飛ぶ
      content: `<a href='/shrines/${ id }'>${ markerData[i]['address'] }</a>`
    });
    markerEvent(i);
  }
  // マーカークリック時の挙動を設定
  function markerEvent(i) {
    marker[i].addListener('click', function () {
    infoWindow[i].open(map, marker[i]);
    });
  }
}


