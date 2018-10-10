$(document).ready(function(){
    console.log('Yes');
    $(document).on('click', '.button-vote', function(e){

        e.preventDefault();
        $("#vote_input").val($(this).data('id'));
        console.log($(this).data('id'));
        $("#vote_form").submit();
    });
});