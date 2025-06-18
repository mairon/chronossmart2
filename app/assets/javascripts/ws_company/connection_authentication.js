var WS_CONNECTED = false;
var WS_CONNECTING = false;
var PC = new Protocolo_Companytec();
var HeaderOldTankAlarmCount = 0;
var INCREMENT = 0;
var DOWNLOAD_SPEED_ARRAY = [];
var CONECTION_AUTHENTICATION_MUS_INTERVENTION = 0;
var CONECTION_AUTHENTICATION_MUS_INTEGRATION = 0;

function callback_connection(data_json, callback_function) {
    var data_returned = JSON.parse(data_json);
    if (data_returned.status === 200) {
        WS_CONNECTING = false;
        WS_CONNECTED = true;
        let language_id = get_cookie('language');
        let words = $("#status_connection").data('language');
        $("#status_connection").html(words[(Number(language_id) + 5)]);
        $("#status_connection").css('color', 'green');
        general_informations(callback_function)
    } else {
        let language_id = get_cookie('language');
        let words = $("#status_connection").data('language');
        $("#status_connection").html(words[language_id - 1]);
        $("#status_connection").css('color', 'red');
        WS_CONNECTED = false;
        swal({
            type: 'error',
            text: 'NÃ£o foi possÃ­vel conectar com o concentrador',
            timer: 5000
        }).then((result) => {
            erase_cookie('token');
            erase_cookie('level');
            erase_cookie('pump_management');
            erase_cookie('tank_measurement');
            erase_cookie('environmental_monitoring');
            erase_cookie('reconciliation');
            erase_cookie('integration_mus');
            erase_cookie('glp_probe_type');
            var page = window.location.pathname.substring((window.location.pathname).lastIndexOf("/") + 1, window.location.pathname.length);
            if (page !== "/login.html") { 
                window.location.href = "/login.html";
            }
        })

    }
}
function showinitialModal() {
    // console.log('hide')
    var myModal = $('#ExemploModalCentralizado');
    myModal.modal({
        backdrop: 'static', 
        keyboard: false 
    });
    clearTimeout(myModal.data('hideInterval'));
    myModal.data('hideInterval', setTimeout(function () {
        myModal.modal('hide');
        sessionStorage.setItem('dontLoad', 'false')
    }, 4100));
};

function connecting(callback_function) {
    if (sessionStorage.getItem('dontLoad') == 'true') {
        showinitialModal();
    }
    else {
        block_screen("Conectando e verificando sessÃ£o...");
    }
    PC.open_connection(callback_connection, callback_function);
    WS_CONNECTING = true;
    let language_id = get_cookie('language');
    let words = $("#status_connection").data('language');
    $("#status_connection").html(words[(Number(language_id) + 2)]);
    $("#status_connection").css('color', 'orange');
}

function general_informations(callback_function) {
    PC.send_command('read', 'general_informations', null, callback_general_informations, callback_function);
}

function callback_general_informations(data_json, callback_function) {
    var data = JSON.parse(data_json);

    // console.log(data.data)
    if (data.status === 200) {
        if (data.state == 'success') {
            set_cookie("language", data.data.id_language, 1);
            set_label_language(data.data.id_language);
            login(callback_function);
            if (!data.data.client_name || !data.data.cnpj_client || !data.data.cep_client) {
                if (window.location.pathname != "/login.html") {
                    swal({
                        type: 'error',
                        text: 'Preencha os dados o posto',
                        timer: 5000
                    });

                    if (window.location.pathname != "/view/configuracoes/cad_posto.html") {
                        // console.log(window.location.pathname)
                        window.location.assign("/view/configuracoes/cad_posto.html");
                    }
                }
            }
            data.data.mus_integration_enabled == '1' ? $("#LI-MENU-MUS").css('display', 'block') : $("#LI-MENU-MUS").css('display', 'none')
            CONECTION_AUTHENTICATION_MUS_INTERVENTION = data.data.mus_intervention_enabled
            CONECTION_AUTHENTICATION_MUS_INTEGRATION = data.data.mus_integration_enabled
            $("#header_client_name").html(data.data.client_name)
            $("#header_cnpj_client").html(data.data.cnpj_client)
            $("#header_cep_client").html(data.data.cep_client)
        } else {
            swal({
                type: 'error',
                text: data.data.message
            }).then((result) => {
                erase_cookie('token');
                erase_cookie('level');
                erase_cookie('pump_management');
                erase_cookie('tank_measurement');
                erase_cookie('environmental_monitoring');
                erase_cookie('reconciliation');
                erase_cookie('integration_mus');
                erase_cookie('glp_probe_type');
                var page = window.location.pathname.substring((window.location.pathname).lastIndexOf("/") + 1, window.location.pathname.length);
                if (page !== "/login.html") {
                    window.location.href = "/login.html";
                }
            })
        }
    } else {
        swal({
            type: 'error',
            text: data.data.message
        });
    }
    if (window.location.pathname == '/login.html') {
        license()
    }

}

function callback_warning(words) {
    let language_id = get_cookie('language');
    swal({
        type: 'warning',
        text: words[(Number(language_id) - 1)],
        timer: 5000
    });
}

function set_label_language(language_id) {
    set_cookie("language", language_id, 1);
    $(".div-language").each(function (index) {
        let words = $(this).data('language');
        let words2 = $(this).data('language2');
        $(this).attr('data-content', words[(Number(language_id) - 1)]);
        $(this).attr('data-original-title', words2[(Number(language_id) - 1)]);
    });
    $(".label-language").each(function (index) {
        let words = $(this).data('language');
        $(this).html(words[(Number(language_id) - 1)]);
    });
    $(".input-language").each(function (index) {
        let words = $(this).data('language');
        $(this).prop('placeholder', words[(Number(language_id) - 1)]);
    });
    $('select').selectpicker('destroy');
    $(".option-language").each(function (index) {
        let words = $(this).data('language');
        $(this).text(words[(Number(language_id) - 1)]);
    });
    $("select").each(function (index) {
        $(this).addClass('selectpicker');
    });
    // $('.selectpicker').selectpicker('refresh');
    let imgs = ["/imagens/idioma/011-brazil.svg",
        "/imagens/idioma/016-spain.svg",
        "/imagens/idioma/020-flag.svg"];
    $.each([imgs], function (index, value) {
        $(".m-topbar__language-selected-img").attr("src", value[(Number(language_id) - 1)]);
    });

}


function login(callback_function) {
    var token = get_cookie('token');
    if (token) {
        var interval = setInterval(function () {
            if (WS_CONNECTED) {
                PC.send_command('publish', 'login', '{"token":"' + token + '"}', callback_login, callback_function);
                clearInterval(interval);
            }
        }, 1000);
    } else {
        var page = window.location.pathname.substring((window.location.pathname).lastIndexOf("/") + 1, window.location.pathname.length);
        if (page !== "login.html") {
            window.location.href = "#";
        }
        swal.close();
        //$(".btn").removeClass("m-loader m-loader--right m-loader--light").attr("disabled", !1);
    }
}

function callback_login(data_json, callback_function) {
    var data = JSON.parse(data_json);
    // console.log(data.data)
    if (data.status === 200) {
        if (data.state === 'success') {
            swal.close();
            $("#user_name_header").html(data.data.user_name);
            $("#user_level_header").html(data.data.level);
            if (data.data.sap_code !== "-1") {
                $("#sap_code").html(data.data.sap_code);
            }

            session_informations(callback_function);
        } else {
            swal({
                type: 'error',
                text: data.data.message
            }).then((result) => {
                erase_cookie('token');
                erase_cookie('level');
                erase_cookie('pump_management');
                erase_cookie('tank_measurement');
                erase_cookie('environmental_monitoring');
                erase_cookie('reconciliation');
                erase_cookie('integration_mus');
                erase_cookie('glp_probe_type');
                var page = window.location.pathname.substring((window.location.pathname).lastIndexOf("/") + 1, window.location.pathname.length);
                if (page !== "/login.html") {
                    window.location.href = "/login.html";
                }
            })
        }
    } else {
        swal({
            type: 'error',
            text: data.data.message
        });
    }
    $('.selectpicker').selectpicker('refresh');
    $("#btn_login").removeClass("m-loader m-loader--right m-loader--light").attr("disabled", !1);
    $("#btn_login_certificado").removeClass("m-loader m-loader--right m-loader--light").attr("disabled", !1);
}

function session_informations(callback_function) {
    if (WS_CONNECTED) PC.send_command('read', 'session_informations', null, callback_session_informations, callback_function);
}

function callback_session_informations(data_json, callback_function) {
    var data = JSON.parse(data_json);
    if (data.status === 200) {
        if (data.state) {
            $("#certificate_expiration").html(data.data.certificate_expiration_date);
            $("#session_expiration").html(data.data.session_expiration_date);

            tank_alarms_count(callback_function);
        } else {
            swal({
                type: 'error',
                text: data.data.message
            })
        }
    } else {
        swal({
            type: 'error',
            text: data.data.message
        });
    }
}

function tank_alarms_count(callback_function) {
    if (WS_CONNECTED) PC.send_command('read', 'tank_alarms_count', '{"only_pending":"1","id_alarm_level":"0","tank":"0"}', callback_tank_alarms_count, callback_function);
}

function callback_tank_alarms_count(data_json, callback_function) {

    var data = JSON.parse(data_json);
    if (data.status === 200) {
        if (data.state) {
            $("#badge_has_alarm").css('display', 'none');
            if (data.data.quantity > 0) {
                $("#badge_has_alarm").css('display', 'block');
            }
            HeaderOldTankAlarmCount = parseInt(data.data.quantity);
            $("#badge_n_alarm").attr('data-alarms', data.data.quantity);
            $("#tank_alarm_notification").text(data.data.quantity);

            leak_sensor_alarms_count(callback_function);
        } else {
            swal({
                type: 'error',
                text: data.data.message
            }).then((result) => {
                erase_cookie('token');
                erase_cookie('level');
                erase_cookie('pump_management');
                erase_cookie('tank_measurement');
                erase_cookie('environmental_monitoring');
                erase_cookie('reconciliation');
                erase_cookie('integration_mus');
                erase_cookie('glp_probe_type');
                var page = window.location.pathname.substring((window.location.pathname).lastIndexOf("/") + 1, window.location.pathname.length);
                if (page !== "/login.html") {
                    window.location.href = "/login.html";
                }
            })
        }
    } else {
        swal({
            type: 'error',
            text: data.data.message
        });
    }
    $("#btn_login").removeClass("m-loader m-loader--right m-loader--light").attr("disabled", !1);
    $("#btn_login_certificado").removeClass("m-loader m-loader--right m-loader--light").attr("disabled", !1);
}

function leak_sensor_alarms_count(callback_function) {
    PC.send_command('read', 'leak_sensor_alarms_count', '{"only_pending":"1","id_alarm_level":"0","address":"0"}', callback_leak_sensor_alarms_count, callback_function);
}

function callback_leak_sensor_alarms_count(data_json, callback_function) {
    var data = JSON.parse(data_json);
    if (data.status === 200) {
        if (data.state) {
            // let total = parseInt($("#badge_n_alarm").data('alarms'))+parseInt(data.data.quantity);
            let total = HeaderOldTankAlarmCount + parseInt(data.data.quantity);
            if (data.data.quantity > 0) {
                $("#badge_has_alarm").css('display', 'block');
            }
            $("#badge_n_alarm").text(total);
            $("#dropdown__header_n_alarm").text(total);
            $("#sensor_alarm_notification").text(data.data.quantity);
            swal.close();
            if (callback_function !== undefined) callback_function(data.data);
        } else {
            swal({
                type: 'error',
                text: data.data.message
            }).then((result) => {
                erase_cookie('token');
                erase_cookie('level');
                erase_cookie('pump_management');
                erase_cookie('tank_measurement');
                erase_cookie('environmental_monitoring');
                erase_cookie('reconciliation');
                erase_cookie('integration_mus');
                erase_cookie('glp_probe_type');
                var page = window.location.pathname.substring((window.location.pathname).lastIndexOf("/") + 1, window.location.pathname.length);
                if (page !== "/login.html") {
                    window.location.href = "/login.html";
                }
            })
        }
    } else {
        swal({
            type: 'error',
            text: data.data.message
        });
    }
    $("#btn_login").removeClass("m-loader m-loader--right m-loader--light").attr("disabled", !1);
    $("#btn_login_certificado").removeClass("m-loader m-loader--right m-loader--light").attr("disabled", !1);
}

function logout() {
    PC.send_command('publish', 'logout', null, callback_logout, null);
}

function callback_logout(data_json) {
    //console.log(data_json);
    var data = JSON.parse(data_json);
    if (data.status === 200) {
        if (data.state) {
            swal.close();
            erase_cookie('token');
            erase_cookie('level');
            erase_cookie('pump_management');
            erase_cookie('tank_measurement');
            erase_cookie('environmental_monitoring');
            erase_cookie('reconciliation');
            erase_cookie('integration_mus');
            erase_cookie('glp_probe_type');
            window.location.href = "/login.html";
        } else {
            swal({
                type: 'error',
                text: data.data.message
            });
        }
    } else {
        swal({
            type: 'error',
            text: data.data.message
        });
    }
}

function set_cookies(data_returned) {
    set_cookie("token", data_returned.data.token, 1);
    set_cookie("level", data_returned.data.level, 1);
    window.location.href = "/view/home.html";
}

function set_cookie(name, value, days) {
    var expires = "";
    if (days) {
        var date = new Date();
        date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
        expires = "; expires=" + date.toUTCString();
    }
    document.cookie = name + "=" + value + expires + "; path=/";
}

function get_cookie(name) {
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for (var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') c = c.substring(1, c.length);
        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length, c.length);
    }
    return null;
}

function erase_cookie(name) {
    document.cookie = name + '=; Path=/; Expires=Thu, 01 Jan 1970 00:00:01 GMT;';
}

function notify(message, data_json) {
    // console.log('notify');
    // console.log(message);
    // console.log(data_json); 
    if (data_json === null) {
        let language_id = get_cookie('language');
        switch (message) {
            case 'alarm_viewed':
                if (window.location.pathname == "/view/tanque/arquivos/tanque_alarme.html" || window.location.pathname == "/view/sensor_ambiental/arquivos/sensor_alarme.html") {
                    type = 'warning';
                    // console.log(language_id)
                    let msg = ['Alarme visualizado', 'Alarma visualizada', 'Alarm viewed']
                    swal({
                        type: type,
                        text: msg[(Number(language_id) - 1)],
                    })
                }
                tank_alarms_count();
                break;
            case 'starting_update':
                type = 'warning';
                swal({ 
                    type: type,
                    text: message
                }).then((result) => {
                    window.location.href = "/login.html";
                });
                break;
            case 'canceled_shutdown':
                let language_id = get_cookie('language');
                let msg_CanceledLowBatteryShutdown = ['Cancelado desligamento.', 'Apagado cancelado.', 'Shutdown canceled.'];
                swal({
                    type: 'success',
                    text: msg_CanceledLowBatteryShutdown[(Number(language_id) - 1)]
                })
                break;
            default:
                swal({
                    type: 'warning',
                    text: message
                })
                break;
        }
    } else {
        let data = JSON.parse(data_json);
        let type;

        switch (message) {
            case 'tag_read':
                if (window.location.pathname == "/view/configuracoes/usuario.html" && ($("#modalTag").data('bs.modal') || {})._isShown) {
                    if (data.ds_fid != 0) {
                        $("#rfid_tag").val('');
                        swal({
                            type: "warning",
                            text: "CartÃ£o jÃ¡ tem DSFID cadastrado"
                        });
                    } else {
                        $("#rfid_tag").val(data.tag_code)
                        swal.close();
                    }
                    // if ($("#rfid_tag").text)
                    //     swal.fire({
                    //         type: "success",
                    //         text: "incluÃ­do",
                    //         timer: 1000
                    //     });
                    // else {
                    //     swal({
                    //         type: "error",
                    //         text: "erro ao incluir"
                    //     });
                    // }
                    // type = 'warning';
                    // message = data.tag_code + ' - ' + data.ds_fid;
                    // swal({
                    //     type: type,
                    //     text: message
                    // });
                    return;
                }
                // _isShown  Bootstrap 4, isShown Bootstrap <= 3
                else if (window.location.pathname == "/view/bombas/identificadores.html" && ($("#modalTag").data('bs.modal') || {})._isShown) {
                    $("#tag_txt").val(data.tag_code)
                    // recordTagAutomatic();
                    // type = 'warning';
                    // message = data.tag_code + ' - ' + data.ds_fid;
                    // swal({
                    //     type: type,
                    //     text: message
                    // });
                    return;

                }
                else if (window.location.pathname == "/view/bombas/identificadores.html") {
                    idf_tags();
                    type = 'warning';
                    message = data.tag_code + ' - ' + data.ds_fid;
                    swal({
                        type: type,
                        text: message
                    });
                }

                break;

            case 'tank_alarm':
                if (window.location.pathname == "/view/tanque/arquivos/tanque_alarme.html") {
                    criticality_levels();
                    swal({
                        type: 'warning',
                        text: message
                    })
                }
                else
                    if (window.location.pathname != "/login.html") {
                        switch (data.level) {
                            case "1":
                            case "2":
                                type = 'warning';
                                message = 'Tanque ' + data.tank_number + ' - ' + data.id_alarm_type + ' - ' + data.alarm_message + ' - ' + data.fuel_type_name + ' - ' + data.value + ' - ' + data.limit_value;
                            case "3":
                                type = 'error';
                                message = 'Tanque ' + data.tank_number + ' - ' + data.alarm_message;
                                break;
                        }
                        swal({
                            type: type,
                            text: message
                        }).then((result) => {
                            tank_alarms_count();
                        })
                    }
                break;
            case 'leak_sensor_alarm':
                // console.log(data);
                if (window.location.pathname == "/view/sensor_ambiental/arquivos/sensor_alarme.html") {
                    criticality_levels();
                    let split_message = message.split('-')
                    swal({
                        type: 'warning',
                        text: `Sensor ${Number(split_message[0]) - 64}: ${split_message[1]}`
                    })
                }
                else if (window.location.pathname != "/login.html") {
                    switch (data.level) {
                        case "1":
                        case "2":
                            type = 'warning';
                            message = data.tank_number + ' - ' + data.id_alarm_type + ' - ' + data.alarm_message + ' - ' + data.fuel_type_name + ' - ' + data.value + ' - ' + data.limit_value;
                        case "3":
                            type = 'error';
                            message = data.tank_number + ' - ' + data.alarm_message;
                            break;
                    }
                    let split_message = message.split('-')
                    swal({
                        type: 'warning',
                        text: `Sensor ${Number(split_message[0]) - 64}: ${split_message[1]}`
                    }).then((result) => {
                        leak_sensor_alarms_count();
                    })
                }
                break;
            case 'language_change':
                type = 'success';
                set_label_language(data.id);
                swal({
                    type: type,
                    text: data.message
                });
                $('.selectpicker').selectpicker('refresh');
                break;
            case 'schedule_shutdown':
                let language_id = get_cookie('language');
                let msg_ScheduleShutdown = ['Equipamento desligarÃ¡ em ', 'El equipamento se apagarÃ¡ en ', 'Equipment will shut down on '];
                let msg_ScheduleTimeShutdown = [' minuto', ' minuto', ' minute'];
                swal({
                    type: 'warning',
                    text: msg_ScheduleShutdown[(Number(language_id) - 1)] + data.message + msg_ScheduleTimeShutdown[(Number(language_id) - 1)],
                    showConfirmButton: false,
                    html: "",
                    allowOutsideClick: false
                }, function () { });
                break;
            case 'starting_shutdown':
                if (data.message == 'busy') {
                    swal({
                        type: 'error',
                        text: 'Desligamento pela tecla nÃ£o autorizado: Bombas em uso.'
                    })
                } else {
                    swal({
                        type: 'error',
                        text: message
                    }).then((result) => {
                        window.location.href = "/login.html";
                    });
                }
                break;
            case 'download_update_progress':
                if (INCREMENT == 0) {
                    $('#download_speed_KB_s').html(data.download_speed_KB_s)
                    $('#MBytes_downloaded').html(data.MBytes_downloaded)
                    $('#estimated_update_time').html(Math.round((Number(data.MBytes_total) - Number(data.MBytes_downloaded)) * 1000 / ((Number(data.download_speed_KB_s) + 0.01))))
                }
                INCREMENT++;
                let percent_download = Math.round(((Number(data.MBytes_downloaded) / (Number(data.MBytes_total) + 0.01)) * 100))
                $('#modalUpdatingProgress').modal('show');
                $('#MBytes_total').html(data.MBytes_total)
                $("#progress_updating").css("width", percent_download + "%")
                $("#countdown-holder_updating").html(percent_download + "%")
                DOWNLOAD_SPEED_ARRAY.push(Number(data.download_speed_KB_s))
                if (INCREMENT % 20 == 0) {
                    $('#MBytes_downloaded').html(data.MBytes_downloaded)
                    let total = DOWNLOAD_SPEED_ARRAY.reduce((total, atual) => {
                        return total + atual;
                    });
                    let new_time = (Number(data.MBytes_total) - Number(data.MBytes_downloaded)) * 1000 / (((total / DOWNLOAD_SPEED_ARRAY.length) + 0.01))
                    $('#estimated_update_time').html(Math.round(new_time))
                    $('#download_speed_KB_s').html(Math.round(total / DOWNLOAD_SPEED_ARRAY.length))
                    DOWNLOAD_SPEED_ARRAY = []
                }
                break;
            default:
                swal({
                    type: 'warning',
                    text: message
                })
                break;
        }
    }
}

function end_tank_configuration() {
    // console.log(window)
    PC.send_command('publish', 'configuring_console', '{"action": "0"}', callback_configuring_console, null);
}

function callback_configuring_console(data_json) {
    var data = JSON.parse(data_json);
    // console.log(data);
    if (data.status !== 200) {
        swal({
            type: 'error',
            text: data.data.message
        });
    } else {
        if (data.state == 'success') {
        } else {
            swal({
                type: 'error',
                text: data.data.message
            });
        }
    }
}

// window.onpopstate = end_tank_configuration();
function license() {
    PC.send_command('read', 'license', null, callback_license);
}

function callback_license(data_json) {
    var data_returned = JSON.parse(data_json);
    switch (data_returned.status) {
        case 200:
            if (data_returned.state == 'success') {
                set_cookie("pump_management", data_returned.data.pump_management, 1);
                set_cookie("tank_measurement", data_returned.data.tank_measurement, 1);
                set_cookie("environmental_monitoring", data_returned.data.environmental_monitoring, 1);
                set_cookie("reconciliation", data_returned.data.reconciliation, 1);
                set_cookie("integration_mus", data_returned.data.integration_mus, 1);
                set_cookie("glp_probe_type", data_returned.data.glp_probe_type, 1);
            } else {
                swal({
                    type: 'error',
                    text: data_returned.data.message
                })
            }
            break;
        case 400:
            swal({
                type: 'error',
                text: data_returned.data.message
            });
            break;
        case 500:
            setTimeout(function () {
                select_nozzles_status();
            }, 1000);
            break;
    }
}