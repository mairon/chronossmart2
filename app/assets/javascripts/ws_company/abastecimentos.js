var PAGE;

var Daterangepicker = {
	init: function () {
		! function () {
			$("#dt_range, #dt_range_modal, #dt_range_export").daterangepicker({
				buttonClasses: "m-btn btn",
				applyClass: "btn-primary",
				cancelClass: "btn-secondary",
				startDate: '-1d'
			}, function (start, end, label) {
				//init = start.format('DD/MM/YYYY')
				//finish = end.format('DD/MM/YYYY');
				filter();
			});
		}(), $("#dt_range_validate").daterangepicker({
			buttonClasses: "m-btn btn",
			applyClass: "btn-primary",
			cancelClass: "btn-secondary"
		}, function (a, t, n) {
			$("#dt_range_validate .form-control").val(a.format("YYYY-MM-DD") + " / " + t.format("YYYY-MM-DD"));
		})
	}
};

function filter() {
	$('#spin_refresh').addClass('fa-spin');
	PAGE = 1; 
	supplies();
}

$("#nozzle_code").on("change", function () {
	filter();
})

function supplies() {
	let language_id = get_cookie('language');
	let label_wait = ["Aguarde", "Espere", "Wait"];
	block_screen(label_wait[(Number(language_id) - 1)])
	let nozzle_code = $("#nozzle_code").val() == "" ? "0" : $("#nozzle_code").val()
	$("#dt_range").attr("disabled", false);
	let limit = Number($("#showing").val());
	let offset = (PAGE - 1) * limit;
	limit = limit + 1;
	let date_init = $('#dt_range').data('daterangepicker').startDate.format('YYYY-MM-DD');
	let date_end = $('#dt_range').data('daterangepicker').endDate.format('YYYY-MM-DD');
	PC.send_command('read', 'supplies', '{"offset": "' + offset + '","limit": "' + limit + '","nozzle": "' + nozzle_code + '","date_init": "' + date_init + '","date_end": "' + date_end + '","card_attendant": "-1","card_client": "-1","fuel_code": "0"}', callback_supplies, null);
}

function callback_supplies(data_json, callback_function) {
 
	let data = JSON.parse(data_json);
	if (data.state === 'success') {
		if (data.state) {
			swal.close();
			insert_rows(data.data);
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
	$('#spin_refresh').removeClass('fa-spin');
}

function insert_rows(data) {
	// console.log(data)
	let table = document.getElementById('table_1');
	let rowLength = table.rows.length;
	for (let i = 0; i < rowLength; i += 1) {
		table.deleteRow(0);
	}
	if (data.length != 0) {
		$("#previews").removeClass('disabled');
		$("#forward").removeClass('disabled');
		$("#first").removeClass('disabled');
	}

	let limit = $("#showing").val();
	if (data.length <= limit) {
		$("#forward").addClass('disabled');
	}

	if (PAGE == 1) {
		$("#previews").addClass('disabled')
		$("#first").addClass('disabled');
	}

	data = data.slice(0, $("#showing").val());

	for (let index in data) {
		let row = table.insertRow(-1);
		let cel_0 = row.insertCell(0);
		let cel_1 = row.insertCell(1);
		let cel_2 = row.insertCell(2);
		let cel_3 = row.insertCell(3);
		let cel_4 = row.insertCell(4);
		let cel_5 = row.insertCell(5);
		let cel_6 = row.insertCell(6);
		let cel_7 = row.insertCell(7);
		let cel_8 = row.insertCell(8);
		let cel_9 = row.insertCell(9);
		let cel_10 = row.insertCell(10);
		let cel_11 = row.insertCell(11);
		let cel_12 = row.insertCell(12);
		let cel_13 = row.insertCell(13);
		let cel_14 = row.insertCell(14);
		let cel_15 = row.insertCell(15);
		let cel_16 = row.insertCell(16);
		let cel_17 = row.insertCell(17);
		let cel_18 = row.insertCell(18);
		let cel_19 = row.insertCell(19);
		let cel_20 = row.insertCell(20);
		let cel_21 = row.insertCell(21);
		let cel_22 = row.insertCell(22);
		cel_0.innerHTML = data[index].register;
		cel_1.innerHTML = data[index].nozzle;
		cel_2.innerHTML = data[index].fuel_code;
		cel_3.innerHTML = data[index].tank;
		cel_4.innerHTML = data[index].total;
		cel_5.innerHTML = data[index].volume;
		cel_6.innerHTML = data[index].price;
		cel_7.innerHTML = data[index].time;
		cel_8.innerHTML = data[index].date.split(' ')[0];
		cel_9.innerHTML = data[index].date.split(' ')[1];
		
		cel_10.innerHTML = data[index].totals_volume_init;
		cel_11.innerHTML = data[index].totals_volume_final;
		cel_12.innerHTML = data[index].attendant_name == "" ? data[index].card_attendant : data[index].attendant_name;
		cel_13.innerHTML = data[index].client_name == "" ? data[index].card_client : data[index].client_name;
		cel_14.innerHTML = data[index].odometer;
		cel_15.innerHTML = data[index].totals_money_init;
		cel_16.innerHTML = data[index].totals_money_final;
		cel_17.innerHTML = data[index].nozzle_code;
		cel_18.innerHTML = data[index].tank_volume_init;
		cel_19.innerHTML = data[index].tank_volume_final;
		cel_20.innerHTML = data[index].comma_code;
		cel_21.innerHTML = data[index].flags_sale;
		cel_22.innerHTML = data[index].id;
	}
}

function get_current_page(element) {
	let modify = $(element).attr('rel');
	let current_page = PAGE + Number(modify);
	change_page(current_page);
}

function change_page(current_page) {
	PAGE = current_page + 1;
	supplies();
}

function change_showing() {
	filter();
}

jQuery(document).ready(function () {
	// if(!document.cookie.toUpperCase().includes('PARCEIRO')) window.location.href = "/view/home.html";
	let nozzle_link = 'http://132.255.166.179/view/arquivos/bombas/abastecimentos.html';
	$("#nozzle_code").val(nozzle_link.split("?")[1]);
	Daterangepicker.init();
	connecting(filter);
});

function block_screen(message) {
	if (message !== null) {
		sweetAlert({
			onBeforeOpen: () => {
				Swal.showLoading()
			},
			type: 'info',
			text: message,
			showConfirmButton: false,
			html: "",
			allowOutsideClick: false
		}, function () { });
	}
}

function export_function() {
	defineExport("abastecimentos.csv");
	$('#selectExportModal').modal('hide');
	if ($("#export_without_date").is(':checked')) {
		$("#div_progress_export").css("display", "block");
		PC.send_command('read', 'supplies', '{"offset": "' + 0 + '","limit": "-1","nozzle": "0","date_init": "-1","date_end": "-1","card_attendant": "-1","card_client": "-1","fuel_code": "0"}', callback_export, null, "export");
	} else {
		$("#div_progress_export").css("display", "none");
		let date_init = $('#dt_range_export').data('daterangepicker').startDate.format('YYYY-MM-DD');
		let date_end = $('#dt_range_export').data('daterangepicker').endDate.format('YYYY-MM-DD');
		PC.send_command('read', 'supplies', '{"offset": "' + 0 + '","limit": "-1","nozzle": "0","date_init": "' + date_init + '","date_end": "' + date_end + '","card_attendant": "-1","card_client": "-1","fuel_code": "0"}', callback_export, null, "export");
	}
}

$("#export_without_date").on('change', function () {
	if ($("#export_without_date").is(':checked')) {
		$("#dt_range_export").attr("disabled", true);
	} else {
		$("#dt_range_export").attr("disabled", false);
	}
})