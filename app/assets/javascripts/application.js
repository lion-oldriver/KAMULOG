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
//= require jcanvas
//= require_tree .

/*global $ gon google geocoder markerLatLng navigator*/
var map;
var marker = [];
var infoWindow = [];
var markerData = gon.shrines;
const KEY = gon.api_key;

function initMap() {
  // geocoderを初期化
  geocoder = new google.maps.Geocoder();
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

  // 半径20km以内の登録された場所のデータを繰り返し処理で取得
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
      content: `<a href='/shrines/${ id }'>${ markerData[i]['name'] }</a>`
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
// 現在地を取得する
$(document).ready(function () {
  $(".location").on("click", function (){
    navigator.geolocation.getCurrentPosition(function (position) {
      var lat = position.coords.latitude;
      var lng = position.coords.longitude;
      // コントローラへデータを送る
      $.ajax({
        url: '/location',
        type: 'GET',
        dataType: 'html',
        async: true,
        data: {
          lat: lat,
          lng: lng
        },
      })
      // 送られたデータをもとに書き換える
      .done (function(response){
        $("body").html(response)
      });
    });
  });
});

// Japan Map表示
$(function(){
    var areas = [
        {code : 1, name: "北海道地方", color: "#7f7eda", hoverColor: "#b3b2ee", prefectures: [1]},
        {code : 2, name: "東北地方",   color: "#759ef4", hoverColor: "#98b9ff", prefectures: [2,3,4,5,6,7]},
        {code : 3, name: "関東地方",   color: "#7ecfea", hoverColor: "#b7e5f4", prefectures: [8,9,10,11,12,13,14]},
        {code : 4, name: "中部地方",   color: "#7cdc92", hoverColor: "#aceebb", prefectures: [15,16,17,18,19,20,21,22,23]},
        {code : 5, name: "近畿地方",   color: "#ffe966", hoverColor: "#fff19c", prefectures: [24,25,26,27,28,29,30]},
        {code : 6, name: "中国地方",   color: "#ffcc66", hoverColor: "#ffe0a3", prefectures: [31,32,33,34,35]},
        {code : 7, name: "四国地方",   color: "#fb9466", hoverColor: "#ffbb9c", prefectures: [36,37,38,39]},
        {code : 8, name: "九州地方",   color: "#ff9999", hoverColor: "#ffbdbd", prefectures: [40,41,42,43,44,45,46]},
        {code : 9, name: "沖縄地方",   color: "#eb98ff", hoverColor: "#f5c9ff", prefectures: [47]},
    ];
    $("#back_btn").hide();
    $("#map-container").empty().japanMap({
        width: 650,
        selection: "prefecture",
        areas: areas,
        drawsBoxLine: false,
        showsPrefectureName: true,
        prefectureNameType: "short",
        movesIslands : true,
        fontSize : 11,
        fontShadowColor : "white",
        onSelect : function(data){
            window.location.href = "/search?utf8=✓&content=" + data.name + "&method=multi&commit=検索";
       }
    });
});
// トップページのメインビジュアル用
$(document).ready(function () {
  $("#main-visual").skippr({
    // スライドショーの変化 ("fade" or "slide")
    transition : 'slide',
    // 変化に係る時間(ミリ秒)
    speed : 1200,
    // easingの種類
    easing : 'easeOutQuart',
    // ナビゲーションの形("block" or "bubble")
    navType : 'none',
    // 子要素の種類("div" or "img")
    childrenElementType : 'div',
    // ナビゲーション矢印の表示(trueで表示)
    arrows : false,
    // スライドショーの自動再生(falseで自動再生なし)
    autoPlay : true,
    // 自動再生時のスライド切替間隔(ミリ秒)
    autoPlayDuration : 3000,
    // キーボードの矢印キーによるスライド送りの設定(trueで有効)
    keyboardOnAlways : true,
    // 一枚目のスライド表示時に戻る矢印を表示するかどうか(falseで非表示)
    hidePrevious : false
  });
});
// 神社詳細ページの神社画像用
$(document).ready(function () {
  $("#shrine-images").skippr({
    transition : 'fade',
    speed : 1000,
    easing : 'easeOutQuart',
    navType : 'none',
    childrenElementType : 'div',
    arrows : false,
    autoPlay : true,
    autoPlayDuration : 3000,
    keyboardOnAlways : true,
    hidePrevious : false
  });
});
// アンダーラインを引く
$(window).scroll(function(){
  $(".underline-light").each(function(){
    var position = $(this).offset().top,
        scroll = $(window).scrollTop(),
        windowHeight = $(window).height();
    if (scroll > position - (windowHeight / 2)){
      $(this).addClass('isActive');
    }
  });
});

$(window).scroll(function(){
  $(".underline-dark").each(function(){
    var position = $(this).offset().top,
        scroll = $(window).scrollTop(),
        windowHeight = $(window).height();
    if (scroll > position - (windowHeight / 2)){
      $(this).addClass('isActive');
    }
  });
});
// 横からフェードイン
$(window).scroll(function (){
  $('.fadein-right').each(function(){
    var position = $(this).offset().top,
        scroll = $(window).scrollTop(),
        windowHeight = $(window).height();
    if (scroll > position - windowHeight + 50){
      $(this).addClass('scrollin');
    }
  });
});

$(window).scroll(function (){
  $('.fadein-left').each(function(){
    var position = $(this).offset().top,
        scroll = $(window).scrollTop(),
        windowHeight = $(window).height();
    if (scroll > position - windowHeight + 50){
      $(this).addClass('scrollin');
    }
  });
});
