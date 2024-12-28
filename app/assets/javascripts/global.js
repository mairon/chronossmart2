$(function () {
    $('body').css('display', 'block');

    // acopla o item do menu atual a uma tag strong
    $('#nav').find('img.' + $('#__controller_name').val()).parent('div').wrap('<strong/>');

    $('#btnPreview').click(function () {
        var url = $(this).attr('url');
        $('[type=checkbox].check:checked').each(function () {
            window.open(url + $(this).val(), 'Preview' + $(this).val());
        });
    });

    $('#btnDownload').click(function () {
        var url = $(this).attr('url');
        $('[type=checkbox].check:checked').each(function () {
            window.open(url + $(this).val(), 'Download' + $(this).val());
        });
    });

    $('#doaction').click(function () {
        var action = $('#actions').val();
        var id = $('[type=checkbox].check:checked').first().val();

        if (!id) {
            alert('Selecione um registro para aplicar a Ação!');
            return false;
        }

        if (!action) {
            alert('Selecione uma Ação!');
            $('#actions').focus();
        }
        else if (action == 'edit') {
            location.href = $('#_page_url').val() + $('#_params_edit').val() + id;
        }
        else if (action == 'delete') {
            if (confirm('Tem certeza que deseja remover este registro e suas dependências?')) {
                location.href = $('#_page_url').val() + $('#_params_delete').val() + id;
            }
        }

        return;
    });

    // seleciona todos check da grid de acordo com o check_all
    $('.check_all').change(function () {
        var $checked = $(this)[0].checked;
        $(this).parents('table').find('[type=checkbox].check').each(function () {
            $(this)[0].checked = $checked;
        });
    });

    // fecha mensagens
    $('#content .message .close').click(function () {
        $(this).parent().fadeOut('slow', function () { $(this).remove(); });
    });

    // confirmação para deletar
    $('#content table .delete a').click(function () {
        return confirm('Tem certeza que deseja remover este registro e suas dependências?');
    });


    // ao clicar no botao do "fieldset"
    $('.toggle').click(function () {
        var text = $(this).text();
        $(this).text(text == '+' ? '-' : '+');
        $(this).next('.textbox_content').toggle();
    });

    // percorre todos .closed e dispara evento click
    $('.closed').each(function () {
        $(this).find('.toggle').click();
    });

    // upload multifile
    if ($('#logo').length) {
        $('#logo').MultiFile({
            accept: 'gif|jpg',
            max: 1,
            STRING: {
                remove: 'Remover',
                selected: 'Selecionado: $file',
                denied: 'Extensão inválida: $ext',
                duplicate: 'Arquivo já selecionado:\n$file!'
            }
        });
    }

    // se nao existir input "edit-mode" (add)
    if ($('#edit-mode').length == 0) {
        // adiciona meta padrao
        AdicionarMeta($('.tmpl-meta .add-meta'));

        // adiciona menu padrao
        AdicionarMenu($('.tmpl-menu .add-menu'));
    }
    // se existir input "edit-mode" (edit)
    else {
        if ($('#add-one-meta').val() == '1') {
            // adiciona meta padrao
            AdicionarMeta($('.tmpl-meta .add-meta'));
        }

        if ($('#add-one-menu').val() == '1') {
            // adiciona menu padrao
            AdicionarMenu($('.tmpl-menu .add-menu'));
        }
    }
});

function AdicionarMeta(button){
	var clone = $('.tmpl-meta').clone();
	clone.removeClass('tmpl-meta').addClass('item-meta').show();
	clone.insertAfter($(button).parent());
	return false;
}

function AdicionarMenu(button){
	var clone = $('.tmpl-menu').clone();
	clone.removeClass('tmpl-menu').addClass('item-menu').show();
	clone.insertAfter($(button).parent());
	return false;
}