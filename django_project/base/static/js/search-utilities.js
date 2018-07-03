
function searchOnMap(event) {
    event.preventDefault();
    if (event.keyCode === 13) {
        location.href = '/map/?search=' + $('#search-on-map').val();
    }
}

$(document).ready(function () {
    if(location.pathname === '/map/' && location.search.includes('search')){
        setTimeout(function () {
            var search = location.search;
            search = search.replace('?search=', '');
            $('#search').val(search);
            $('.search-control').click();
            var e = $.Event( "keypress", { which: 13 } );
            $('#search').trigger(e);
        }, 1200)
    }
});