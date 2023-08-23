// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//

//= require jquery
//= require jquery_ujs
//= require jquery-ui/widgets/sortable

//= require dayjs/dayjs.min
//= require dayjs/locale/ja
//= require dayjs/plugin/advancedFormat
//= require dayjs/plugin/localizedFormat
//= require dayjs/plugin/localeData
//= require dayjs/plugin/utc
//= require dayjs/plugin/isMoment
//= require dayjs/plugin/timezone
//= require dayjs/plugin/weekday

//= require popper
//= require bootstrap-sprockets
//= require bootstrap-datetimepicker

//= require cocoon

//= require select2
//= require select2_locale_ja


//= require nprogress
//= require nprogress-turbolinks

dayjs.locale("ja");
dayjs.extend(window.dayjs_plugin_advancedFormat);
dayjs.extend(window.dayjs_plugin_localizedFormat);
dayjs.extend(window.dayjs_plugin_localeData);
dayjs.extend(window.dayjs_plugin_utc);
dayjs.extend(window.dayjs_plugin_isMoment);
dayjs.extend(window.dayjs_plugin_timezone);
dayjs.extend(window.dayjs_plugin_weekday);

var Common = {};

Common.evala = function(data) {
  'use strict';
  var newCode = document.createElement("script");
  newCode.text = "function evala() { "+data+" }";
  document.body.appendChild(newCode);
  evala();
  newCode.parentNode.removeChild( newCode );
 }

function JSON_to_URLEncoded(element,key,list) {
  var list = list || [];
  if(typeof(element)=='object'){
    for (var idx in element)
      JSON_to_URLEncoded(element[idx],key?key+'['+idx+']':idx,list);
  } else {
    list.push(key+'='+encodeURIComponent(element));
  }
  return list.join('&');
}

Common.ajax = function (data) {
  var xhr =  new XMLHttpRequest();
  submitData = data.data || {};
  xhr.onreadystatechange = function () {
    if (xhr.readyState !== 4) {
//      data.error(xhr);
      return false;
    }
    if (xhr.status == 200 && xhr.readyState == 4) {
      if (xhr.getResponseHeader('content-type').includes("text/javascript")) {
        Common.evala(xhr.response);
      }
      data.success(xhr.response);
    } else {
      if (xhr.status !== 200) data.error(xhr);
      return false;
    }
  };
  xhr.open(data.type, data.url, true);
  if (data.type === 'PATCH') xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=utf-8");
  if (data.dataType === 'json') {
    xhr.setRequestHeader("Content-Type", "application/json; charset=utf-8");
    xhr.setRequestHeader("Accept", "application/json; charset=utf-8");
    xhr.responseType = "json";
  }
  xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
  xhr.setRequestHeader('X-CSRF-Token', document.querySelector('meta[name="csrf-token"]').getAttribute('content'));
  xhr.send(JSON_to_URLEncoded(submitData));
};

charactersChange = function(ele) {
  var val = ele.val();
  var han = val.replace(/[．Ａ-Ｚａ-ｚ０-９]/g, function(s) {
    return String.fromCharCode(s.charCodeAt(0)-0xFEE0)
  });
  if(val.match(/[．Ａ-Ｚａ-ｚ０-９]/g)){
    $(ele).val(han);
  }
}

//Аргументы:
//name
//  название cookie
//value
//  значение cookie (строка)
//props
//Объект с дополнительными свойствами для установки cookie:
//  expires
//  Время истечения cookie. Интерпретируется по-разному, в зависимости от типа:
//  Если число - количество секунд до истечения.
//  Если объект типа Date - точная дата истечения.
//  Если expires в прошлом, то cookie будет удалено.
//  Если expires отсутствует или равно 0, то cookie будет установлено как сессионное и исчезнет при закрытии браузера.
//path
//  Путь для cookie.
//domain
//  Домен для cookie.
//secure
//  Пересылать cookie только по защищенному соединению.
// SameSite=Strict; Secure
// SameSite=None; Secure
// SameSite=Lax
function createCookie(name, value, props) {
    props = props || {}
    var exp = props.expires
    if (typeof exp == "number" && exp) {
        var d = new Date()
        d.setTime(d.getTime() + exp*1000)
        exp = props.expires = d
    }
    if(exp && exp.toUTCString) { props.expires = exp.toUTCString() }
    value = encodeURIComponent(value)
    var updatedCookie = name + "=" + value
    for(var propName in props) {
        updatedCookie += "; " + propName
        var propValue = props[propName]
        if(propValue !== true) { updatedCookie += "=" + propValue }
    }
    document.cookie = updatedCookie
}

function readCookie(name) {
  var matches = document.cookie.match(new RegExp("(?:^|; )" + name.replace(/([\.$?*|{}\(\)\[\]\\\/\+^])/g, '\\$1') + "=([^;]*)"))
  return matches ? decodeURIComponent(matches[1]) : undefined
}

function eraseCookie(name) {
  createCookie(name, null, { expires: -1 });
}

// request permission on page load
document.addEventListener('DOMContentLoaded', function () {
  if (!Notification) {
    alert('Desktop notifications not available in your browser. Try Chromium.');
    return;
  }

  if (Notification.permission !== "granted")
    Notification.requestPermission();
});

function notifyMe(title, text) {

  if (Notification.permission !== "granted")
    Notification.requestPermission();
  else {
    var notification = new Notification(title, {
      icon: $('#notify_icon').val(),
      body: text,
    });
//    notification.onclick = function () {
//      window.open("");
//    };
  }
}
function play_single_sound() {
  document.getElementById('audio_notify').play();
}

function getLocation() {
  var x = document.getElementById("geolocation");
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(showPosition, showError);
  } else {
    x.innerHTML = "Geolocation is not supported by this browser.";
  }
}
function showPosition(position) {
  $("#time_card_latitude").val(position.coords.latitude);
  $("#time_card_longitude").val(position.coords.longitude);
}
function showError(error) {
  var x = document.getElementById("geolocation");
  switch(error.code) {
    case error.PERMISSION_DENIED:
      x.innerHTML = "User denied the request for Geolocation."
      break;
    case error.POSITION_UNAVAILABLE:
      x.innerHTML = "Location information is unavailable."
      break;
    case error.TIMEOUT:
      x.innerHTML = "The request to get user location timed out."
      break;
    case error.UNKNOWN_ERROR:
      x.innerHTML = "An unknown error occurred."
      break;
  }
  $("#time_card_latitude").val(x.innerHTML);
  $("#time_card_longitude").val(x.innerHTML);
}
function getMap() {
  var x = document.getElementById("geolocation");
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(showMapPosition, showError);
  } else {
    x.innerHTML = "Geolocation is not supported by this browser.";
  }
}

function showMapPosition(position) {
  lat = position.coords.latitude;
  lon = position.coords.longitude;
  latlon = new google.maps.LatLng(lat, lon)
  mapholder = document.getElementById('mapholder')
  mapholder.style.height = '250px';
  mapholder.style.width = '1024px';
  var myOptions = {
    center:latlon,zoom:14,
    mapTypeId:google.maps.MapTypeId.ROADMAP,
    mapTypeControl:false,
    navigationControlOptions:{style:google.maps.NavigationControlStyle.SMALL}
  }
  var map = new google.maps.Map(document.getElementById("mapholder"), myOptions);
  var marker = new google.maps.Marker({position:latlon,map:map,title:"You are here!"});
}

//function showPosition(position) {
//    var latlon = position.coords.latitude + "," + position.coords.longitude;
//    var img_url = "https://maps.googleapis.com/maps/api/staticmap?center="
//    +latlon+"&zoom=14&size=400x300&sensor=false&key=AIzaSyABZA2iYmmlhZLBtN9qFpyorvG6DL7SZxk";
//    document.getElementById("mapholder").innerHTML = "<img src='"+img_url+"'>";
//}

function init_listbox() {
  $('#btnRight').click(function (e) {
      var selectedOpts = $('#lstBox1 option:selected');
      if (selectedOpts.length == 0) {
          alert("Nothing to move.");
          e.preventDefault();
      }

      $('#lstBox2').append($(selectedOpts).clone());
      $(selectedOpts).remove();
      e.preventDefault();
  });

  $('#btnAllRight').click(function (e) {
      var selectedOpts = $('#lstBox1 option');
      if (selectedOpts.length == 0) {
          alert("Nothing to move.");
          e.preventDefault();
      }

      $('#lstBox2').append($(selectedOpts).clone());
      $(selectedOpts).remove();
      e.preventDefault();
  });

  $('#btnLeft').click(function (e) {
      var selectedOpts = $('#lstBox2 option:selected');
      if (selectedOpts.length == 0) {
          alert("Nothing to move.");
          e.preventDefault();
      }

      $('#lstBox1').append($(selectedOpts).clone());
      $(selectedOpts).remove();
      e.preventDefault();
  });

  $('#btnAllLeft').click(function (e) {
      var selectedOpts = $('#lstBox2 option');
      if (selectedOpts.length == 0) {
          alert("Nothing to move.");
          e.preventDefault();
      }

      $('#lstBox1').append($(selectedOpts).clone());
      $(selectedOpts).remove();
      e.preventDefault();
  });
}

function clear_unread() {
  clearTimeout(timer_unread)
  if ($('#current_view').val() != "rooms")
    return;
  var list = document.getElementById("msg");
  if (!list) return;
  var diff = list.scrollHeight - list.clientHeight
//  console.log('c Diff '+diff);
//  console.log('c ScrollTop '+list.scrollTop);
//  console.log('c MessScrollTop '+mess_scrollTop);
//  console.log('c aaa '+(diff-list.scrollTop));
  timer_unread = setTimeout(clear_unread, 4000);
  if ((diff - list.scrollTop) > 30) {
    return;
  }
  var room_id = $('#message_room_id').val();
  $.ajax({
    url:        '/rooms/set_read_messages',
    dataType:   'json',
    data: {
      receive_id: $('#message_receive_id').val(),
      public_flg: $('#message_public_flg').val()
    },
    success:    function(data) {
      $('.badge_'+room_id).text('');
      $('.badge_nav').text(data.new_msg);
      $('.list-group-item').removeClass('chatMessageSelect');
    },
    error:      function(data) {
      return
    }
  });
}

function move_scroll(mode)
{
  var list = document.getElementById("msg");
  var lis = list.getElementsByTagName("li");
  var nums = lis.length;
  var sum = 0;
  var old_sum = 0;
  var first_new = 0;
  for (i = 0; i < nums; i++) {
    if (lis[i].classList.contains('chatMessageSelect')) {
      sum += lis[i].clientHeight+1;
      if (first_new == 0) first_new = i;
    } else {
      if (first_new == 0) old_sum += lis[i].clientHeight+1;
    }
  }
  var diff = list.scrollHeight -sum - list.clientHeight;
  var value = diff;
  if (diff <= Math.round(list.scrollTop) || mode) {
    if (sum > 0) {
      if (old_sum == 0) {
        value = 0;
      } else {
        value = old_sum + 89 - list.clientHeight;
      }
    }
    list.scrollTop = value;
  }
}

/*セレクトボックスにselect2を適応する */
$(document).ready(function() {
  $('.multiselect-workplace').select2({
      width: '100%',
    });

    $('.multiselect-months').select2({
     width: '100%',
  });
});

