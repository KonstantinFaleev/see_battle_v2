function updateCountdown() {
    // 140 is the max message length
    var remaining = 140 - jQuery('#comment_content').val().length;
    jQuery('.countdown').text(remaining + ' characters remaining');
}

jQuery(document).ready(function($) {
    updateCountdown();
    $('#comment_content').change(updateCountdown);
    $('#comment_content').keyup(updateCountdown);
});