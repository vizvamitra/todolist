# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
    window.semaphore = 1
    $('#need_text').autogrow().focus()
    $('#need_text').unbind('keydown').keydown (event) ->
        if event.which == 13  && !event.ctrlKey
            event.preventDefault()
            event.stopPropagation()
            $('#new_need').post_new_need( $('#need_text').val() )
        if event.which == 13  && event.ctrlKey            
            $('#need_text').val( $('#need_text').val()+'\n' )
    $('#add').click (e) ->
        e.preventDefault()
        $('#new_need').post_new_need( $('#need_text').val() )
        $("#need_text").focus()
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
    $(this).find('.complete_need').unbind('click').click (e) ->
        e.preventDefault();
        $(this).complete_need()
    $(this).find('.delete_need').unbind('click').click (e) ->
        e.preventDefault()
        $(this).remove_need()
        $("#need_text").focus()
    $(this).find('textarea').autogrow()
    $(this).find('textarea').unbind('focusout').focusout ->
        $(this).update_need($(this).val())
    $(this).find('textarea').unbind('keydown').keydown (event) ->
        if event.which == 13 && event.ctrlKey
            event.preventDefault()
            event.stopPropagation()
            $("#need_text").focus()
    $(this).css('min-height', $(this).find('.edit').height())

$.fn.update_need = (text) ->
    if (text != "")
        if (text != $(this).parent().parent().find(".text").html())
            date = $(this).parent().parent().attr('id')
            $.ajax
                url: "/"
                type: 'PATCH'
                data: {text: text.replace(/\r?\n/g, "\\n"), date: date}
        $(this).parent().parent().find(".text").show()
        $(this).parent('.edit').hide()
        $(this).parent().parent().css('min-height', $(this).parent().height())
    else
        $(this).parent().parent().find(".text").show()
        $(this).parent('.edit').hide()
        $(this).val( $(this).parent().parent().find(".text").html() )

$.fn.complete_need = ->
    $.ajax 
        url: "/",
        type: 'PATCH',
        data: { complete: true, date: $(this).parent().parent().attr('id') }
    $('#need_text').focus()

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
        url: "/",
        type: "DELETE",
        data: { date: $(this).parent().parent().attr('id') }