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
        $('#needs').css('min-height', $(this).height()-180)
    $('#need_text').focus()
    $('#need_text').keydown (event) ->
        if event.which == 13
            event.preventDefault();
            event.stopPropagation();
            $('#new_need').post_new_need( $('#need_text').val() )
    $('#new_need').on 'submit', (e) ->
        e.preventDefault()
        $('#new_need').post_new_need( $('#need_text').val() )
    $('.item').each (->
        $(this).settings())

$.fn.settings = ->
    if (!$(this).hasClass("completed"))
        $(this).hover ->
            $(this).css('background-color', '#f6f6f6')
        $(this).mouseleave ->
            $(this).css('background-color', 'white')
        $(this).find('.text').click ->
            $(this).hide()
            edit = $(this).parent().find('.edit')
            edit.show().find('textarea').focus()
    $(this).find('.complete_need').click ->
        $(this).complete_need()
    $(this).find('a').click (e) ->
        e.preventDefault();
        $(this).remove_need()
    $(this).find('textarea').autogrow();
    $(this).find('textarea').focusout ->
        $(this).update_need($(this).val())                
    $(this).find('textarea').keydown (event) ->
        if event.which == 13 && event.ctrlKey
            event.preventDefault();
            event.stopPropagation();
            $("#need_text").focus();
    $(this).css('min-height', $(this).find('.edit').height())

$.fn.update_need = (text) ->
    if (text != "")
        date = $(this).parent().parent().attr('id')
        $.ajax date,
            type: 'PATCH'
            data: {text: text.replace(/\r?\n/g, "\\n")}
        $(this).parent().parent().find(".text").show()
        $(this).parent('.edit').hide()
        $(this).parent().parent().css('min-height', $(this).parent().height())
    else
        $(this).parent().parent().find(".text").show()
        $(this).parent('.edit').hide()
        $(this).val( $(this).parent().parent().find(".text").html() )
        $(this).autogrow();

$.fn.complete_need = ->
    $.ajax $(this).parent().parent().attr('id'),
        type: 'PATCH'
        data: { complete: $(this).is(':checked') }

$.fn.post_new_need = (text) ->
    if (text != "")
        if (window.semaphore == 1)
            window.semaphore = 0
            $.ajax
                url: "/",
                type: "POST",
                data: { text: text.replace(/\r?\n/g, "\\n") }
            setTimeout (-> window.semaphore = 1), 1000

$.fn.remove_need = ->
    $.ajax
        url: "/"+$(this).parent().parent().attr('id'),
        type: "DELETE"