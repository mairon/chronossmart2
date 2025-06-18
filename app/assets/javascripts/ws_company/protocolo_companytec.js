var SHOW_CONSOLE = false;
var SUPER_SHOW_CONSOLE = false;
let lastClickTime = 0;
let clickTimes = [];

class Protocolo_Companytec extends EventTarget {
	#count = 0;
	#ws_companytec;
	#data;

	constructor() {
		super();
		this.#count = 0;
		this.#data = [];
	}

	open_connection = function (callback, callback_function) {
		if (this.#data['open_connection'] == undefined) this.#data['open_connection'] = [];
		this.#data['open_connection']['callback'] = callback;
		this.#data['open_connection']['callback_function'] = callback_function;
		if (this.#ws_companytec === undefined || this.#ws_companytec.websocket.readyState === 3) {
			this.#ws_companytec = new WS_Companytec(this);
			this.#ws_companytec.connect();
		}
	}

	error_connection = function () {
		if (this.#count < 2) {
			this.#count++;
			this.open_connection(this.#data['open_connection']['callback'], this.#data['open_connection']['callback_function']);
		} else {
			this.#count = 0;
			this.call_callback('open_connection', 500, false, '{"message": "Sem comunicaÃ§Ã£o com o concentrador"}');
			//this.open_connection(this.#data['open_connection']['callback']);
		}
	}

	call_callback(name, status, state, data) {
		var json_data = '{"status": ' + status + ', "state": "' + state + '", "data": ' + data + '}';
		// console.log(name);
		// console.log(this.#data);
		try {
			this.#data[name]['callback'](json_data, this.#data[name]['callback_function']);
		} catch (error) {
			console.log(error);
			console.log("Callback function not informed");
		}
	}

	send_command = function (type, command, parameters, callback, callback_function, options) {
		this.#send_command(type, command, parameters, callback, callback_function, options);
	}

	#send_command = function (type, command, parameters, callback, callback_function, options) {
		if (SHOW_CONSOLE) {
			console.log(`Envio:\n  type: ${type}\n  command: ${command}\n  parameters: ${parameters}`);
		}
		if (SUPER_SHOW_CONSOLE) {
			console.log(`%cEnvio:\n  type: ${type}\n  command: ${command}\n  parameters: ${parameters}`, "color: #FF0");
		}
		var parameters = JSON.parse(parameters);
		this.#data[command] = [];
		this.#data[command]['data'] = [];
		this.#data[command]['callback'] = callback;
		this.#data[command]['callback_function'] = callback_function;
		if (options)
			this.#data[command]['options'] = options;

		//console.log(this.#data);
		if (this.#ws_companytec !== undefined && this.#ws_companytec.websocket.readyState === 1) {
			if (parameters === null) {
				this.#ws_companytec.websocket.send(type + ";" + command);
			} else {

				switch (command) {
					case 'icom_informations':
					case 'power_supply_informations':
					case 'diagnosis':
					case 'leak_sensors_status':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.period);
						break;
					case 'license':
					case 'new_license':
					case 'bits_mus_console_state':
					case 'instant_tank_inventory_report':
					case 'instant_sales_by_fuel_type_report':
					case 'pwn_informations':
					case 'arching_tables':
					case 'pwn_sockets':
					case 'report_destinations':
					case 'type_printers':
					case 'probe_types':
					case 'auxiliary_outputs':
						this.#ws_companytec.websocket.send(type + ";" + command);
						break;
					case 'nozzles_status':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.period + ";" + parameters.nozzle);
						break;

					case 'nozzle_config_information':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.nozzle);
						break;
					case 'calendar':
					case 'calendar_update':
						if (command == 'calendar_update') command = 'calendar';
						if (parameters.type == 'automatic')
							this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.type);
						else
							this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.type + ";" + parameters.day + ";" + parameters.month + ";" + parameters.year + ";" + parameters.hour + ";" + parameters.minute);
						break;
					case 'update_configs':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.id_group + ";" + parameters.automatic_upgrade + ";" + parameters.server_update_address);
						break;
					case 'allow_shutdown_by_key':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.allow_shutdown_by_key);
						break;
					case 'tank_alarm_acknowledgement':
					case 'leak_sensor_alarm_acknowledgement':
						let dynamic_parameters = '';
						for (let index in parameters.ids) {
							dynamic_parameters += ';' + parameters.ids[index];
						}
						this.#ws_companytec.websocket.send(type + ";" + command + dynamic_parameters);
						break;
					case 'auxiliary_outputs_alarm_types':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.id_auxiliary_output + ";" + parameters.id_alarm_type);
						break;
					case 'auxiliary_output_alarm_type':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.id);
						break;
					case 'apply_update':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.options);
						break;
					case 'supplies':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.offset + ";" + parameters.limit + ";" + parameters.nozzle + ";" + parameters.date_init + ";" + parameters.date_end + ";" + parameters.card_attendant + ";" + parameters.card_client + ";" + parameters.fuel_code);
						break;
					case 'external_meter_configs':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.ip + ";" + parameters.port);
						break;
					case 'sales_by_fuel_types_report':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.id_fuel_type + ";" + parameters.date_init + ";" + parameters.date_end);
						break;
					case 'nozzle_information':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.period + ";" + parameters.nozzle);
						break;
					case 'tank_alarms_count':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.only_pending + ";" + parameters.id_alarm_level + ";" + parameters.tank);
						break;
					case 'tank_alarms':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.only_pending + ";" + parameters.id_alarm_level + ";" + parameters.offset + ";" + parameters.limit + ";" + parameters.tank);
						break;
					case 'discharges':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.offset + ";" + parameters.limit + ";" + parameters.tank + ";" + parameters.date_init + ";" + parameters.date_end);
						break;
					case 'leak_sensor_alarms':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.only_pending + ";" + parameters.id_alarm_level + ";" + parameters.offset + ";" + parameters.limit + ";" + parameters.address);
						break;
					case 'arching_table':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.type + ";" + parameters.name + ";" + parameters.brand + ";" + parameters.volume + ";" + parameters.radius + ";" + parameters.id_unit_length + ";" + parameters.id_unit_volume);
						break;
					case 'configuring_console':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.action);
						break;
					case 'printer_informations':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.id_type_printer);
						break;
					case 'enable_mus_intervention':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.enable_mus_intervention);
						break;
					case 'pwn_channel':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.channel);
						break;
					case 'pwn_dac':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.dac);
						break;
					case 'swc_virtual_channel':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.socket + ";" + parameters.virtual_channel + ";" + parameters.enable_address_1 + ";" + parameters.enable_address_2 + ";" + parameters.enable_address_3 + ";" + parameters.enable_address_4);
						break;
					case 'arching_table_informations':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.name);
						break;
					case 'tank_models':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.brand + ";" + parameters.volume);
						break;
					case 'printer':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.id_type_printer + ";" + parameters.ip + ";" + parameters.port);
						break;
					case 'inactivity_time':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.backlight_time);
						break;
					case 'sufficiency_of_reconciliation_data':
					case 'reconciliation_arching_table_comparison':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.tank + ";" + parameters.curves_to_complete_arching);
						break;
					case 'calibrated_arching_table':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.tank);
						break;
					case 'telemetry_operator':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.number);
						break;
					case 'mqtt_conecttec_config':
					case 'mqtt_companytec_config':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.url + ";" + parameters.port);
						break;
					case 'telemetry_destinations':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.id);
						break;
					case 'volume_difference_of_reconciliation_data':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.tank + ";" + parameters.curves + ";" + parameters.curves_to_complete_arching);
						break;
					case 'save_user':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.user + ";" + parameters.password);
						break;
					case 'leak_sensor_alarms_count':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.only_pending + ";" + parameters.id_alarm_level + ";" + parameters.address);
						break;
					case 'tanks_status':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.repeat + ";" + parameters.tank);
						break;
					case 'email_alarm_types':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.id_email + ";" + parameters.id_alarm);
						break;
					case 'auxiliary_output_alarm_types':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.id_auxiliary_output + ";" + parameters.time + ";" + parameters.recurrence + ";" + parameters.id_alarm_type);
						break;
					case 'language':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.id_language);
						break;
					case 'probe_id':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.old_id + ";" + parameters.new_id);
						break;
					case 'probe_id_by_serial_number':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.serial_number + ";" + parameters.new_id);
						break;
					case 'audio_volum':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.volum);
						break;
					case 'product_movement_report':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.tank + ";" + parameters.offset + ";" + parameters.limit);
						break;
					case 'tank_inventory_historic':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.tank + ";" + parameters.datetime_init + ";" + parameters.datetime_end);
						break;
					case 'tank_informations':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.tank_number);
						break;
					case 'network_config':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.dhcp + ";" + parameters.ip + ";" + parameters.mask + ";" + parameters.gateway + ";" + parameters.hostname + ";" + parameters.broadcast_ip);
						break;
					case 'mus_network_configs':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.ip + ";" + parameters.mask + ";" + parameters.gateway + ";" + parameters.network + ";" + parameters.dns1 + ";" + parameters.dns2 + ";" + parameters.dhcp);
						break;
					case 'cloud_debug':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.tank_measurements + ";" + parameters.discharges + ";" + parameters.reconciliation_data + ";" + parameters.events);
						break;
					case 'reports':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.id_email + ";" + parameters.id_report_type + ";" + parameters.id_report_destiny);
						break;
					case 'emails_alarm_types':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.id_email);
						break;
					case 'send_email_test':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.name + ";" + parameters.email);
						break;
					case 'station_informations':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.cnpj_client + ";" + parameters.client_name + ";" + parameters.cep_client);
						break;
					case 'tag_recording':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.action + ";" + parameters.flag_ctrl + ";" + parameters.start_shift_A + ";" + parameters.end_shift_A + ";" + parameters.start_shift_B + ";" + parameters.end_shift_B);
						break;
					case 'tank_model':
						if (type == 'update') {
							this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.id_tank_model + ";" + parameters.new_arching_table_name);
						}
						else {
							this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.name);
						}
						break;
					case 'idf_tags':
						if (type == 'delete') {
							this.#ws_companytec.websocket.send(type + ";" + command);
						} else {
							this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.offset + ";" + parameters.limit + ";" + parameters.id + ";" + parameters.name + ";" + parameters.tag);
						}
						break;
					case 'idf_tag':
						if (type == 'create' || type == 'update') {
							this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.flag_ctrl + ";" + parameters.tag_txt + ";" + parameters.usr_ctrl + ";" + parameters.name + ";" + parameters.discount + ";" + parameters.user_code + ";" + parameters.fuel_mask);
						}
						else if (type == 'delete') {
							this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.tag_txt);
						}
						break;
					case 'tank':
						if (type == 'create' || type == 'update') {
							this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.name + ";" + parameters.number + ";" + parameters.id_fuel_type + ";" + parameters.id_tank_model + ";" + parameters.id_limits_profile + ";" + parameters.height_in_the_manhole + ";" + parameters.height_at_discharge_mouth + ";" + parameters.inclination_offset + ";" + parameters.probe_offset + ";" + parameters.alarm_on_probe_failure + ";" + parameters.id_probe_type + ";" + parameters.probe_iso_address + ";" + parameters.probe_iso_channel);
						}
						else if (type == 'delete') {
							this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.number);
						}
						break;
					case 'report':
						if (type == 'create') {
							this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.id_email + ";" + parameters.id_report_type + ";" + parameters.id_report_destiny + ";" + parameters.hour);
						}
						else if (type == 'delete') {
							this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.id_report);
						}
						break;
					case 'leak_sensor':
						if (type == 'create' || type == 'update') {
							this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.address + ";" + parameters.name);
						}
						else if (type == 'delete') {
							this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.address);
						}
						break;
					case 'leak_sensor_id':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.old_id + ";" + parameters.new_id);
						break;
					case 'user':
						if (type == 'create') {
							this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.name + ";" + parameters.user_name + ";" + parameters.password + ";" + parameters.level + ";" + parameters.rfid_tag);
						}
						else if (type == 'update') {
							this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.name + ";" + parameters.user_name + ";" + parameters.level + ";" + parameters.rfid_tag + ";" + parameters.old_password + ";" + parameters.new_password);
						}
						else if (type == 'delete') {
							this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.user_name);
						}
						break;
					case 'fuel':
						if (type == 'create' || type == 'update') {
							this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.name + ";" + parameters.density + ";" + parameters.thermal_coefficient + ";" + parameters.color + ";" + parameters.sysgrade + ";" + parameters.anp_name + ";" + parameters.anp_id + ";" + parameters.mvc_id + ";" + parameters.id_fuel_type);
						}
						else if (type == 'delete') {
							this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.name);
						}
						break;
					case 'email':
						if (type == 'create' || type == 'update') {
							this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.name + ";" + parameters.email);
						}
						else if (type == 'delete') {
							this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.email);
						}
						break;
					case 'limits_profile':
						if (type == 'create' || type == 'update') {
							this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.name + ";" + parameters.overflow + ";" + parameters.high_level + ";" + parameters.delivery + ";" + parameters.low_level + ";" + parameters.high_water + ";" + parameters.critical_level);
						}
						else if (type == 'delete') {
							this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.name);
						}
						break;
					case 'login':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.token);
						break;
					case 'login_user':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.user_name + ";" + parameters.password);
						break;
					case 'events':
						this.#ws_companytec.websocket.send(type + ";" + command + ";" + parameters.offset + ";" + parameters.limit + ";" + parameters.date_init + ";" + parameters.date_end);
						break;
					case 'login_certificate':
						var that = this;
						var file = $('#' + parameters.certificate)[0].files[0];
						var fileReader = new FileReader();
						fileReader.readAsBinaryString(file);
						fileReader.onloadend = function () {
							var certificate = fileReader.result;
							that.#ws_companytec.websocket.send(type + ";" + command + ";" + certificate);
						};
						break;
					case 'publish_hrs':
						this.#ws_companytec.websocket.send(type + ";" + parameters.command);
						break;
					case 'publish_cbc':
						this.#ws_companytec.websocket.send(type + ";" + parameters.command);
						break;
					default:
						this.call_callback(command, 400, false, '{"message": "Comando nÃ£o encontrado"}');
				}
			}
		} else {
			// this.call_callback(command, 500, false, '{"message": "Sem comunicaÃ§Ã£o com o concentrador"}');

		}
	}

	// handlePaste(event) {
	// 	event.preventDefault(); // Impede o comportamento padrÃ£o de colagem
	// 	var that = this;
	// 	let items = event.clipboardData.items;
	// 	for (let i = 0; i < items.length; i++) {
	// 		let item = items[i];
	// 		console.log(item.kind)
	// 		if (item.kind === 'file') {
	// 			let file = item.getAsFile();
	// 			let fileExtension = file.name.split('.').pop().toLowerCase();
	// 			if (fileExtension !== 'crt') {
	// 				alert('Arquivo invÃ¡lido. Por favor, cole um arquivo .crt');
	// 				return;
	// 			}
	// 			let fileReader = new FileReader();
	// 			fileReader.readAsBinaryString(file);
	// 			fileReader.onloadend = function () {
	// 				var certificate = fileReader.result;
	// 				that.#data['login_certificate'] = [];
	// 				that.#data['login_certificate']['data'] = [];
	// 				that.#data['login_certificate']['callback'] = callback_login_user;
	// 				that.#ws_companytec.websocket.send("publish;login_certificate;" + certificate);
	// 			};}
	// 			else 			if (item.kind === 'string') {
	// 				item.getAsString(function (text) {
	// 					console.log('Pasted string:', text);
	// 					that.#data['login_certificate'] = [];
	// 					that.#data['login_certificate']['data'] = [];
	// 					that.#data['login_certificate']['callback'] = callback_login_user;
	// 					that.#ws_companytec.websocket.send("publish;login_certificate;" + text);
	// 				})
	// 		} else {
	// 			alert('Por favor, cole um arquivo .crt');
	// 			return
	// 		}
	// 	}
	// }
	// handleDragDrop(event) {
	// 	event.preventDefault(); // Impede o comportamento padrÃ£o de colagem
	// 	var that = this;
	// 	var files = event.dataTransfer.files;
	//     if (files.length === 0) {
	//         alert('No file selected!');
	//         return;
	//     }

	//     var file = files[0];
	//     var fileExtension = file.name.split('.').pop().toLowerCase();

	//     if (fileExtension !== 'crt') {
	//         alert('Invalid file type. Please upload a .crt file.');
	//         return;
	//     }

	//     var fileReader = new FileReader();
	//     fileReader.readAsBinaryString(file);
	//     fileReader.onloadend = function () {
	//         var certificate = fileReader.result;
	// 		that.#data['login_certificate'] = [];
	// 		that.#data['login_certificate']['data'] = [];
	// 		that.#data['login_certificate']['callback'] = callback_login_user;
	// 		that.#ws_companytec.websocket.send("publish;login_certificate;" + certificate);}
	// }


	filter_data = function (data_returned) {
		if (SHOW_CONSOLE) {
			console.log(`Retorno: ${data_returned}`,);
		}
		if (SUPER_SHOW_CONSOLE) {
			console.log(`%cRetorno: ${data_returned}`, "color: #5F5");
		}
		var data_return = [];
		var data_parts = data_returned.split('#');
		if (data_parts[0] == 'notify') {
			var title;
			var json_data;
			// console.log(data_parts);
			if (data_parts.length == 2) { }

			title = data_parts[1];
			var object;
			var parameters = data_parts[2].split('|');
			switch (data_parts[1]) {
				case 'create_idf_tag':
					if (window.location.pathname == "/view/bombas/identificadores.html") {
						feedbackIdfRecovery(data_parts);
					}
					break;
				case 'tag_read':
					object = new NotifyTagRead(parameters[0], parameters[1]);
					notify(title, JSON.stringify(object));
					break;
				case 'tank_alarm':
					object = new NotifyTankAlarm(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6]);
					notify(title, JSON.stringify(object));
					break;
				case 'download_update_progress':
					object = new DownloadUpdateProgress(parameters[0], parameters[1], parameters[2]);
					notify(title, JSON.stringify(object));
					break;
				case 'leak_sensor_alarm':
					object = new NotifySensorLeakAlarm(parameters[0], parameters[1], parameters[2], parameters[3]);
					notify(title, JSON.stringify(object));
					break;
				case 'language_change':
					object = new Language(parameters[0]);
					notify(title, JSON.stringify(object));
					break;
				case 'schedule_shutdown':
					object = new Shutdown(parameters[0]);
					notify(title, JSON.stringify(object));
					break;
				case 'starting_shutdown':
					object = new Shutdown(parameters[0]);
					notify(title, JSON.stringify(object));
					break;
				case 'psu_update_available':
					notify(data_parts[2], null);
					break;
				default:
					notify(data_parts[data_parts.length - 1], null);
					break;
			}
		} else {
			var data_type = data_parts[0];
			var data_function = data_parts[1];
			var state = data_parts[2];
			var data = data_parts[3];
			var wait_eof = false;
			if (state === "success" && data) {
				switch (data_function) {
					case 'calendar':
						var calendar = data;
						var object = new Calendar(calendar);
						break;
					case 'update_group_types':
						wait_eof = true;
						var update_group_types = data.split(';');
						if (update_group_types[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = update_group_types[0].split('|');
						var object = new UpdateGroupTypes(parameters[0], parameters[1]);
						break;
					case 'nozzles_mapping':
						var nozzles_mapping = data.split(';');
						var object = [];
						for (var index in nozzles_mapping) {
							var parameters = nozzles_mapping[index].split('|');
							object.push(new NozzleMapping(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4]));
						}
						object = object.slice(0, object.length - 1);
						break;
					case 'power_supply_informations':
						var power_supply_informations = data;
						var parameters = power_supply_informations.split('|');
						var object = new PowerSupplyInformation(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9], parameters[10], parameters[11], parameters[12], parameters[13], parameters[14], parameters[15], parameters[16], parameters[17], parameters[18], parameters[19]);
						break;
					case 'network_informations':
						var network_informations = data;
						var parameters = network_informations.split('|');
						var object = new NetworkInformation(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9]);
						break;
					case 'mus_network_configs':
						var mus_network_configs = data;
						var parameters = mus_network_configs.split('|');
						var object = new MusNetworkConfigs(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6]);
						break;
					case 'cloud_debug':
						wait_eof = true;
						var cloud_debug = data.split(';');
						if (cloud_debug[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = cloud_debug[0].split('|');
						var object = new CloudDebug(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4]);
						break;

					case 'pump_configs':
						wait_eof = true;
						var pump_configs = data.split(';');
						if (pump_configs[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = pump_configs[0].split('|');
						var object = new PumpConfig(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9], parameters[10], parameters[11], parameters[12], parameters[13], parameters[14], parameters[15], parameters[16], parameters[17], parameters[18], parameters[19], parameters[20], parameters[21], parameters[22], parameters[23], parameters[24]);
						break;
					case 'pump_hardware_types':
						wait_eof = true;
						var pump_hardware_types = data.split(';');
						if (pump_hardware_types[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = pump_hardware_types[0].split('|');
						var object = new PumpHardwareType(parameters[0]);
						break;
					case 'pump_protocol_types':
						wait_eof = true;
						var pump_protocol_types = data.split(';');
						if (pump_protocol_types[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = pump_protocol_types[0].split('|');
						var object = new PumpProtocolType(parameters[0]);
						break;
					case 'criticality_levels':
						wait_eof = true;
						var criticality_levels = data.split(';');
						if (criticality_levels[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = criticality_levels[0].split('|');
						var object = new CriticalityLevel(parameters[0], parameters[1]);
						break;
					case 'icom_informations':
						var icom_informations = data.split(';');
						var object = [];
						for (var index in icom_informations) {
							var parameters = icom_informations[index].split('|');
							object.push(new IcomInformations(parameters[0], parameters[1], parameters[2], parameters[3]));
						}
						object = object.slice(0, object.length - 1);
						break;

					case 'telemetry_informations':

						var telemetry_informations = data.split(';');
						for (var index in telemetry_informations) {
							var parameters = telemetry_informations[index].split('|');
							var object = new TelemetryInformations(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9], parameters[10], parameters[11], parameters[12]);
						}
						break;

					case 'telemetry_operators':
						wait_eof = true;
						var telemetry_operators = data.split(';');
						if (telemetry_operators[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = telemetry_operators[0].split('|');
						var object = new TelemetryOperators(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5]);
						break;
					case 'pending_shipping_destinations':
						wait_eof = true;
						var pending_shipping_destinations = data.split(';');
						if (pending_shipping_destinations[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = pending_shipping_destinations[0].split('|');
						var object = new PendingShippingDestinations(parameters[0], parameters[1]);
						break;

					case 'idf_tags':
						this.#data[data_function]['options'] == "export" ? wait_eof = false : wait_eof = true;
						var idf_tags = data.split(';');
						if (idf_tags[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = idf_tags[0].split('|');
						var object = new Identifier(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9], parameters[10], parameters[11], parameters[12], parameters[13]);
						break;
					case 'general_informations':
						var informations = data.split(';');
						for (var index in informations) {
							var parameters = informations[index].split('|');
							var object = new GeneralInformation(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9], parameters[10], parameters[11], parameters[12], parameters[13], parameters[14], parameters[15], parameters[16], parameters[17], parameters[18]);
						}
						break;
					case "active_probes":
						var active_probes = data.split(';');
						var object = [];
						for (var index in active_probes) {
							var parameters = active_probes[index].split('|');
							object.push(new ActiveProbes(parameters[0], parameters[1]));
						}
						break;
					case "scan_probe_serial_numbers":
						wait_eof = true;
						var scan_probe_serial_numbers = data.split(';');
						if (scan_probe_serial_numbers[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = scan_probe_serial_numbers[0].split('|');
						var object = new ScanProbeSerialNumbers(parameters[0], parameters[1]);
						break;
					case "active_leak_sensors":
						var active_sensor = data.split(';');
						var object = [];
						for (var index in active_sensor) {
							if (!active_sensor[index]) {
								break;
							}
							var parameters = active_sensor[index].split('|');
							object.push(new ActiveLeakSensor(parameters[0], parameters[1]));
						}
						break;
					case "external_meter_configs":
						var external_meter_configs = data.split(';');
						var object = [];
						for (var index in external_meter_configs) {
							if (!external_meter_configs[index]) {
								break;
							}
							var parameters = external_meter_configs[index].split('|');
							object.push(new ExternalMeterConfigs(parameters[0], parameters[1]));
						}
						break;
					case "leak_sensors_status":
						var sensors = data.split(';');
						var object = [];
						for (let index = 0; index < sensors.length; index++) {
							var parameters = sensors[index].split('|');
							object.push(new LeakSensorStatus(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5]));
						}
						break;
					case "supplies":
						this.#data[data_function]['options'] == "export" ? wait_eof = false : wait_eof = true;
						var supplies = data.split(';');
						console.log(supplies)
						if (supplies[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = supplies[0].split('|');
						var object = new Supply(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9], parameters[10], parameters[11], parameters[12], parameters[13], parameters[14], parameters[15], parameters[16], parameters[17], parameters[18], parameters[19], parameters[20], parameters[21], parameters[22], parameters[23]);
						break;
					case "sales_by_fuel_types_report":
						wait_eof = true;
						var supplies = data.split(';');
						if (supplies[0] === "EOF") {
							var object = "EOF";
							break;
						} 
						var parameters = supplies[0].split('|');
						var object = new salesByFuelTypesReport(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7]);
						break;
					case "diagnosis":
						var diagnostics = data.split(';');
						var object = [];
						for (var index in diagnostics) {
							if ((index + 1) == diagnostics.length) break;
							var parameters = diagnostics[index].split('|');
							object.push(new Diagnosis(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9], parameters[10], parameters[11], parameters[12], parameters[13]));
						}
						break;
					case "license":
						var license = data.split(';');
						var parameters = license[0].split('|');
						var object = new License(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5]);
						break;
					case "new_license":
						var license = data.split(';');
						var parameters = license[0].split('|');
						var object = new NewLicense(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5]);
						break;
					case "nozzles_status":
						var nozzles_status = data.split(';');
						var object = [];
						for (var index in nozzles_status) {
							var parameters = nozzles_status[index].split('|');
							object.push(new NozzleStatus(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6]));
						}
						break;
					case "nozzle_config_information":
						var nozzle_config_information = data.split(';');
						var object = [];
						for (var index in nozzle_config_information) {
							var parameters = nozzle_config_information[index].split('|');
							object.push(new NozzleConfigInformation(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6]));
						}
						break;
					case "nozzle_information":
						var nozzle_information = data.split(';');
						for (var index in nozzle_information) {
							var parameters = nozzle_information[index].split('|');
							var object = new NozzleInformation(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9]);
						}
						break;
					case "tanks_status":
						var tanks_status = data.split(';');
						var object = [];
						for (var index in tanks_status) {
							var parameters = tanks_status[index].split('|');
							object.push(new TankStatus(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9], parameters[10], parameters[11], parameters[12], parameters[13], parameters[14]));
						}
						break;
					case "tank_alarms":
						this.#data[data_function]['options'] == "export" ? wait_eof = false : wait_eof = true;
						var tank_alarms = data.split(';');
						if (tank_alarms[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = tank_alarms[0].split('|');
						var object = new TankAlarms(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9], parameters[10], parameters[11], parameters[12], parameters[13], parameters[14], parameters[15], parameters[16], parameters[17]);
						break;
					case "discharges":
						this.#data[data_function]['options'] == "export" ? wait_eof = false : wait_eof = true;
						var discharges = data.split(';');
						if (discharges[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = discharges[0].split('|');
						var object = new Discharges(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9], parameters[10], parameters[11], parameters[12], parameters[13], parameters[14], parameters[15], parameters[16], parameters[17], parameters[18], parameters[19], parameters[20], parameters[21], parameters[22], parameters[23], parameters[24]);
						break;
					case "emails":
						wait_eof = true;
						var emails = data.split(';');
						if (emails[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = emails[0].split('|');
						var object = new Emails(parameters[0], parameters[1], parameters[2]);
						break;
					case "emails_alarm_types":
						wait_eof = true;
						var emails = data.split(';');
						if (emails[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = emails[0].split('|');
						var object = new EmailsAlarmTypes(parameters[0], parameters[1], parameters[2]);
						break;
					case 'reports':
						wait_eof = true;
						var events = data.split(';');
						if (events[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = events[0].split('|');
						var object = new EmailsReportTypes(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8]);
						break;
					case "alarm_types":
						wait_eof = true;
						var emails = data.split(';');
						if (emails[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = emails[0].split('|');
						var object = new AlarmTypes(parameters[0], parameters[1]);
						break;
					case "update_details":
						var update_details = data.split(';');
						var object = [];
						for (var index in update_details) {
							if (update_details[index] == '') continue;
							var parameters = update_details[index].split('|');
							object.push(new UpdateDetails(parameters[0], parameters[1], parameters[2], parameters[3]));
						}
						break;
					case "report_types":
						wait_eof = true;
						var emails = data.split(';');
						if (emails[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = emails[0].split('|');
						var object = new ReportTypes(parameters[0], parameters[1]);
						break;
					case "leak_sensor_alarms":
						this.#data[data_function]['options'] == "export" ? wait_eof = false : wait_eof = true;
						var leak_sensor_alarms = data.split(';');
						if (leak_sensor_alarms[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = leak_sensor_alarms[0].split('|');
						var object = new LeakSensorAlarms(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9], parameters[10]);
						break;
					case "leak_sensors":
						wait_eof = true;
						var leak_sensors = data.split(';');
						if (leak_sensors[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = leak_sensors[0].split('|');
						var object = new LeakSensor(parameters[0], parameters[1]);
						break;
					case 'leak_sensor_alarms_count':
						var leak_sensor_alarms_count = data.split(';');
						var parameters = leak_sensor_alarms_count[0].split('|');
						var object = new LeakSensorAlarmsCount(parameters[0]);
						break;
					case 'tank_alarms_count':
						var tank_alarms_count = data.split(';');
						var parameters = tank_alarms_count[0].split('|');
						var object = new TankAlarmsCount(parameters[0]);
						break;
					case 'arching_table_informations':
						var arching_table_informations = data.split(';');
						var object = new ArchingTableInformations(arching_table_informations[0]);
						break;
					case 'arching_table':
						var object = [];
						var parameters = data.split('\n');
						for (var index in parameters) {
							var fields = parameters[index].split(';');
							object.push(new ArchingTable(fields[0], fields[1]));
						}
						break;
					case "pwn_informations":
						var pwn_informations = data.split(';');
						var object = [];
						for (var index in pwn_informations) {
							var parameters = pwn_informations[index].split('|');
							var object = new PwnInformations(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7]);
						}
						break;

					case "arching_tables":
						wait_eof = true;
						var fuel_types = data.split(';');
						if (fuel_types[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = fuel_types[0].split('|');
						var object = new ArchingTables(parameters[0]);
						break;
					case "fuel_types":
						wait_eof = true;
						var fuel_types = data.split(';');
						if (fuel_types[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = fuel_types[0].split('|');
						var object = new FuelType(parameters[0], parameters[1]);
						break;
					case "measure_units_of_length":
						wait_eof = true;
						var measure_units_of_length = data.split(';');
						if (measure_units_of_length[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = measure_units_of_length[0].split('|');
						var object = new MeasureUnitsOfLength(parameters[0], parameters[1], parameters[2]);
						break;
					case "measure_units_of_volume":
						wait_eof = true;
						var measure_units_of_volume = data.split(';');
						if (measure_units_of_volume[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = measure_units_of_volume[0].split('|');
						var object = new MeasureUnitsOfVolume(parameters[0], parameters[1], parameters[2]);
						break;
					case "fuels":
						wait_eof = true;
						var fuel_types = data.split(';');
						if (fuel_types[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = fuel_types[0].split('|');
						var object = new Fuels(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9], parameters[10]);
						break;
					case "product_movement_report":
						wait_eof = true;
						var product_movement_report = data.split(';');
						if (product_movement_report[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = product_movement_report[0].split('|');
						var object = new ProductMovementReport(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7]);
						break;

					case "version_informations":
						var version_informations = data.split(';');
						var object = [];
						for (var index in version_informations) {
							var parameters = version_informations[index].split('|');
							var object = new VersionInformations(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7]);
						}
						break;
					case "search_update":
						var search_update = data.split(';');
						var object = [];
						for (var index in search_update) {
							var parameters = search_update[index].split('|');
							var object = new SearchUpdate(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4]);
						}
						break;
					case "sufficiency_of_reconciliation_data":
						var curves_to_complete_arching = data.split(';');
						var object = [];
						var object = new SufficiencyOfReconciliationData(curves_to_complete_arching);
						break;
					case "volume_difference_of_reconciliation_data":
						wait_eof = true;
						var curves = data.split(';');
						if (curves[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var object = new VolumeDifferenceOfReconciliationData(curves[0]);
						break;
					case "reconciliation_arching_table_comparison":
					case "reconciliation_arching_table_comparison_mae":
						wait_eof = true;
						data_function = 'reconciliation_arching_table_comparison';
						var curves_to_complete_arching = data.split(';');
						if (curves_to_complete_arching[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var object = new ReconciliationArchingTableComparison(curves_to_complete_arching[0]);
						break;
					case "users":
						wait_eof = true;
						var users = data.split(';');
						if (users[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = users[0].split('|');
						var object = new ListUser(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5]);
						break;

					case 'tank_models':
						wait_eof = true;
						var tank_models = data.split(';');
						if (tank_models[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = tank_models[0].split('|');
						var object = new TankModel(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7] , parameters[8], parameters[9]);
						break;
					case 'tank_informations':
						var tank_alarms_count = data.split(';');
						var parameters = tank_alarms_count[0].split('|');
						var object = new TankInformations(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9], parameters[10], parameters[11], parameters[12], parameters[13], parameters[14], parameters[15], parameters[16], parameters[17], parameters[18], parameters[19], parameters[20], parameters[21], parameters[22], parameters[23], parameters[24], parameters[25], parameters[26], parameters[27], parameters[28], parameters[29]);

						break;
					case 'pwn_sockets':
						wait_eof = true;
						var pwn_sockets = data.split(';');
						if (pwn_sockets[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = pwn_sockets[0].split('|');
						var object = new PwnSockets(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9], parameters[10], parameters[11], parameters[12], parameters[13], parameters[14], parameters[15], parameters[16], parameters[17], parameters[18], parameters[19], parameters[20]);
						break;
					case 'report_destinations':
						wait_eof = true;
						var report_destinations = data.split(';');
						if (report_destinations[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = report_destinations[0].split('|');
						var object = new ReportDestinations(parameters[0], parameters[1]);
						break;
					case 'tanks':
						wait_eof = true;
						var tanks = data.split(';');
						if (tanks[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = tanks[0].split('|');
						var object = new Tank(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9], parameters[10], parameters[11], parameters[12]);
						break;
					case 'type_printers':
						wait_eof = true;
						var type_printers = data.split(';');
						if (type_printers[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = type_printers[0].split('|');
						var object = new TypePrinters(parameters[0], parameters[1]);
						break;
					case 'probe_types':
						wait_eof = true;
						var probe_types = data.split(';');
						if (probe_types[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = probe_types[0].split('|');
						var object = new ProbeTypes(parameters[0], parameters[1], parameters[2]);
						break;
					case 'auxiliary_outputs':
						wait_eof = true;
						var auxiliary_outputs = data.split(';');
						if (auxiliary_outputs[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = auxiliary_outputs[0].split('|');
						var object = new AuxiliaryOutputs(parameters[0], parameters[1]);
						break;
					case 'auxiliary_outputs_alarm_types':
						wait_eof = true;
						var auxiliary_outputs_alarm_types = data.split(';');
						if (auxiliary_outputs_alarm_types[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = auxiliary_outputs_alarm_types[0].split('|');
						var object = new AuxiliaryOutputsAlarmTypes(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6]);
						break;
					case 'printer_informations':
						var printer_informations = data.split(';');
						var parameters = printer_informations[0].split('|');
						var object = new PrinterInformations(parameters[0], parameters[1], parameters[2], parameters[3]);
						break;
					case "limits_profiles":
						wait_eof = true;
						var limits_profiles = data.split(';');
						if (limits_profiles[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = limits_profiles[0].split('|');
						var object = new LimitsProfile(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7]);
						break;
					case "login":
						var login = data.split(';');
						for (var index in login) {
							var parameters = login[index].split('|');
							var object = new Login(parameters[0], parameters[1], parameters[2], parameters[3]);
						}
						break;
					case 'session_informations':
						var session_informations = data;
						var parameters = session_informations.split('|');
						var object = new SessionInformation(parameters[0], parameters[1], parameters[2], parameters[3]);
						break;
					case 'locked_certificate':
						var locked_certificate = data;
						var parameters = locked_certificate.split('|');
						var object = new LockedCertificate(parameters[0], parameters[1]);
						break;
					case "login_user":
					case "login_certificate":
						var login = data.split(';');
						for (var index in login) {
							var parameters = login[index].split('|');
							var object = new Login(parameters[0], parameters[1], parameters[2], parameters[3]);
						}
						break;
					case 'events':
						this.#data[data_function]['options'] == "export" ? wait_eof = false : wait_eof = true;
						var events = data.split(';');
						if (events[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = events[0].split('|');
						var object = new EVENT(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7]);
						break;
					case 'tank_inventory_historic':
						this.#data[data_function]['options'] == "export" ? wait_eof = false : wait_eof = true;

						var tank_inventory_historic = data.split(';');
						if (tank_inventory_historic[0] === "EOF") {
							var object = "EOF";
							break;
						}
						var parameters = tank_inventory_historic[0].split('|');
						var object = new TankInventoryHistoric(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8]);
						break;

					case 'idf_tag':
					case 'logout':
					case 'tank':
					case 'fuel_type':
					case 'limits_profile':
					case 'tank_model':
					case 'printer':
					case 'email':
					case 'lock_for_certificate':
					case 'certificate_unlock':
					case 'publish_hrs':
					case 'publish_cbc':
					case 'calibrated_arching_table':
					case 'telemetry_operator':
					case 'telemetry_destinations':
					case 'mqtt_conecttec_config':
					case 'mqtt_companytec_config':
					case 'inactivity_time':
					case 'pwn_dac':
					case 'pwn_channel':
					case 'configuring_console':
					case 'enable_mus_intervention':
					case 'swc_virtual_channel':
					case 'bits_mus_console_state':
						var object = new MessageReturn(data);
						break;
					case 'starting_update':
						var object = new MessageReturn(data_function);
						break;
					default:
						this.parent_object.call_callback(data_function, 500, false, '"Comando nÃ£o encontrado"');
				}
			} else {
				switch (data_function) {
					case 'calendar':
						if (data_type == 'update') data_function = 'calendar_update';
						break;
				}
				var object = new MessageReturn(data);
			}
			if (wait_eof === false) {
				// console.log(this.#data);
				// console.log(data_function);
				// console.log(data_returned); 
				if (this.#data[data_function]) {
					this.call_callback(data_function, 200, state, JSON.stringify(object), this.#data[data_function]['callback_function']);
				} else {
					if (data_parts[0] == 'publish_cbc') {
						state = 'success'
						this.call_callback('publish_cbc', 200, state, JSON.stringify(data_parts[1]), this.#data['publish_cbc']['callback_function']);
					} else {
						let status;
						let language_id = get_cookie('language');
						let command_status = data_parts[1].substr(2, 1);
						let command_error = data_parts[1].substr(3, 1);

						if (isNaN(command_error)) {
							state = 'error';
							var object = 'Retorno ineperado: ' + data_parts[1]
						}
						else if (command_status === "E") {
							state = 'error';
							var object = HorustechProtocol.MESSAGE[command_error][language_id - 1];
						} else if (command_status === "0") {
							state = 'success';
							var object = HorustechProtocol.MESSAGE[command_error][language_id - 1];
						} else {
							state = 'error';
							var object = data_parts[1];
						}
						object += ' (' + data_returned.replace('publish_hrs#', '') + ')';
						console.log(object)
						this.call_callback('publish_hrs', 200, state, JSON.stringify(object), this.#data['publish_hrs']['callback_function']);
					}
				}
			} else {
				if (data === 'EOF') {
					if (this.#data[data_function]) {
						var data_json = JSON.stringify(this.#data[data_function]['data']);
						this.call_callback(data_function, 200, state, data_json, this.#data[data_function]['callback_function']);
						this.#data[data_function]['data'] = [];
					} else {
						console.log("Retorno inesperado");
						var data_json = JSON.stringify(this.#data['publish_hrs']['data']);
						this.call_callback('publish_hrs', 200, state, data_json, this.#data['publish_hrs']['callback_function']);
						this.#data['publish_hrs']['data'] = [];
					}
				} else {
					if (this.#data[data_function]) {
						this.#data[data_function]['data'].push(object);
					} else {
						console.log("Retorno inesperado");
						this.#data['publish_hrs']['data'].push(object);
					}
					//console.log(this.#data[data_function]['data'].length);
				}
			}
		}
	}
}

const expectedIntervals = [250, 200, 200, 300, 560, 250];
const expectedIntervals2 = [400, 200, 300, 560, 250];

const tolerance = 100;
const maxInterval = 800;

$('#footer_webapp_version').on('click', function () {
	const currentTime = new Date().getTime();
	if (lastClickTime === 0) {
		lastClickTime = currentTime;
		clickTimes = [];
	} else {
		const interval = currentTime - lastClickTime;

		if (interval > maxInterval) {
			lastClickTime = 0;
			lastClickTime = currentTime;
			clickTimes = [];
			// console.log('Intervalo muito longo, resetando...');
			return;
		}
		clickTimes.push(interval);
		lastClickTime = currentTime;
	}
	if (clickTimes.length === 5) {
		let isRhythmCorrect = false;
		for (let i = 0; i < clickTimes.length; i++) {
			if (Math.abs(clickTimes[i] - expectedIntervals2[i]) > tolerance) {
				isRhythmCorrect = false;
				break;
			} else {
				isRhythmCorrect = true;
			}
		}
		if (isRhythmCorrect) {
			SHOW_CONSOLE = false;
			toggleDebugMode();
		}
	}

	if (clickTimes.length === 6) {
		let isRhythmCorrect = false;
		for (let i = 0; i < clickTimes.length; i++) {
			if (Math.abs(clickTimes[i] - 100) > tolerance) {
				break;
			} else {
				console.log('Debug Mode');
				SUPER_SHOW_CONSOLE = false;
				SHOW_CONSOLE = true;
				break;
			}
		}
		for (let i = 0; i < clickTimes.length; i++) {
			if (Math.abs(clickTimes[i] - expectedIntervals[i]) > tolerance) {
				isRhythmCorrect = false;
				break;
			} else {
				isRhythmCorrect = true;
			}
		}
		if (isRhythmCorrect) {
			SHOW_CONSOLE = false;
			toggleDebugMode();
		}
		lastClickTime = 0;
		clickTimes = [];
	}
});

function toggleDebugMode() {
	if (SUPER_SHOW_CONSOLE) {
		alert("Stop Super Debug Mode.");
		SUPER_SHOW_CONSOLE = false;
		deleteCookie('SUPER_SHOW_CONSOLE');
		console.log('%cStop Super Debug Mode', "color: red");
	} else {
		const keepActive = confirm("Manter o modo Debug ativo apÃ³s atualizar pÃ¡gina?\nDesativa automaticamente em 10 minutos ou repetindo processo");
		if (keepActive) {
			SUPER_SHOW_CONSOLE = true;
			console.log('%cSuper Debug Mode', "color: #2bf");
			setCookie('SUPER_SHOW_CONSOLE', true, 10);
		}
	}
}

function setCookie(name, value, minutes) {
	let date = new Date();
	date.setTime(date.getTime() + (minutes * 60 * 1000));
	document.cookie = name + "=" + value + "; expires=" + date.toUTCString() + "; path=/";
}

function getCookie(name) {
	let nameEQ = name + "=";
	let ca = document.cookie.split(';');
	for (let i = 0; i < ca.length; i++) {
		let c = ca[i];
		while (c.charAt(0) == ' ') c = c.substring(1, c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length, c.length);
	}
	return null;
}

function deleteCookie(name) {
	document.cookie = name + '=; Path=/; Expires=Thu, 01 Jan 1970 00:00:01 GMT;';
}

function checkDebugModeFromCookie() {
	const showConsoleCookie = getCookie('SUPER_SHOW_CONSOLE');
	if (showConsoleCookie === 'true') {
		SUPER_SHOW_CONSOLE = true;
		console.log('%cDebug Mode (from cookie)', "color: #2bf");
	}
}

// Checa se o modo debug jÃ¡ foi ativado previamente via cookie
checkDebugModeFromCookie();
class WS_Companytec {

	#parent_object;
	#connected;

	constructor(parent_object) {
		this.#parent_object = parent_object;
		this.#connected = false;
		this.websocket = new WebSocket('ws:/' + '132.255.166.179' + ':3005');

	}



	connect = function () {
		var that = this;
		this.websocket.onopen = function (e) {
			that.#connected = true;
			that.#parent_object.call_callback('open_connection', 200, true, '{"message": "ComunicaÃ§Ã£o com o concentrador aberta"}');
		};
		this.websocket.onmessage = function (evt) {
			that.#parent_object.filter_data(evt.data);
			console.log(evt.data)
		};
		this.websocket.onclose = function (event) {
			if (that.#connected) {
				that.#parent_object.call_callback('open_connection', 500, false, '{"message": "Sem comunicaÃ§Ã£o com o concentrador"}');
			}
			that.#connected = false;
		};
		this.websocket.onerror = function (error) {
			if (that.#connected) {
				console.log(error);
			} else {
				that.#parent_object.error_connection();
			}
		};
	}
}

class GeneralInformation {
	constructor(id_language, server_update_address, allow_shutdown_by_key, audio_volum, inactivity_time, serial_number, cpu_serial_number, cpu_hardware_version, manufacture_date, allow_change_price_by_idf_tag, cnpj_client, client_name, cep_client, cbc_enabled, pam_enabled, cmp_enabled, mus_integration_enabled, mus_intervention_enabled, pam_preset_enabled) {
		this.id_language = id_language;
		this.server_update_address = server_update_address;
		this.allow_shutdown_by_key = allow_shutdown_by_key;
		this.audio_volum = audio_volum;
		this.inactivity_time = inactivity_time;
		this.serial_number = serial_number;
		this.cpu_serial_number = cpu_serial_number;
		this.cpu_hardware_version = cpu_hardware_version;
		this.manufacture_date = manufacture_date;
		this.allow_change_price_by_idf_tag = allow_change_price_by_idf_tag;
		this.cnpj_client = cnpj_client;
		this.client_name = client_name;
		this.cep_client = cep_client;
		this.cbc_enabled = cbc_enabled;
		this.pam_enabled = pam_enabled;
		this.cmp_enabled = cmp_enabled;
		this.mus_integration_enabled = mus_integration_enabled;
		this.mus_intervention_enabled = mus_intervention_enabled;
		this.pam_preset_enabled = pam_preset_enabled;
	}
}

class ActiveProbes {
	constructor(id, version) {
		this.id = id;
		this.version = version;
	}
}

class ScanProbeSerialNumbers {
	constructor(serial_number, address) {
		this.serial_number = serial_number;
		this.address = address;
	}
}

class PumpHardwareType {
	constructor(hardware_type) {
		this.hardware_type = hardware_type;
		let parts = hardware_type.split(':');
		this.code = parts[0];
	}
}
class PumpProtocolType {
	constructor(protocol_type) {
		this.protocol_type = protocol_type;
		let parts = protocol_type.split(':');
		this.code = parts[0];
	}
}
class TelemetryInformations {
	constructor(module_name, version, is_connected, apn_name, apn_ip, signal_power, signal_quality, shipping_destination_type, operator_number, url_mqtt_conecttec, port_mqtt_conecttec, url_mqtt_companytec, port_mqtt_companytec) {
		this.module_name = module_name;
		this.version = version;
		this.is_connected = is_connected;
		this.apn_name = apn_name;
		this.apn_ip = apn_ip;
		this.signal_power = signal_power;
		this.signal_quality = signal_quality;
		this.shipping_destination_type = shipping_destination_type;
		this.operator_number = operator_number;
		this.url_mqtt_conecttec = url_mqtt_conecttec;
		this.port_mqtt_conecttec = port_mqtt_conecttec;
		this.url_mqtt_companytec = url_mqtt_companytec;
		this.port_mqtt_companytec = port_mqtt_companytec;
	}
}
class TelemetryOperators {
	constructor(operator_status, long_name, short_name, number, operator_type, is_enabled) {
		this.operator_status = operator_status;
		this.long_name = long_name;
		this.short_name = short_name;
		this.number = number;
		this.operator_type = operator_type;
		this.is_enabled = is_enabled;
	}
}
class PendingShippingDestinations {
	constructor(id, type) {
		this.id = id;
		this.type = type;
	}
}
class IcomInformations {
	constructor(number, serial_number, firmware_version, hardware_version) {
		this.number = number;
		this.serial_number = serial_number;
		this.firmware_version = firmware_version;
		this.hardware_version = hardware_version;
	}
}
class SessionInformation {
	constructor(user_name, user_level, certificate_expiration_date, session_expiration_date) {
		this.user_name = user_name;
		this.user_level = user_level;
		this.certificate_expiration_date = certificate_expiration_date;
		this.session_expiration_date = session_expiration_date;
	}
}
class NetworkInformation {
	constructor(ip, mac, broadcast_address, mask, gateway, hostname, dhcp, cable_connected, has_internet, mqtt_station_id
	) {
		this.ip = ip;
		this.mac = mac;
		this.broadcast_address = broadcast_address;
		this.mask = mask;
		this.gateway = gateway;
		this.hostname = hostname;
		this.dhcp = dhcp;
		this.cable_connected = cable_connected;
		this.has_internet = has_internet;
		this.mqtt_station_id = mqtt_station_id;
	}
}
class MusNetworkConfigs {
	constructor(ip, mask, gateway, network, dns1, dns2, dhcp) {
		this.ip = ip;
		this.mask = mask;
		this.gateway = gateway;
		this.network = network;
		this.dns1 = dns1;
		this.dns2 = dns2;
		this.dhcp = dhcp;
	}
}
class CloudDebug {
	constructor(id, tank_measurements, discharges, reconciliation_data, events) {
		this.id = id;
		this.tank_measurements = tank_measurements;
		this.discharges = discharges;
		this.reconciliation_data = reconciliation_data;
		this.events = events;
	}
}
class LockedCertificate {
	constructor(user_name, user_level) {
		this.user_name = user_name;
		this.user_level = user_level;
	}
}
class CriticalityLevel {
	constructor(id, name) {
		this.id = id;
		this.name = name;
	}
}
class Diagnosis {
	constructor(state_pump, type, diag_code, nozzles, idf_status, idf_diag, idf_type, comma_code, hardware, wireless_mac, wireless_signal, wireless_quality, nozzle_code_first_position_of_address) {
		this.state_pump = state_pump;
		this.type = type;
		this.diag_code = diag_code;
		this.nozzles = [];
		if (nozzles) {
			var quantity_nozzles = (nozzles.length / 2);
			for (var i = 0; i < quantity_nozzles; i++) {
				this.nozzles.push(nozzles.substr((i * 2), 2));
			}
		}
		this.idf_status = idf_status;
		this.idf_diag = idf_diag;
		this.idf_type = idf_type;

		this.comma_code = comma_code;
		this.hardware = hardware;
		this.wireless_mac = wireless_mac;
		this.wireless_signal = wireless_signal;
		this.wireless_quality = wireless_quality;
		this.nozzle_code_first_position_of_address = nozzle_code_first_position_of_address;

	}
}
class License {
	constructor(pump_management, tank_measurement, environmental_monitoring, reconciliation, integration_mus, glp_probe_type) {
		this.pump_management = pump_management;
		this.tank_measurement = tank_measurement;
		this.environmental_monitoring = environmental_monitoring;
		this.reconciliation = reconciliation;
		this.integration_mus = integration_mus;
		this.glp_probe_type = glp_probe_type;
	}
}
class NewLicense {
	constructor(pump_management, tank_measurement, environmental_monitoring, reconciliation, integration_mus, glp_probe_type) {
		this.pump_management = pump_management;
		this.tank_measurement = tank_measurement;
		this.environmental_monitoring = environmental_monitoring;
		this.reconciliation = reconciliation;
		this.integration_mus = integration_mus;
		this.glp_probe_type = glp_probe_type;
	}
}
class NozzleStatus {
	constructor(nozzle, nozzle_state, fuel_name, attendant_identifier, attendant_name, is_wirelles, nozzle_code_first_position_of_address) {
		this.nozzle = nozzle;
		if (nozzle_state.length == 1) {
			this.nozzle_state = nozzle_state;
			this.visualization = "";
		} else {
			this.nozzle_state = nozzle_state.substring(0, 1);
			this.visualization = nozzle_state.substring(1);
		}
		this.fuel_name = fuel_name;
		this.attendant_identifier = attendant_identifier;
		this.attendant_name = attendant_name;
		this.is_wirelles = is_wirelles;
		this.nozzle_code_first_position_of_address = nozzle_code_first_position_of_address;
	}
}
class Supply {
	constructor(id, total, volume, price, time, date, register, totals_volume_init, totals_volume_final, totals_money_init, totals_money_final, card_attendant, card_client, nozzle, tank_volume_init, tank_volume_final, odometer, comma_code, flags_sale, nozzle_code, tank, fuel_code, attendant_name, client_name) {
		this.id = id;
		this.total = total;
		this.volume = volume;
		this.price = price;
		this.time = time;
		this.date = date;
		this.register = register;
		this.totals_volume_init = totals_volume_init;
		this.totals_volume_final = totals_volume_final;
		this.totals_money_init = totals_money_init;
		this.totals_money_final = totals_money_final;
		this.card_attendant = card_attendant;
		this.card_client = card_client;
		this.nozzle = nozzle;
		this.tank_volume_init = tank_volume_init;
		this.tank_volume_final = tank_volume_final;
		this.odometer = odometer;
		this.comma_code = comma_code;
		this.flags_sale = flags_sale;
		this.nozzle_code = nozzle_code
		this.tank = tank;
		this.fuel_code = fuel_code;
		this.attendant_name = attendant_name;
		this.client_name = client_name;
	}
}
class salesByFuelTypesReport {
	constructor(id, id_fuel_type, volume, total, average_price, quantity, date, fuel_type) {
		this.id = id;
		this.id_fuel_type = id_fuel_type;
		this.volume = volume;
		this.total = total;
		this.average_price = average_price;
		this.quantity = quantity;
		this.date = date;
		this.fuel_type = fuel_type;
	}
}
class NozzleConfigInformation {
	constructor(icom, connector, address, position, sensor_type, sensor_mode, sensor_timeout) {
		this.icom = icom;
		this.connector = connector;
		this.address = address;
		this.position = position;
		this.sensor_type = sensor_type;
		this.sensor_mode = sensor_mode;
		this.sensor_timeout = sensor_timeout;
	}
}
class PowerSupplyInformation {
	constructor(firmware_version, hardware_version, load_bat, load_fb, serial_number, bat_12v_ok, bat_12v_charge_on, bat_12v_low_voltage, bat_12v_inv, bat_li_ion_ok, bat_li_charge_on, ac_power_on, output_power_on, backup_power_on, type, v_battery_pb, v_battery_li, v_line_5, v_line_16, v_in) {
		this.firmware_version = firmware_version;
		this.hardware_version = hardware_version;
		this.load_bat = load_bat;
		this.load_fb = load_fb;
		this.serial_number = serial_number;
		this.bat_12v_ok = bat_12v_ok;
		this.bat_12v_charge_on = bat_12v_charge_on;
		this.bat_12v_low_voltage = bat_12v_low_voltage;
		this.bat_12v_inv = bat_12v_inv;
		this.bat_li_ion_ok = bat_li_ion_ok;
		this.bat_li_charge_on = bat_li_charge_on;
		this.ac_power_on = ac_power_on;
		this.output_power_on = output_power_on;
		this.backup_power_on = backup_power_on;
		this.type = type;
		this.v_battery_pb = v_battery_pb;
		this.v_battery_li = v_battery_li;
		this.v_line_5 = v_line_5;
		this.v_line_16 = v_line_16;
		this.v_in = v_in;
	}
}
class PumpConfig {
	constructor(pump_type_name, hardware_type_name, channel, address, total_decimals, volum_decimals, price_decimals, nozzle_pos_a, tank_pos_a, fuel_pos_a, nozzle_pos_b, tank_pos_b, fuel_pos_b, nozzle_pos_c, tank_pos_c, fuel_pos_c, nozzle_pos_d, tank_pos_d, fuel_pos_d, nozzle_pos_e, tank_pos_e, fuel_pos_e, sensor_type, sensor_work_mode, time_sensor) {
		this.pump_type_name = pump_type_name;
		this.hardware_type_name = hardware_type_name;
		this.channel = channel;
		this.address = address;
		this.total_decimals = total_decimals;
		this.volum_decimals = volum_decimals;
		this.price_decimals = price_decimals;
		this.nozzle_pos_a = nozzle_pos_a;
		this.tank_pos_a = tank_pos_a;
		this.fuel_pos_a = fuel_pos_a;
		this.nozzle_pos_b = nozzle_pos_b;
		this.tank_pos_b = tank_pos_b;
		this.fuel_pos_b = fuel_pos_b;
		this.nozzle_pos_c = nozzle_pos_c;
		this.tank_pos_c = tank_pos_c;
		this.fuel_pos_c = fuel_pos_c;
		this.nozzle_pos_d = nozzle_pos_d;
		this.tank_pos_d = tank_pos_d;
		this.fuel_pos_d = fuel_pos_d;
		this.nozzle_pos_e = nozzle_pos_e;
		this.tank_pos_e = tank_pos_e;
		this.fuel_pos_e = fuel_pos_e;
		this.sensor_type = sensor_type
		this.sensor_work_mode = sensor_work_mode;
		this.time_sensor = time_sensor;
	}
}
class NozzleInformation {
	constructor(e_volum, e_money, p_cash, p_credit, p_deferred, fuel, total_decimals, volum_decimals, price_decimals, is_wirelles) {
		this.e_volum = e_volum;
		this.e_money = e_money;
		this.p_cash = p_cash;
		this.p_credit = p_credit;
		this.p_deferred = p_deferred;
		this.fuel = fuel;
		this.total_decimals = total_decimals;
		this.volum_decimals = volum_decimals;
		this.price_decimals = price_decimals;
		this.is_wirelles = is_wirelles;
	}
}
class TankModel {
	constructor(id, name, brand, volume, radius, length, arching_table_name, is_virtual, id_unit_length, id_unit_volume) {
		this.id = id;
		this.name = name;
		this.brand = brand;
		this.volume = volume;
		this.radius = radius;
		this.length = length;
		this.arching_table_name = arching_table_name;
		this.is_virtual = is_virtual;
		this.id_unit_length = id_unit_length;
		this.id_unit_volume = id_unit_volume;
	}
}
class TankInformations {


	constructor(name, number, probe_offset, alarm_on_probe_failure, id_tank_model, name_tank_model, brand_tank_model, volume_tank_model, diameter_tank_model, length_tank_model, id_fuel_type, name_fuel_type, density_fuel_type, thermal_coeficient_fuel_type, id_limits_profile, name_limits_profile, overflow_limits_profile, high_level_limits_profiles, delivery_limits_profiles, low_level_limits_profile, high_water_limits_profile, height_in_the_manhole, height_at_discharge_mouth, inclination_offset, critical_level_limits_profile, id_probe_type, probe_type_manufacturer, probe_type_model, probe_iso_channel, probe_iso_address) {
		this.name = name;
		this.number = number;
		this.probe_offset = probe_offset;
		this.alarm_on_probe_failure = alarm_on_probe_failure;
		this.id_tank_model = id_tank_model;
		this.name_tank_model = name_tank_model;
		this.brand_tank_model = brand_tank_model;
		this.volume_tank_model = volume_tank_model;
		this.diameter_tank_model = diameter_tank_model;
		this.length_tank_model = length_tank_model;
		this.id_fuel_type = id_fuel_type;
		this.name_fuel_type = name_fuel_type;
		this.density_fuel_type = density_fuel_type;
		this.thermal_coeficient_fuel_type = thermal_coeficient_fuel_type;
		this.id_limits_profile = id_limits_profile;
		this.name_limits_profile = name_limits_profile;
		this.overflow_limits_profile = overflow_limits_profile;
		this.high_level_limits_profiles = high_level_limits_profiles;
		this.delivery_limits_profiles = delivery_limits_profiles;
		this.low_level_limits_profile = low_level_limits_profile;
		this.high_water_limits_profile = high_water_limits_profile;
		this.height_in_the_manhole = height_in_the_manhole;
		this.height_at_discharge_mouth = height_at_discharge_mouth;
		this.inclination_offset = inclination_offset;
		this.critical_level_limits_profile = critical_level_limits_profile;
		this.id_probe_type = id_probe_type;
		this.probe_type_manufacturer = probe_type_manufacturer;
		this.probe_type_model = probe_type_model;
		this.probe_iso_channel = probe_iso_channel;
		this.probe_iso_address = probe_iso_address;
	}
}
//id_fuel_type aparece duas vezes no protocolo na alteraÃ§Ao das unidades de medida
class Tank {
	constructor(name, number, alarm_on_probe_failure, id_fuel_type, fuel_type_name, fuel_type_color, tank_model_id, tank_model_name, tank_model_volume, inclination_offset, probe_offset, id_limits_profile, limits_profile_name,
		probe_serial_number, before_probe_serial_number, probe_mvc_status, fuel_anp_name, fuel_anp_id, fuel_mvc_id) {
		this.name = name;
		this.number = number;
		this.alarm_on_probe_failure = alarm_on_probe_failure;
		this.id_fuel_type = id_fuel_type;
		this.fuel_type_name = fuel_type_name;
		this.fuel_type_color = fuel_type_color;
		this.tank_model_id = tank_model_id;
		this.tank_model_name = tank_model_name;
		this.tank_model_volume = tank_model_volume;
		this.inclination_offset = inclination_offset;
		this.probe_offset = probe_offset;
		this.id_limits_profile = id_limits_profile;
		this.limits_profile_name = limits_profile_name;
		this.probe_serial_number = probe_serial_number;
		this.before_probe_serial_number = before_probe_serial_number;
		this.probe_mvc_status = probe_mvc_status;
		this.fuel_anp_id = fuel_anp_id;
		this.fuel_anp_name = fuel_anp_name;
		this.fuel_mvc_id = fuel_mvc_id;
	}
}
class TypePrinters {
	constructor(id, name) {
		this.id = id;
		this.name = name;
	}
}
class AuxiliaryOutputs {
	constructor(id, name) {
		this.id = id;
		this.name = name;
	}
}
class AuxiliaryOutputsAlarmTypes {
	constructor(id, id_auxiliary_output, name_auxiliary_output, id_alarm_type, name_alarm_type, trigger_duration, trigger_recurrence) {
		this.id = id;
		this.id_auxiliary_output = id_auxiliary_output;
		this.name_auxiliary_output = name_auxiliary_output;
		this.id_alarm_type = id_alarm_type;
		this.name_alarm_type = name_alarm_type;
		this.trigger_duration = trigger_duration;
		this.trigger_recurrence = trigger_recurrence;
	}
}
class ProbeTypes {
	constructor(id, manufacturer, model) {
		this.id = id;
		this.manufacturer = manufacturer;
		this.model = model;
	}
}
class PrinterInformations {
	constructor(id, type_printer, ip, port) {
		this.id = id;
		this.type_printer = type_printer;
		this.ip = ip;
		this.port = port;
	}
}
class PwnSockets {
	constructor(socket, annonced, close_skt_request, is_repeater, keep_alive, type, rssi, lqi, short_address, pan_id, mac, firmware_version, virtual_channel, logical_addresses_0, logical_addresses_1, logical_addresses_2, logical_addresses_3, idf_version_0, idf_version_1, idf_version_2, idf_version_3) {
		this.socket = socket;
		this.annonced = annonced;
		this.close_skt_request = close_skt_request;
		this.is_repeater = is_repeater;
		this.keep_alive = keep_alive;
		this.type = type;
		this.rssi = rssi;
		this.lqi = lqi;
		this.short_address = short_address;
		this.pan_id = pan_id;
		this.mac = mac;
		this.firmware_version = firmware_version;
		this.virtual_channel = virtual_channel;
		this.logical_addresses_0 = logical_addresses_0;
		this.logical_addresses_1 = logical_addresses_1;
		this.logical_addresses_2 = logical_addresses_2;
		this.logical_addresses_3 = logical_addresses_3;
		this.idf_version_0 = idf_version_0;
		this.idf_version_1 = idf_version_1;
		this.idf_version_2 = idf_version_2;
		this.idf_version_3 = idf_version_3;
	}
}
class ReportDestinations {
	constructor(id, name) {
		this.id = id;
		this.name = name;

	}
}

class TankAlarmsCount {
	constructor(quantity) {
		this.quantity = quantity;
	}
}

class ArchingTableInformations {
	constructor(curve) {
		this.curve = curve;
	}
}

class LeakSensorAlarmsCount {
	constructor(quantity) {
		this.quantity = quantity;
	}
}
class UpdateGroupTypes {
	constructor(id, name) {
		this.id = id;
		this.name = name;
	}
}
class TankAlarms {
	constructor(id, tank_number, id_alarm_type, id_fuel_type, volum, limit_value, insertion_date, acknowledged_date, acknowledged_user_name, acknowledged_user_identifier, end_date, alarm_type_name, fuel_type_name, id_alarm_level, alarm_level, id_tank_model, id_unit_length, id_unit_volume) {
		this.id = id;
		this.tank_number = tank_number;
		this.id_alarm_type = id_alarm_type;
		this.id_fuel_type = id_fuel_type;
		this.volum = volum;
		this.limit_value = limit_value;
		this.insertion_date = insertion_date;
		this.acknowledged_date = acknowledged_date;
		this.acknowledged_user_name = acknowledged_user_name;
		this.acknowledged_user_identifier = acknowledged_user_identifier;
		this.end_date = end_date;
		this.alarm_type_name = alarm_type_name;
		this.fuel_type_name = fuel_type_name;
		this.id_alarm_level = id_alarm_level;
		this.alarm_level = alarm_level;
		this.id_tank_model = id_tank_model;
		this.id_unit_length = id_unit_length;
		this.id_unit_volume = id_unit_volume;
	}
}
class Discharges {
	constructor(id, tank, init_volume, init_time, preview_volume, preview_time, end_volume, end_time, fuel_height_init, fuel_height_end, fuel_volume_compensated_init, fuel_volume_compensated_end, water_volume_init, water_volume_end, water_height_init, water_height_end, temperature_init, temperature_end, manual_discharge, volume_discharged, volume_sold_during_discharge, id_fuel_type, id_tank_model, id_unit_length, id_unit_volume) {
		this.id = id;
		this.tank = tank;
		this.init_volume = init_volume;
		this.init_time = init_time;
		this.preview_volume = preview_volume;
		this.preview_time = preview_time;
		this.end_volume = end_volume;
		this.end_time = end_time;
		this.fuel_height_init = fuel_height_init;
		this.fuel_height_end = fuel_height_end;
		this.fuel_volume_compensated_init = fuel_volume_compensated_init;
		this.fuel_volume_compensated_end = fuel_volume_compensated_end;
		this.water_volume_init = water_volume_init;
		this.water_volume_end = water_volume_end;
		this.water_height_init = water_height_init;
		this.water_height_end = water_height_end;
		this.temperature_init = temperature_init;
		this.temperature_end = temperature_end;
		this.manual_discharge = manual_discharge;
		this.volume_discharged = volume_discharged;
		this.volume_sold_during_discharge = volume_sold_during_discharge;
		this.id_fuel_type = id_fuel_type;
		this.id_tank_model = id_tank_model;
		this.id_unit_length = id_unit_length;
		this.id_unit_volume = id_unit_volume;
	}
}
class Identifier {
	constructor(id, active, version, tag_id, flag_ctrl, tag_txt, usr_ctrl, name, discount, fuel_mask, hm_t1_start, hm_t1_stop, hm_t2_start, hm_t2_stop) {
		this.id = id;
		this.active = active;
		this.version = version;
		this.tag_id = tag_id;
		this.flag_ctrl = flag_ctrl;
		this.tag_txt = tag_txt;
		this.usr_ctrl = usr_ctrl;
		this.name = name;
		this.discount = discount;
		this.fuel_mask = fuel_mask;
		this.hm_t1_start = hm_t1_start;
		this.hm_t1_stop = hm_t1_stop;
		this.hm_t2_start = hm_t2_start;
		this.hm_t2_stop = hm_t2_stop;
	}
}
class Emails {
	constructor(id, name, email) {
		this.id = id;
		this.name = name;
		this.email = email;
	}
}
class EmailsAlarmTypes {
	constructor(id, id_email, id_alarm_type) {
		this.id = id;
		this.id_email = id_email;
		this.id_alarm_type = id_alarm_type;
	}
}
class EmailsReportTypes {
	constructor(id, id_email, email, email_name, id_report_type, report_type, hour, id_report_destiny, report_destiny_name) {
		this.id = id;
		this.id_email = id_email;
		this.email = email;
		this.email_name = email_name;
		this.id_report_type = id_report_type;
		this.report_type = report_type;
		this.hour = hour;
		this.id_report_destiny = id_report_destiny;
		this.report_destiny_name = report_destiny_name;
	}
}
class AlarmTypes {
	constructor(id, name) {
		this.id = id;
		this.name = name;
	}
}
class UpdateDetails {
	constructor(id, description, time, mandatory) {
		this.id = id;
		this.description = description;
		this.time = time;
		this.mandatory = mandatory;
	}
}
class ReportTypes {
	constructor(id, name) {
		this.id = id;
		this.name = name;
	}
}
class ActiveLeakSensor {
	constructor(id, version) {
		this.id = id;
		this.version = version;
	}
}
class ExternalMeterConfigs {
	constructor(ip, port) {
		this.ip = ip;
		this.version = port;
	}
}
class LeakSensorStatus {
	constructor(address, name, alarm_level, alarm_description, alarm_type, serial_number) {
		this.address = address;
		this.name = name;
		this.alarm_level = alarm_level;
		this.alarm_description = alarm_description;
		this.alarm_type = alarm_type;
		this.serial_number = serial_number;
	}
}
class LeakSensorAlarms {
	constructor(id, address, id_alarm_type, insertion_date, acknowledged_date, acknowledged_user_name, acknowledged_user_identifier, end_date, alarm_message, leak_sensor_name, id_alarm_level) {
		this.id = id;
		this.address = address;
		this.id_alarm_type = id_alarm_type;
		this.insertion_date = insertion_date;
		this.acknowledged_date = acknowledged_date;
		this.acknowledged_user_name = acknowledged_user_name;
		this.acknowledged_user_identifier = acknowledged_user_identifier;
		this.end_date = end_date;
		this.alarm_message = alarm_message;
		this.leak_sensor_name = leak_sensor_name;
		this.id_alarm_level = id_alarm_level;
	}
}
class LeakSensor {
	constructor(address, name) {
		this.address = address;
		this.name = name;
	}
}
class TankStatus {
	constructor(name, fuel_type_name, fuel_type_color, number, volume, fuel_height, fuel_volume, water_height, water_volume, temperature, alarm_level_description, discharge_status, discharge_value, measure_unit_length,measure_unit_volume) {
		this.name = name;
		this.fuel_type_name = fuel_type_name;
		this.fuel_type_color = fuel_type_color;
		this.number = number;
		this.volume = volume;
		this.fuel_height = fuel_height;
		this.fuel_volume = fuel_volume;
		this.water_height = water_height;
		this.water_volume = water_volume;
		this.temperature = temperature;
		this.alarm_level_description = alarm_level_description;
		this.discharge_status = discharge_status;
		this.discharge_value = discharge_value;
		this.measure_unit_length = measure_unit_length;
		this.measure_unit_volume = measure_unit_volume;
	}
}
class LimitsProfile {
	constructor(id, name, overflow, high_level, delivery, low_level, high_water, critical_level) {
		this.id = id;
		this.name = name;
		this.overflow = overflow;
		this.high_level = high_level;
		this.delivery = delivery;
		this.low_level = low_level;
		this.high_water = high_water;
		this.critical_level = critical_level;
	}
}
class ArchingTable {
	constructor(height, volume) {
		this.height = height;
		this.volume = volume;
	}
}
class ArchingTables {
	constructor(name) {
		this.name = name;
	}
}
class PwnInformations {
	constructor(qty_swc_connected, network_state, channel_used, dac, channel_setted, firmware_version, qty_swc_white_list, pairing) {
		this.qty_swc_connected = qty_swc_connected;
		this.network_state = network_state;
		this.channel_used = channel_used;
		this.dac = dac;
		this.channel_setted = channel_setted;
		this.firmware_version = firmware_version;
		this.qty_swc_white_list = qty_swc_white_list;
		this.pairing = pairing;

	}
}
class Login {
	constructor(user_name, level, sap_code, token) {
		this.user_name = user_name;
		this.level = level;
		this.sap_code = sap_code;
		this.token = token;
	}
}
class FuelType {
	constructor(id, name) {
		this.id = id;
		this.name = name;
	}
}
class MeasureUnitsOfLength {
	constructor(id, unit_abbreviation, unit_name) {
		this.id = id;
		this.unit_abbreviation = unit_abbreviation;
		this.unit_name = unit_name;
	}
}
class MeasureUnitsOfVolume {
	constructor(id, unit_abbreviation, unit_name) {
		this.id = id;
		this.unit_abbreviation = unit_abbreviation;
		this.unit_name = unit_name;
	}
}
class Fuels {
	constructor(id, id_fuel_type, name, density, color, thermal_coefficient, sysgrade, anp_name, anp_id, mvc_id, fuel_type_name) {
		this.id = id;
		this.id_fuel_type = id_fuel_type;
		this.name = name;
		this.density = density;
		this.color = color;
		this.thermal_coefficient = thermal_coefficient;
		this.sysgrade = sysgrade;
		this.anp_name = anp_name;
		this.anp_id = anp_id;
		this.mvc_id = mvc_id;
		this.fuel_type_name = fuel_type_name;
	}
}
class ProductMovementReport {
	constructor(id, tank_number, initial_tank_fuel_volume, final_tank_fuel_volume, volume_discharged_on_tank, diff_tank_fuel_volume, pump_volume_supplied, date) {
		this.id = id;
		this.tank_number = tank_number;
		this.initial_tank_fuel_volume = initial_tank_fuel_volume;
		this.final_tank_fuel_volume = final_tank_fuel_volume;
		this.volume_discharged_on_tank = volume_discharged_on_tank;
		this.diff_tank_fuel_volume = diff_tank_fuel_volume;
		this.pump_volume_supplied = pump_volume_supplied;
		this.date = date;
	}
}
class TankInventoryHistoric {
	constructor(id, datetime, tank, fuel_height, fuel_volume, water_height, water_volume, inf_temperature, sup_temperature) {
		this.id = id;
		this.datetime = datetime;
		this.tank = tank;
		this.fuel_height = fuel_height;
		this.fuel_volume = fuel_volume;
		this.water_height = water_height;
		this.water_volume = water_volume;
		this.inf_temperature = inf_temperature;
		this.sup_temperature = sup_temperature;
	}
}
class SearchUpdate {
	constructor(type, version, date_version, group_name, description) {
		this.type = type;
		this.version = version;
		this.date_version = date_version;
		this.group_name = group_name;
		this.description = description;
	}
}
class SufficiencyOfReconciliationData {
	constructor(curves_to_complete_arching) {
		this.curves_to_complete_arching = curves_to_complete_arching;
	}
}
class VolumeDifferenceOfReconciliationData {
	constructor(curves) {
		this.curves = curves;
	}
}
class ReconciliationArchingTableComparison {
	constructor(curves_to_complete_arching) {
		this.curves_to_complete_arching = curves_to_complete_arching;
	}
}
class ListUser {
	constructor(id, name, user_name, level, active, rfid_tag) {
		this.id = id;
		this.name = name;
		this.user_name = user_name;
		this.level = level;
		this.active = active;
		this.rfid_tag = rfid_tag;
	}
}
class VersionInformations {
	constructor(concept_version, date_version, group_name, automatic_update, description, database_version, minimum_version_allowed_for_downgrade, id_group_upgrade) {
		this.concept_version = concept_version;
		this.date_version = date_version;
		this.group_name = group_name;
		this.automatic_update = automatic_update;
		this.description = description;
		this.database_version = database_version;
		this.minimum_version_allowed_for_downgrade = minimum_version_allowed_for_downgrade;
		this.id_group_upgrade = id_group_upgrade;
	}
}
class NotifyTagRead {
	constructor(tag_code, ds_fid) {
		this.tag_code = tag_code;
		this.ds_fid = ds_fid;
	}
}
class NotifyTankAlarm {
	constructor(level, tank_number, id_alarm_type, alarm_message, fuel_type_name, value, limit_value) {
		this.level = level;
		this.tank_number = tank_number;
		this.id_alarm_type = id_alarm_type;
		this.alarm_message = alarm_message;
		this.fuel_type_name = fuel_type_name;
		this.value = value;
		this.limit_value = limit_value;
	}
}
class DownloadUpdateProgress {
	constructor(MBytes_total, MBytes_downloaded, download_speed_KB_s) {
		this.MBytes_total = MBytes_total;
		this.MBytes_downloaded = MBytes_downloaded;
		this.download_speed_KB_s = download_speed_KB_s;
	}
}
class NotifySensorLeakAlarm {
	constructor(level, tank_number, id_alarm_type, alarm_message) {
		this.level = level;
		this.tank_number = tank_number;
		this.id_alarm_type = id_alarm_type;
		this.alarm_message = alarm_message;
	}
}
class NozzleMapping {
	constructor(nozzle, icom, connector, nozzle_code, e_volume) {
		this.nozzle = nozzle;
		this.icom = icom;
		this.connector = connector;
		this.nozzle_code = nozzle_code;
		this.e_volume = e_volume;
	}
}
class EVENT {
	constructor(id, register, date, process_identifier, id_event_type, description, id_criticality_level, parameters) {
		this.id = id;
		this.register = register;
		this.date = date;
		this.process_identifier = process_identifier;
		this.id_event_type = id_event_type;
		this.description = description;
		this.id_criticality_level = id_criticality_level;
		this.parameters = parameters;
	}
}
class MessageReturn {
	constructor(message) {
		this.message = message;
	}
}
class Calendar {
	constructor(datetime) {
		let parts = datetime.split(' ');
		this.date = parts[0];
		this.hour = parts[1];
	}
}
class Language {
	constructor(id) {
		this.id = id;
		switch (id) {
			case "1":
				this.name = "PortuguÃªs-BR";
				this.message = "Linguagem alterada para " + this.name;
				break;
			case "2":
				this.name = "EspaÃ±ol-ES";
				this.message = "Idioma cambiado a " + this.name;
				break;
			case "3":
				this.name = "English-USA";
				this.message = "Language changed to " + this.name;
				break;
			default:
				this.name = "Indefinido";
		}
	}
}
class Shutdown {
	constructor(message) {
		this.message = message;
	}
}