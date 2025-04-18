$(document).ready(function() {
        initializers();

        $('#createQrcodeBtn').click(function() {
                $.ajax({
                        url: '/whatsapp/qrcode',
                        type: 'GET',
                        data: { token: 'M6alkCCgKyF', instance: 'megastart-M6alkCCgKyF' },
                        success: function(data) {
                                $('#qrCodeImg').attr('src', data.qrcode);
                        }
                });
        });

        $('#whatsappLogoutBtn').click(function() {
                $.ajax({
                        url: '/whatsapp/logout',
                        type: 'GET',
                        data: { token: 'M6alkCCgKyF', instance: 'megastart-M6alkCCgKyF' },
                        success: function(data) {
                                if(data.error == false) {
                                        location.reload();
                                } else {
                                        console.log(data,message);
                                }
                        }
                });
        });
});

function initializers() {
        $.ajax({
                url: '/whatsapp/status',
                type: 'GET',
                data: { token: 'M6alkCCgKyF', instance: 'megastart-M6alkCCgKyF' },
                success: function(data) {
                        if(data.message == 'connected') {
                                $('#whatsappStatus').text('Conectado');
                                $('#whatsappStatus').addClass('btn-success');

                                $('#whatsappLogoutBtn').show();
                        } else {
                                console.log(data.message);
                                $('#whatsappStatus').text('Desconectado');
                                $('#whatsappStatus').addClass('btn-danger');

                                $('#whatsappLogoutBtn').hide();
                        }
                }
        });
}
