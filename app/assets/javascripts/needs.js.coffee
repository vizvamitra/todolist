# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
    $('body').css('width', $(document).width());
    $('body').css('height', $(document).height()-10);
    $('#need_text').focus()
    $('.item:not(.completed)').settings()
    $('.complete_doing').click ->
        $(this).complete_doing()

$.fn.update_doing = (text) ->
    $.ajax $(this).parent().parent().attr('id'),
        type: 'PATCH'
        data: {text: text}
    $(this).parent('.edit').hide()

$.fn.complete_doing = ->
    $.ajax $(this).parent().parent().attr('id'),
        type: 'PATCH'
        data: { complete: $(this).is(':checked') }

$.fn.settings = ->
    $(this).hover ->
        $(this).css('background-color', '#f0ffff')
    $(this).mouseleave ->
        $(this).css('background-color', 'white')
    $(this).find('.text').click ->
        $(this).hide()
        edit = $(this).parent().find('.edit')
        edit.show().find('textarea').focus()
        edit.find('textarea').focusout ->
            $(this).update_doing($(this).val())
    $(this).find('textarea').autogrow();
    $(this).find('textarea').keydown (event) ->
        if event.which == 13 && !event.ctrlKey
            event.preventDefault();
            event.stopPropagation();
            $(this).update_doing($(this).val())
        else if event.which == 13
            $(this).val($(this).val() + "\n");