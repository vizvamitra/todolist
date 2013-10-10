# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
    window.semaphore = 1
    $('body').css('width', $(document).width());
    $('body').css('height', $(document).height()-20);
    $('#needs').css('min-height', $(document).height()-180)
    $(window).resize ->
        $('body').css('width', $(this).width());
        $('body').css('height', $(this).height()-20);
    $('#need_text').focus()
    $('#need_text').keydown (event) ->
        if event.which == 13
            event.preventDefault();
            event.stopPropagation();
            $('#new_need').post_new_need( $('#need_text').val() )
    $('#new_need').on 'submit', (e) ->
        e.preventDefault()
        $('#new_need').post_new_need( $('#need_text').val() )
    $('.item:not(.completed)').settings()
    $('.complete_doing').click ->
        $(this).complete_doing()

$.fn.update_doing = (text) ->
    if (text != "")
        date = $(this).parent().parent().attr('id')
        $.ajax date,
            type: 'PATCH'
            data: {text: text.replace(/\r?\n/g, "\\n")}
        $(this).parent('.edit').hide()
    else
        $(this).parent('.edit').hide().parent().find(".text").show()
        $(this).val( $(this).parent().parent().find(".text").html() )

$.fn.complete_doing = ->
    $.ajax $(this).parent().parent().attr('id'),
        type: 'PATCH'
        data: { complete: $(this).is(':checked') }

$.fn.settings = ->
    $(this).hover ->
        $(this).css('background-color', '#f6f6f6')
    $(this).mouseleave ->
        $(this).css('background-color', 'white')
    $(this).find('.text').click ->
        $(this).hide()
        edit = $(this).parent().find('.edit')
        edit.show().find('textarea').focus()
    $(this).find('textarea').focusout ->
        $(this).update_doing($(this).val())                
    $(this).find('textarea').autogrow();
    $(this).find('textarea').keydown (event) ->
        if event.which == 13 && event.ctrlKey
            event.preventDefault();
            event.stopPropagation();
            $("#need_text").focus();

$.fn.post_new_need = (text) ->
    if (text != "")
        if (window.semaphore == 1)
            window.semaphore = 0
            $.ajax
                url: "/",
                type: "POST",
                data: { text: text.replace(/\r?\n/g, "\\n") }
            setTimeout (-> window.semaphore = 1), 1000