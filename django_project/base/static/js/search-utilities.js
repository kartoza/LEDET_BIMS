
function searchOnMap(event) {
    event.preventDefault();
    if (event.keyCode === 13) {
        location.href = '/map/#search/' + $('#search-on-map').val();
    }
}
