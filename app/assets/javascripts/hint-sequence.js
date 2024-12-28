
$('#etapa2').click(function(){
	var enjoyhint_instance = new EnjoyHint({});

	var enjoyhint_script_steps = [
		{
			'click #402' : 'Clique en Facturación',
		},
		{
			'click #429' : "Selecione la opción de Caja/Banco"
		}
	];

	enjoyhint_instance.set(enjoyhint_script_steps);
	enjoyhint_instance.run();
});

$('#etapa3').click(function(){
	var enjoyhint_instance = new EnjoyHint({});

	var enjoyhint_script_steps = [
		{
			'click #404' : 'Clique en Stock',
		},
		{
			'mouseout #457' : 'Selecione la opción de Cadastrar Productos',
		},
		{
			'click #458' : 'Clique aqui'
		}
	];

	enjoyhint_instance.set(enjoyhint_script_steps);
	enjoyhint_instance.run();
});

$('#etapa4').click(function(){
	var enjoyhint_instance = new EnjoyHint({});

	var enjoyhint_script_steps = [
		{
			'click #401' : 'Clique en Catastros Operacionales',
		},
		{
			'click #412' : 'Selecione la opción Personas',
		}
	];

	enjoyhint_instance.set(enjoyhint_script_steps);
	enjoyhint_instance.run();
});


