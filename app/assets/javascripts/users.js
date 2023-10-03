$(document).ready(function () {
    hsize = $(window).height();
    $("my-image").css("height", hsize + "px");
});

$(window).resize(function () {
    hsize = $(window).height();
    $("my-image").css("height", hsize + "px");
});