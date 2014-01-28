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
    $(this).find('.text').focusout ->
        $(this).linebreak_check()
        $(this).update_need($(this).text())
    $(this).find('.text').keydown (event) ->
        if event.which == 13 && !event.ctrlKey
            event.preventDefault()
            $(this).linebreak_check()
            $("#need_text").focus()
        if event.which == 13 && event.ctrlKey
            $(this).paste_newline()
    $(this).find('.complete_need').click (e) ->
        e.preventDefault();
        $(this).complete_need()
        $('#need_text').focus()
    $(this).find('.delete_need').click (e) ->
        e.preventDefault()
        $(this).remove_need()
        $("#need_text").focus()

$.fn.update_need = (text) ->
    if (!text.match(/^\n+$/) && text!="")
        if (text != $(this).parent().find('.shadow').text())
            date = $(this).parent().attr('id')
            $.ajax
                url: "/"
                type: 'PATCH'
                data: {text: text.replace(/\r?\n/g, "\\n"), date: date}
            $(this).parent().find('.shadow').text(text)
    else
        $(this).text($(this).parent().find('.shadow').text())

$.fn.complete_need = ->
    $.ajax 
        url: "/",
        type: 'PATCH',
        data: { complete: true, date: $(this).parent().parent().attr('id') }

$.fn.post_new_need = (text) ->
    if (text != "")
        if (text.slice(-1) != "\n")
            text += "\n"
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

$.fn.paste_newline = ->
    if (window.getSelection)
        selection = window.getSelection()
        range = selection.getRangeAt(0)
        br = document.createTextNode("\n")
        range.deleteContents();
        range.insertNode(br);
        range.setStartAfter(br);
        range.setEndAfter(br);
        range.collapse(false);
        selection.removeAllRanges();
        selection.addRange(range);

$.fn.linebreak_check = ->
    if ($(this).text().slice(-1) != "\n")
        $(this).text($(this).text() + "\n")